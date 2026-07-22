-- =====================================================
-- EchoChain minimal 20-row test data (Oracle INSERT)
-- Run AFTER 04_schema_oracle.sql
-- Load order: products -> bom -> warranty_claims -> ebay_listings
-- =====================================================

-- products (5 rows)
INSERT INTO products (sku, brand, product_name, category, launch_year, msrp) VALUES ('EAR-ZEN-0001', 'Zenith', 'Zenith Buds Air Pro', 'Wireless Earbuds', 2024, 279.2);
INSERT INTO products (sku, brand, product_name, category, launch_year, msrp) VALUES ('LAP-ORB-0001', 'Orbital', 'Orbital TravelLite 12', 'Laptop', 2025, 1318.7);
INSERT INTO products (sku, brand, product_name, category, launch_year, msrp) VALUES ('LAP-NIM-0002', 'Nimbus', 'Nimbus EliteBook X', 'Laptop', 2024, 819.08);
INSERT INTO products (sku, brand, product_name, category, launch_year, msrp) VALUES ('TAB-EMB-0001', 'Emberline', 'Emberline Canvas 11', 'Tablet', 2024, 458.82);
INSERT INTO products (sku, brand, product_name, category, launch_year, msrp) VALUES ('WCH-NIM-0001', 'Nimbus', 'Nimbus Watch S1', 'Smartwatch', 2024, 457.23);

-- bom (20 rows)
INSERT INTO bom (sku, component, component_code, supplier, component_cost) VALUES ('EAR-ZEN-0001', 'Battery', 'BAT', 'Pegatron', 7.01);
INSERT INTO bom (sku, component, component_code, supplier, component_cost) VALUES ('EAR-ZEN-0001', 'Speaker Driver', 'SPD', 'Luxshare ICT', 8.65);
INSERT INTO bom (sku, component, component_code, supplier, component_cost) VALUES ('EAR-ZEN-0001', 'Charging Case', 'CSE', 'Pegatron', 11.71);
INSERT INTO bom (sku, component, component_code, supplier, component_cost) VALUES ('EAR-ZEN-0001', 'Bluetooth Chip', 'BTC', 'Pegatron', 3.98);
INSERT INTO bom (sku, component, component_code, supplier, component_cost) VALUES ('LAP-ORB-0001', 'Motherboard', 'MB', 'Pegatron', 180.46);
INSERT INTO bom (sku, component, component_code, supplier, component_cost) VALUES ('LAP-ORB-0001', 'Display Panel', 'DSP', 'Foxlink Corp', 158.54);
INSERT INTO bom (sku, component, component_code, supplier, component_cost) VALUES ('LAP-ORB-0001', 'Battery', 'BAT', 'Pegatron', 61.32);
INSERT INTO bom (sku, component, component_code, supplier, component_cost) VALUES ('LAP-ORB-0001', 'SSD Storage', 'SSD', 'Luxshare ICT', 100.81);
INSERT INTO bom (sku, component, component_code, supplier, component_cost) VALUES ('LAP-ORB-0001', 'RAM Module', 'RAM', 'Luxshare ICT', 66.22);
INSERT INTO bom (sku, component, component_code, supplier, component_cost) VALUES ('LAP-ORB-0001', 'Keyboard Assembly', 'KB', 'Foxlink Corp', 29.29);
INSERT INTO bom (sku, component, component_code, supplier, component_cost) VALUES ('LAP-ORB-0001', 'Cooling Fan', 'FAN', 'Delta Electronics', 5.47);
INSERT INTO bom (sku, component, component_code, supplier, component_cost) VALUES ('LAP-ORB-0001', 'Webcam Module', 'CAM', 'Foxlink Corp', 8.73);
INSERT INTO bom (sku, component, component_code, supplier, component_cost) VALUES ('LAP-NIM-0002', 'Motherboard', 'MB', 'Quanta Computer', 120.26);
INSERT INTO bom (sku, component, component_code, supplier, component_cost) VALUES ('LAP-NIM-0002', 'Display Panel', 'DSP', 'Luxshare ICT', 122.61);
INSERT INTO bom (sku, component, component_code, supplier, component_cost) VALUES ('LAP-NIM-0002', 'Battery', 'BAT', 'Pegatron', 20.94);
INSERT INTO bom (sku, component, component_code, supplier, component_cost) VALUES ('LAP-NIM-0002', 'SSD Storage', 'SSD', 'Quanta Computer', 89.66);
INSERT INTO bom (sku, component, component_code, supplier, component_cost) VALUES ('LAP-NIM-0002', 'RAM Module', 'RAM', 'Quanta Computer', 34.78);
INSERT INTO bom (sku, component, component_code, supplier, component_cost) VALUES ('LAP-NIM-0002', 'Keyboard Assembly', 'KB', 'Luxshare ICT', 33.93);
INSERT INTO bom (sku, component, component_code, supplier, component_cost) VALUES ('LAP-NIM-0002', 'Cooling Fan', 'FAN', 'Pegatron', 18.99);
INSERT INTO bom (sku, component, component_code, supplier, component_cost) VALUES ('LAP-NIM-0002', 'Webcam Module', 'CAM', 'Pegatron', 3.83);

