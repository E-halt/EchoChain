# EchoChain Dataset — Data Dictionary & Metric Guide

## Files

| File | Rows | Grain |
|---|---:|---|
| `products.csv` | 132 | One row per product SKU |
| `bom.csv` | 786 | One row per (SKU, Component) — multiple rows per SKU |
| `warranty_claims.csv` | 3,000 | One row per warranty claim event |
| `ebay_listings.csv` | 6,000 | One row per secondary-market listing |

Minimal 20-row test versions of each are in `/minimal` for the Oracle smoke-test step, built from the same 5 sample products so all joins resolve correctly.

## Why this replaces the previous (Shashank's) dataset

| Problem in previous dataset | Fix here |
|---|---|
| No products/MSRP table — couldn't compute Depreciation % or Resale Value Retention % | `products.csv` includes `MSRP` per SKU |
| SKU was generated per-component, not per-product, breaking the "1 SKU → many BOM rows" model | SKU is now a true product-level key; `bom.csv` has 4–8 rows per SKU depending on category |
| No link ensuring a warranty claim's failed component actually exists in that product's BOM | Every `Failed_Component` value is guaranteed to appear in that SKU's BOM rows |
| eBay price stored as a formatted string (`"$1,234.56"`), with some rows missing the price key entirely | `Price` is a clean numeric column in every row |

## Schema

### `products.csv`
| Column | Type | Notes |
|---|---|---|
| SKU | text, PK | e.g. `LAP-NIM-0002` |
| Brand | text | |
| Product_Name | text | Brand + model line, e.g. "Nimbus EliteBook X" |
| Category | text | Laptop / Smartphone / Tablet / Smartwatch / Wireless Earbuds |
| Launch_Year | int | 2021–2025 |
| MSRP | decimal | Original retail price — baseline for depreciation |

### `bom.csv`
| Column | Type | Notes |
|---|---|---|
| SKU | text, FK → products.SKU | |
| Component | text | e.g. "Motherboard", "Battery" |
| Component_Code | text | Short code, e.g. "MB", "BAT" |
| Supplier | text | |
| Component_Cost | decimal | Cost to source/replace that component |

### `warranty_claims.csv`
| Column | Type | Notes |
|---|---|---|
| Claim_ID | text, PK | |
| SKU | text, FK → products.SKU | |
| Failed_Component | text | Always matches a Component value from that SKU's BOM rows |
| Claim_Date | date | 2024–2026 |
| Days_In_Service | int | Age of unit at failure |
| Repair_Cost | decimal | |
| Resolution | text | Replaced / Repaired / Refunded / Pending |
| Failure_Symptom | text | Free-text symptom description |

### `ebay_listings.csv`
| Column | Type | Notes |
|---|---|---|
| Listing_ID | text, PK | |
| Title | text | Contains Brand + model line in free text, no SKU (matches real eBay data — must be joined via text match) |
| Condition | text | New / Open Box / Used - Excellent / Used - Good / Used - Fair / For Parts |
| Price | decimal | Clean numeric — no currency symbols |
| Seller_Rating | decimal or blank | ~5% intentionally blank, to test null handling |
| Seller_Location | text | |
| Listed_Date | date | |
| Watchers | int | |

**Match quality:** ~88% of listings (5,282 / 6,000) match a product via a direct `Brand` + model-line substring search in the title. The remaining ~12% require basic normalization (`UPPER()`, `TRIM()`, collapsing double spaces) — intentional, to give the SQL fuzzy-matching step (`05_teammate_analytics_views.sql`) real work to do, rather than a trivial 100% clean match.

## Metric formulas (for DAX / SQL views)

- **Depreciation %** = `1 - (AVG(ebay.Price for SKU) / products.MSRP)`
- **Resale Value Retention %** = `AVG(ebay.Price for SKU) / products.MSRP`
- **Warranty Claims per SKU** = `COUNT(warranty_claims.Claim_ID) GROUP BY SKU`
- **Average Repair Cost** = `AVG(warranty_claims.Repair_Cost) GROUP BY SKU or Failed_Component`
- **Estimated Recoverable Resale Value** = `AVG(ebay.Price for SKU, Condition IN ('Used - Excellent','Used - Good')) × units still serviceable`
- **Circularity Score** (suggested composite, define exact weights with the team): combine (a) Resale Value Retention %, (b) inverse of Warranty Claims per SKU, (c) inverse of Average Repair Cost relative to MSRP. Higher resale + lower failure + cheaper repairs = higher score.
- **Refurbishment Priority** = flag SKUs where `Average Repair Cost < (Estimated Recoverable Resale Value uplift)` — i.e., cheap to fix relative to what it's worth refurbished.

## Validation already run

- 0 orphaned SKUs in `bom.csv` or `warranty_claims.csv` (every SKU exists in `products.csv`)
- 0 warranty claims referencing a component not present in that SKU's BOM
- High-tier products show ~4x fewer warranty claims per SKU and ~1.6x better resale retention than Low-tier products, so the dashboard's high/low circularity contrast is real, not flat noise
