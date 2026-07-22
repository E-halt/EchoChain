-- =====================================================
-- EchoChain Oracle Schema
-- Run this FIRST. Drops any old versions of these tables.
-- SKU is product-grain: 1 SKU -> many bom rows.
-- =====================================================

BEGIN
  FOR t IN (SELECT table_name FROM user_tables
            WHERE table_name IN ('PRODUCTS','BOM','WARRANTY_CLAIMS','EBAY_LISTINGS'))
  LOOP
    EXECUTE IMMEDIATE 'DROP TABLE ' || t.table_name || ' CASCADE CONSTRAINTS';
  END LOOP;
END;
/

CREATE TABLE products (
    sku            VARCHAR2(30)  PRIMARY KEY,
    brand          VARCHAR2(50)  NOT NULL,
    product_name   VARCHAR2(100) NOT NULL,
    category       VARCHAR2(50)  NOT NULL,
    launch_year    NUMBER(4)     NOT NULL,
    msrp           NUMBER(10,2)  NOT NULL
);

CREATE TABLE bom (
    bom_id           NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    sku              VARCHAR2(30)  NOT NULL REFERENCES products(sku),
    component        VARCHAR2(50)  NOT NULL,
    component_code   VARCHAR2(10),
    supplier         VARCHAR2(50),
    component_cost   NUMBER(10,2)  NOT NULL
);

CREATE TABLE warranty_claims (
    claim_id           VARCHAR2(20)  PRIMARY KEY,
    sku                VARCHAR2(30)  NOT NULL REFERENCES products(sku),
    failed_component   VARCHAR2(50)  NOT NULL,
    claim_date         DATE          NOT NULL,
    days_in_service    NUMBER(6),
    repair_cost        NUMBER(10,2)  NOT NULL,
    resolution         VARCHAR2(20),
    failure_symptom    VARCHAR2(100)
);

-- No FK to products: eBay listings have no SKU, matched via title text.
CREATE TABLE ebay_listings (
    listing_id         VARCHAR2(20)  PRIMARY KEY,
    title              VARCHAR2(200) NOT NULL,
    listing_condition  VARCHAR2(30),
    price              NUMBER(10,2)  NOT NULL,
    seller_rating      NUMBER(5,1),
    seller_location    VARCHAR2(10),
    listed_date        DATE,
    watchers           NUMBER(6)
);

CREATE INDEX idx_bom_sku ON bom(sku);
CREATE INDEX idx_warranty_sku ON warranty_claims(sku);
CREATE INDEX idx_ebay_condition ON ebay_listings(listing_condition);