-- warranty_claims (20 rows)
INSERT INTO warranty_claims (claim_id, sku, failed_component, claim_date, days_in_service, repair_cost, resolution, failure_symptom) VALUES ('WC-00015', 'WCH-NIM-0001', 'Logic Board', TO_DATE('2024-07-03', 'YYYY-MM-DD'), 929, 110.86, 'Replaced', 'Battery drains fast');
INSERT INTO warranty_claims (claim_id, sku, failed_component, claim_date, days_in_service, repair_cost, resolution, failure_symptom) VALUES ('WC-00021', 'WCH-NIM-0001', 'Sensor Module', TO_DATE('2026-01-15', 'YYYY-MM-DD'), 693, 56.78, 'Repaired', 'Cracked/damaged');
INSERT INTO warranty_claims (claim_id, sku, failed_component, claim_date, days_in_service, repair_cost, resolution, failure_symptom) VALUES ('WC-00043', 'LAP-NIM-0002', 'Display Panel', TO_DATE('2025-10-30', 'YYYY-MM-DD'), 489, 243.32, 'Repaired', 'Not charging');
INSERT INTO warranty_claims (claim_id, sku, failed_component, claim_date, days_in_service, repair_cost, resolution, failure_symptom) VALUES ('WC-00046', 'TAB-EMB-0001', 'Charging Port', TO_DATE('2024-04-11', 'YYYY-MM-DD'), 582, 48.35, 'Refunded', 'Overheating');
INSERT INTO warranty_claims (claim_id, sku, failed_component, claim_date, days_in_service, repair_cost, resolution, failure_symptom) VALUES ('WC-00101', 'LAP-NIM-0002', 'Battery', TO_DATE('2026-03-14', 'YYYY-MM-DD'), 457, 72.51, 'Refunded', 'Won''t power on');
INSERT INTO warranty_claims (claim_id, sku, failed_component, claim_date, days_in_service, repair_cost, resolution, failure_symptom) VALUES ('WC-00105', 'LAP-ORB-0001', 'Motherboard', TO_DATE('2024-04-14', 'YYYY-MM-DD'), 393, 285.18, 'Replaced', 'Overheating');
INSERT INTO warranty_claims (claim_id, sku, failed_component, claim_date, days_in_service, repair_cost, resolution, failure_symptom) VALUES ('WC-00139', 'LAP-NIM-0002', 'Battery', TO_DATE('2025-11-05', 'YYYY-MM-DD'), 536, 67.24, 'Repaired', 'Battery drains fast');
INSERT INTO warranty_claims (claim_id, sku, failed_component, claim_date, days_in_service, repair_cost, resolution, failure_symptom) VALUES ('WC-00150', 'LAP-ORB-0001', 'RAM Module', TO_DATE('2026-06-09', 'YYYY-MM-DD'), 224, 187.81, 'Refunded', 'Won''t power on');
INSERT INTO warranty_claims (claim_id, sku, failed_component, claim_date, days_in_service, repair_cost, resolution, failure_symptom) VALUES ('WC-00169', 'LAP-NIM-0002', 'Cooling Fan', TO_DATE('2024-02-09', 'YYYY-MM-DD'), 925, 68.39, 'Pending', 'Unresponsive');
INSERT INTO warranty_claims (claim_id, sku, failed_component, claim_date, days_in_service, repair_cost, resolution, failure_symptom) VALUES ('WC-00176', 'TAB-EMB-0001', 'Touch Display', TO_DATE('2026-03-18', 'YYYY-MM-DD'), 914, 172.4, 'Repaired', 'Won''t power on');
INSERT INTO warranty_claims (claim_id, sku, failed_component, claim_date, days_in_service, repair_cost, resolution, failure_symptom) VALUES ('WC-00180', 'LAP-NIM-0002', 'RAM Module', TO_DATE('2025-09-25', 'YYYY-MM-DD'), 985, 110.04, 'Pending', 'Battery drains fast');
INSERT INTO warranty_claims (claim_id, sku, failed_component, claim_date, days_in_service, repair_cost, resolution, failure_symptom) VALUES ('WC-00188', 'WCH-NIM-0001', 'Battery', TO_DATE('2024-05-11', 'YYYY-MM-DD'), 64, 41.5, 'Refunded', 'Not charging');
INSERT INTO warranty_claims (claim_id, sku, failed_component, claim_date, days_in_service, repair_cost, resolution, failure_symptom) VALUES ('WC-00232', 'LAP-NIM-0002', 'Cooling Fan', TO_DATE('2024-07-17', 'YYYY-MM-DD'), 846, 59.08, 'Replaced', 'Cracked/damaged');
INSERT INTO warranty_claims (claim_id, sku, failed_component, claim_date, days_in_service, repair_cost, resolution, failure_symptom) VALUES ('WC-00241', 'TAB-EMB-0001', 'Speaker Unit', TO_DATE('2025-03-01', 'YYYY-MM-DD'), 419, 45.71, 'Replaced', 'Cracked/damaged');
INSERT INTO warranty_claims (claim_id, sku, failed_component, claim_date, days_in_service, repair_cost, resolution, failure_symptom) VALUES ('WC-00288', 'LAP-NIM-0002', 'Display Panel', TO_DATE('2025-02-24', 'YYYY-MM-DD'), 760, 202.62, 'Replaced', 'Random shutdowns');
INSERT INTO warranty_claims (claim_id, sku, failed_component, claim_date, days_in_service, repair_cost, resolution, failure_symptom) VALUES ('WC-00327', 'LAP-ORB-0001', 'SSD Storage', TO_DATE('2024-08-29', 'YYYY-MM-DD'), 962, 163.26, 'Repaired', 'Unresponsive');
INSERT INTO warranty_claims (claim_id, sku, failed_component, claim_date, days_in_service, repair_cost, resolution, failure_symptom) VALUES ('WC-00364', 'LAP-NIM-0002', 'Motherboard', TO_DATE('2025-08-29', 'YYYY-MM-DD'), 137, 211.25, 'Replaced', 'Overheating');
INSERT INTO warranty_claims (claim_id, sku, failed_component, claim_date, days_in_service, repair_cost, resolution, failure_symptom) VALUES ('WC-00365', 'WCH-NIM-0001', 'Strap/Band', TO_DATE('2026-06-13', 'YYYY-MM-DD'), 67, 42.77, 'Pending', 'Cracked/damaged');
INSERT INTO warranty_claims (claim_id, sku, failed_component, claim_date, days_in_service, repair_cost, resolution, failure_symptom) VALUES ('WC-00419', 'WCH-NIM-0001', 'Display', TO_DATE('2026-04-08', 'YYYY-MM-DD'), 299, 84.44, 'Repaired', 'Cracked/damaged');
INSERT INTO warranty_claims (claim_id, sku, failed_component, claim_date, days_in_service, repair_cost, resolution, failure_symptom) VALUES ('WC-00424', 'LAP-ORB-0001', 'Battery', TO_DATE('2025-08-03', 'YYYY-MM-DD'), 43, 134.49, 'Replaced', 'Battery drains fast');

