# Oracle SQL Developer — CSV Import Guide

## Step order (matters — FK dependencies)

1. Run `04_schema_oracle.sql` to create empty tables.
2. Test with the minimal set first: run `07_minimal_20_insert_script.sql`, then `05_analytics_views.sql`, then `06_validation_queries.sql`. Confirm everything works before loading the full files.
3. Once the minimal test passes, **truncate the 4 tables** (`TRUNCATE TABLE ebay_listings; TRUNCATE TABLE warranty_claims; TRUNCATE TABLE bom; TRUNCATE TABLE products;` — in that order, to respect FKs) and load the full CSVs instead.

## Importing the full CSVs (6,000 / 3,000 / 786 / 132 rows — use the Import Wizard, not manual INSERTs)

For each file, in this order — **products.csv → bom.csv → warranty_claims.csv → ebay_listings.csv**:

1. Right-click the target table in the Connections tree → **Import Data...**
2. Browse to the CSV file.
3. On the **Column Mappings** screen, verify each column's data type matches the schema:
   - `msrp`, `component_cost`, `repair_cost`, `price` → **NUMBER**, not VARCHAR2
   - `claim_date`, `listed_date` → **DATE**, format mask `YYYY-MM-DD`
   - `launch_year`, `days_in_service`, `watchers` → **NUMBER**
4. For `ebay_listings.csv`, the target column is `listing_condition`, not `condition` — map the CSV's `Condition` column to `listing_condition`.
5. `Seller_Rating` has some blank values (~5% of rows, intentional) — make sure the wizard treats empty string as NULL, not `0`.
6. Run the import, then re-run the row-count query from `06_validation_queries.sql` to confirm all rows landed (132 / 786 / 3,000 / 6,000).

## Common import errors and fixes

| Error | Cause | Fix |
|---|---|---|
| `ORA-01722: invalid number` | A numeric column got mapped to text, or a stray comma/`$` sign is in the value | Re-check column mapping; this dataset's Price column is already clean numeric so this usually means a mapping mismatch |
| `ORA-01858: not a valid month` | Date format mismatch | Confirm date format mask is `YYYY-MM-DD` in the wizard |
| `ORA-02291: integrity constraint violated (parent key not found)` | Loaded `bom` or `warranty_claims` before `products` | Reload in the correct order: products first |

## After loading

Re-run `05_analytics_views.sql` (views auto-refresh against the new data, no need to recreate) and `06_validation_queries.sql`. Check:
- `vw_teammate_match_quality` — expect ~88% match rate on the full 6,000-row eBay set
- Query #3 (orphaned warranty components) — should return 0 rows

## Note on the Circularity Score formula

The formula in `product_lifecycle_summary` (`05_analytics_views.sql`) is a **starting point**, not final:

```
circularity_score = (resale_retention_pct * 0.5) - (claim_count * 0.8) + 50
```

This is a reasonable placeholder to get the dashboard working end-to-end, but the weighting (0.5 / 0.8 / the +50 baseline) is arbitrary. Suhasini should review this against real output — if High-tier products aren't clearly separating from Low-tier ones in the query #5/#6 results, adjust the weights before finalizing the DAX version for PowerBI.
