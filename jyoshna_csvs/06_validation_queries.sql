-- =====================================================
-- EchoChain Validation Queries
-- Run AFTER schema + data load + views.
-- Take screenshots of each result for the project report.
-- =====================================================

-- 1. Row counts per table
SELECT 'products' AS table_name, COUNT(*) AS row_count FROM products
UNION ALL
SELECT 'bom', COUNT(*) FROM bom
UNION ALL
SELECT 'warranty_claims', COUNT(*) FROM warranty_claims
UNION ALL
SELECT 'ebay_listings', COUNT(*) FROM ebay_listings;

-- 2. Orphan checks (should return 0 rows each)
SELECT sku FROM bom WHERE sku NOT IN (SELECT sku FROM products);
SELECT sku FROM warranty_claims WHERE sku NOT IN (SELECT sku FROM products);

-- 3. Warranty claims referencing a component NOT in that SKU's BOM (should return 0 rows)
SELECT w.claim_id, w.sku, w.failed_component
FROM warranty_claims w
WHERE NOT EXISTS (
    SELECT 1 FROM bom b
    WHERE b.sku = w.sku AND b.component = w.failed_component
);

-- 4. eBay match quality
SELECT * FROM vw_teammate_match_quality;

-- 5. Top 10 Circularity Score products (candidates for buy-back/resale push)
SELECT * FROM (
    SELECT sku, brand, product_name, category, circularity_score,
           resale_value_retention_pct, warranty_claims_count
    FROM product_lifecycle_summary
    ORDER BY circularity_score DESC
)
WHERE ROWNUM <= 10;

-- 6. Bottom 10 Circularity Score products (candidates for redesign)
SELECT * FROM (
    SELECT sku, brand, product_name, category, circularity_score,
           resale_value_retention_pct, warranty_claims_count
    FROM product_lifecycle_summary
    ORDER BY circularity_score ASC
)
WHERE ROWNUM <= 10;

-- 7. Component failure leaderboard (which components fail most, across all SKUs)
SELECT failed_component,
       SUM(claim_count) AS total_claims,
       ROUND(AVG(avg_repair_cost), 2) AS avg_repair_cost
FROM vw_component_failure_metrics
GROUP BY failed_component
ORDER BY total_claims DESC;

-- 8. Refurbishment priority distribution
SELECT refurbishment_priority, COUNT(*) AS product_count
FROM product_lifecycle_summary
GROUP BY refurbishment_priority
ORDER BY product_count DESC;