-- ebay_listings (20 rows)
INSERT INTO ebay_listings (listing_id, title, listing_condition, price, seller_rating, seller_location, listed_date, watchers) VALUES ('EBY-000037', 'Emberline Canvas 11 (New) Free Ship', 'New', 311.36, 89.5, 'DE', TO_DATE('2025-04-05', 'YYYY-MM-DD'), 31);
INSERT INTO ebay_listings (listing_id, title, listing_condition, price, seller_rating, seller_location, listed_date, watchers) VALUES ('EBY-000057', '** Zenith Buds Air Pro ** Open Box SALE', 'Open Box', 244.89, 92.1, 'AU', TO_DATE('2025-08-14', 'YYYY-MM-DD'), 39);
INSERT INTO ebay_listings (listing_id, title, listing_condition, price, seller_rating, seller_location, listed_date, watchers) VALUES ('EBY-000060', 'Genuine Nimbus EliteBook X Used - Good Tested Working', 'Used - Good', 240.21, 93.9, 'CA', TO_DATE('2025-04-02', 'YYYY-MM-DD'), 60);
INSERT INTO ebay_listings (listing_id, title, listing_condition, price, seller_rating, seller_location, listed_date, watchers) VALUES ('EBY-000123', 'Nimbus Watch S1 Sport - Used - Fair - Fast Shipping', 'Used - Fair', 205.79, 86.6, 'DE', TO_DATE('2026-05-21', 'YYYY-MM-DD'), 26);
INSERT INTO ebay_listings (listing_id, title, listing_condition, price, seller_rating, seller_location, listed_date, watchers) VALUES ('EBY-000154', 'Nimbus Watch S1 Sport Used - Excellent L@@K!!', 'Used - Excellent', 381.08, 87.7, 'CA', TO_DATE('2025-01-15', 'YYYY-MM-DD'), 1);
INSERT INTO ebay_listings (listing_id, title, listing_condition, price, seller_rating, seller_location, listed_date, watchers) VALUES ('EBY-000218', 'Genuine Zenith Buds Air Pro Used - Excellent Tested Working', 'Used - Excellent', 220.77, 90.1, 'AU', TO_DATE('2026-07-01', 'YYYY-MM-DD'), 55);
INSERT INTO ebay_listings (listing_id, title, listing_condition, price, seller_rating, seller_location, listed_date, watchers) VALUES ('EBY-000219', 'Genuine Emberline Canvas 11 Used - Excellent Tested Working', 'Used - Excellent', 206.87, 88.7, 'CA', TO_DATE('2025-12-26', 'YYYY-MM-DD'), 1);
INSERT INTO ebay_listings (listing_id, title, listing_condition, price, seller_rating, seller_location, listed_date, watchers) VALUES ('EBY-000225', 'Zenith Buds Air Pro - Used - Excellent - Fast Shipping', 'Used - Excellent', 192.0, 99.4, 'DE', TO_DATE('2026-04-12', 'YYYY-MM-DD'), 42);
INSERT INTO ebay_listings (listing_id, title, listing_condition, price, seller_rating, seller_location, listed_date, watchers) VALUES ('EBY-000230', 'Emberline Canvas 11 - For Parts/Not Working - Fast Shipping', 'For Parts/Not Working', 48.9, 96.3, 'DE', TO_DATE('2026-02-25', 'YYYY-MM-DD'), 39);
INSERT INTO ebay_listings (listing_id, title, listing_condition, price, seller_rating, seller_location, listed_date, watchers) VALUES ('EBY-000285', 'Nimbus Watch S1 - Used - Good - Fast Shipping', 'Used - Good', 151.11, 86.9, 'SG', TO_DATE('2025-12-16', 'YYYY-MM-DD'), 0);
INSERT INTO ebay_listings (listing_id, title, listing_condition, price, seller_rating, seller_location, listed_date, watchers) VALUES ('EBY-000292', 'Genuine Emberline Canvas 11 Open Box Tested Working', 'Open Box', 285.77, 90.0, 'US', TO_DATE('2025-10-23', 'YYYY-MM-DD'), 41);
INSERT INTO ebay_listings (listing_id, title, listing_condition, price, seller_rating, seller_location, listed_date, watchers) VALUES ('EBY-000301', 'Nimbus Watch S1 Used - Fair w/ Charger Bundle', 'Used - Fair', 69.3, NULL, 'DE', TO_DATE('2025-10-30', 'YYYY-MM-DD'), 31);
INSERT INTO ebay_listings (listing_id, title, listing_condition, price, seller_rating, seller_location, listed_date, watchers) VALUES ('EBY-000316', 'Genuine Nimbus Watch S1 Sport Used - Excellent Tested Working', 'Used - Excellent', 369.8, 85.9, 'CA', TO_DATE('2026-01-22', 'YYYY-MM-DD'), 27);
INSERT INTO ebay_listings (listing_id, title, listing_condition, price, seller_rating, seller_location, listed_date, watchers) VALUES ('EBY-000335', 'Emberline Canvas 11 - Used - Good - Fast Shipping', 'Used - Good', 153.13, 92.2, 'AU', TO_DATE('2025-10-14', 'YYYY-MM-DD'), 17);
INSERT INTO ebay_listings (listing_id, title, listing_condition, price, seller_rating, seller_location, listed_date, watchers) VALUES ('EBY-000337', 'Zenith Buds Air Pro Used - Excellent w/ Charger Bundle', 'Used - Excellent', 178.92, 96.9, 'IN', TO_DATE('2026-02-24', 'YYYY-MM-DD'), 0);
INSERT INTO ebay_listings (listing_id, title, listing_condition, price, seller_rating, seller_location, listed_date, watchers) VALUES ('EBY-000362', 'Zenith Buds Air Pro Open Box L@@K!!', 'Open Box', 249.57, 87.7, 'CA', TO_DATE('2025-09-26', 'YYYY-MM-DD'), 20);
INSERT INTO ebay_listings (listing_id, title, listing_condition, price, seller_rating, seller_location, listed_date, watchers) VALUES ('EBY-000369', 'Nimbus EliteBook X Used - Fair L@@K!!', 'Used - Fair', 224.14, 92.0, 'CA', TO_DATE('2025-10-11', 'YYYY-MM-DD'), 44);
INSERT INTO ebay_listings (listing_id, title, listing_condition, price, seller_rating, seller_location, listed_date, watchers) VALUES ('EBY-000382', 'Nimbus Watch S1 (Used - Good) Free Ship', 'Used - Good', 130.35, 96.0, 'US', TO_DATE('2025-05-04', 'YYYY-MM-DD'), 47);
INSERT INTO ebay_listings (listing_id, title, listing_condition, price, seller_rating, seller_location, listed_date, watchers) VALUES ('EBY-000392', '** Nimbus EliteBook X ** Used - Excellent SALE', 'Used - Excellent', 433.17, 97.0, 'IN', TO_DATE('2026-05-23', 'YYYY-MM-DD'), 15);
INSERT INTO ebay_listings (listing_id, title, listing_condition, price, seller_rating, seller_location, listed_date, watchers) VALUES ('EBY-000410', 'Zenith Buds Air Pro (Used - Good) Free Ship', 'Used - Good', 158.96, 94.8, 'IN', TO_DATE('2025-03-26', 'YYYY-MM-DD'), 6);

COMMIT;