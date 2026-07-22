-- =====================================================
-- EchoChain Analytics Views
-- Run AFTER schema + data load.
-- =====================================================

-- ---------------------------------------------------------------
-- 1. BOM component value per SKU (total cost to fully rebuild a unit)
-- ---------------------------------------------------------------
CREATE OR REPLACE VIEW vw_bom_component_value AS
SELECT
    sku,
    COUNT(*)                AS component_count,
    SUM(component_cost)     AS total_bom_cost
FROM bom
GROUP BY sku;


-- ---------------------------------------------------------------
-- 2. Component failure metrics per SKU + component
-- ---------------------------------------------------------------
CREATE OR REPLACE VIEW vw_component_failure_metrics AS
SELECT
    w.sku,
    w.failed_component,
    COUNT(*)                    AS claim_count,
    ROUND(AVG(w.repair_cost),2) AS avg_repair_cost,
    ROUND(AVG(w.days_in_service),0) AS avg_days_in_service_at_failure
FROM warranty_claims w
GROUP BY w.sku, w.failed_component;


-- ---------------------------------------------------------------
-- 3. eBay listing -> SKU text match
-- Title has no SKU. Match on Brand + model line appearing in the
-- (normalized) title. Whitespace/case-normalized to catch messy listings.
-- Picks the most specific (longest product_name) match per listing.
-- ---------------------------------------------------------------
CREATE OR REPLACE VIEW vw_ebay_listing_matches AS
SELECT listing_id, sku, product_name, brand, category, msrp,
       listing_condition, price, seller_rating, seller_location,
       listed_date, watchers
FROM (
    SELECT
        e.listing_id,
        p.sku,
        p.product_name,
        p.brand,
        p.category,
        p.msrp,
        e.listing_condition,
        e.price,
        e.seller_rating,
        e.seller_location,
        e.listed_date,
        e.watchers,
        ROW_NUMBER() OVER (
            PARTITION BY e.listing_id
            ORDER BY LENGTH(p.product_name) DESC
        ) AS rn
    FROM ebay_listings e
    JOIN products p
      ON INSTR(UPPER(REGEXP_REPLACE(e.title, '[[:space:]]+', ' ')), UPPER(p.brand)) > 0
     AND INSTR(UPPER(REGEXP_REPLACE(e.title, '[[:space:]]+', ' ')),
                UPPER(TRIM(SUBSTR(p.product_name, LENGTH(p.brand) + 2)))) > 0
)
WHERE rn = 1;


-- ---------------------------------------------------------------
-- 4. Match quality summary (unmatched listings = fuzzy-match backlog)
-- ---------------------------------------------------------------
CREATE OR REPLACE VIEW vw_teammate_match_quality AS
SELECT
    (SELECT COUNT(*) FROM ebay_listings)          AS total_listings,
    (SELECT COUNT(*) FROM vw_ebay_listing_matches) AS matched_listings,
    (SELECT COUNT(*) FROM ebay_listings) - (SELECT COUNT(*) FROM vw_ebay_listing_matches) AS unmatched_listings,
    ROUND(
      (SELECT COUNT(*) FROM vw_ebay_listing_matches) * 100.0 / (SELECT COUNT(*) FROM ebay_listings), 2
    ) AS match_rate_pct
FROM dual;


-- ---------------------------------------------------------------
-- 5. Master product lifecycle summary — feeds the PowerBI dashboard directly
-- ---------------------------------------------------------------
CREATE OR REPLACE VIEW product_lifecycle_summary AS
SELECT
    p.sku,
    p.brand,
    p.product_name,
    p.category,
    p.launch_year,
    p.msrp,
    NVL(bv.total_bom_cost, 0)          AS total_bom_cost,
    NVL(wc.claim_count, 0)             AS warranty_claims_count,
    NVL(wc.avg_repair_cost, 0)         AS avg_repair_cost,
    NVL(rv.avg_resale_price, 0)        AS avg_resale_price,
    NVL(rv.listing_count, 0)           AS ebay_listing_count,
    -- Resale Value Retention % = avg resale price / MSRP
    ROUND(NVL(rv.avg_resale_price, 0) / p.msrp * 100, 1) AS resale_value_retention_pct,
    -- Depreciation % = 1 - retention
    ROUND(100 - (NVL(rv.avg_resale_price, 0) / p.msrp * 100), 1) AS depreciation_pct,
    -- Estimated Recoverable Resale Value = avg resale price (Used - Excellent/Good) * listing volume proxy
    NVL(rv_good.avg_good_condition_price, 0) AS est_recoverable_resale_value,
    -- Circularity Score (0-100 composite): higher resale retention + lower failure rate + lower repair cost = higher score
    ROUND(
        GREATEST(0, LEAST(100,
            (NVL(rv.avg_resale_price, 0) / p.msrp * 100) * 0.5
            - (NVL(wc.claim_count, 0)) * 0.8
            + 50
        ))
    , 1) AS circularity_score,
    -- Refurbishment Priority: cheap to fix relative to what it's worth used
    CASE
        WHEN NVL(wc.avg_repair_cost, 0) > 0
         AND NVL(rv_good.avg_good_condition_price, 0) > NVL(wc.avg_repair_cost, 0) * 1.5
        THEN 'High'
        WHEN NVL(wc.avg_repair_cost, 0) > 0
         AND NVL(rv_good.avg_good_condition_price, 0) > NVL(wc.avg_repair_cost, 0)
        THEN 'Medium'
        ELSE 'Low'
    END AS refurbishment_priority
FROM products p
LEFT JOIN vw_bom_component_value bv ON bv.sku = p.sku
LEFT JOIN (
    SELECT sku, SUM(claim_count) AS claim_count, ROUND(AVG(avg_repair_cost),2) AS avg_repair_cost
    FROM vw_component_failure_metrics
    GROUP BY sku
) wc ON wc.sku = p.sku
LEFT JOIN (
    SELECT sku, ROUND(AVG(price),2) AS avg_resale_price, COUNT(*) AS listing_count
    FROM vw_ebay_listing_matches
    GROUP BY sku
) rv ON rv.sku = p.sku
LEFT JOIN (
    SELECT sku, ROUND(AVG(price),2) AS avg_good_condition_price
    FROM vw_ebay_listing_matches
    WHERE listing_condition IN ('Used - Excellent', 'Used - Good')
    GROUP BY sku
) rv_good ON rv_good.sku = p.sku;
