TRUNCATE table ebay_listings;
truncate table warranty_claims;
truncate table bom;
commit;
truncate table products;

Drop view VW_BOM_COMPONENT_VALUE;
Drop view VW_COMPONENT_FAILURE_METRICS;
drop view VW_EBAY_LISTING_MATCHES;
drop view VW_TEAMMATE_MATCH_QUALITY;

truncate table products;
SELECT 
    ucc.column_name,
    uc.constraint_name,
    CASE uc.constraint_type
        WHEN 'P' THEN 'Primary Key'
        WHEN 'R' THEN 'Foreign Key (Referential)'
        WHEN 'U' THEN 'Unique Key'
        WHEN 'C' THEN 'Check / Not Null'
        WHEN 'V' THEN 'With Check Option (View)'
        WHEN 'O' THEN 'With Read Only (View)'
        ELSE uc.constraint_type
    END AS constraint_type,
    uc.status
FROM user_constraints uc
JOIN user_cons_columns ucc 
  ON uc.constraint_name = ucc.constraint_name 
 AND uc.table_name = ucc.table_name
WHERE uc.table_name = 'products'
ORDER BY ucc.position;
DROP TABLE products CASCADE CONSTRAINTS;

CREATE TABLE products (
    sku            VARCHAR2(30)  PRIMARY KEY,
    brand          VARCHAR2(50)  NOT NULL,
    product_name   VARCHAR2(100) NOT NULL,
    category       VARCHAR2(50)  NOT NULL,
    launch_year    NUMBER(4)     NOT NULL,
    msrp           NUMBER(10,2)  NOT NULL
);

CREATE INDEX idx_bom_sku ON bom(sku);
CREATE INDEX idx_warranty_sku ON warranty_claims(sku);
CREATE INDEX idx_ebay_condition ON ebay_listings(listing_condition);

select count(*) from products;
select count(*) from warranty_claims;
select count(*) from BOM;
select count(*) from ebay_listings;


