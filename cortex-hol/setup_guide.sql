-- setting a role and creating a database and schema for lab data
CREATE OR REPLACE DATABASE cortex_hol;
CREATE OR REPLACE SCHEMA raw_pos;

-- create temp warehouse for loading files from stage 
CREATE OR REPLACE WAREHOUSE demo_build_wh
    WAREHOUSE_SIZE = 'xlarge'
    WAREHOUSE_TYPE = 'standard'
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE
COMMENT = 'demo build warehouse for hol assets';

USE WAREHOUSE demo_build_wh;

-- create file format 
CREATE OR REPLACE FILE FORMAT cortex_hol.raw_pos.csvformat
TYPE = 'csv' 
FIELD_OPTIONALLY_ENCLOSED_BY = '"';


-- create stage for cortex hol data
CREATE OR REPLACE STAGE cortex_hol.raw_pos.s3load
COMMENT = 'Quickstarts S3 Stage Connection'
url = 's3://coalesce-hol-data/cortex-hol-data/'
file_format = cortex_hol.raw_pos.csvformat;


-- menu table build
CREATE OR REPLACE TABLE cortex_hol.raw_pos.menu
(
    menu_id NUMBER(19,0),
    menu_type_id NUMBER(38,0),
    menu_type VARCHAR(16777216),
    truck_brand_name VARCHAR(16777216),
    menu_item_id NUMBER(38,0),
    menu_item_name VARCHAR(16777216),
    item_category VARCHAR(16777216),
    item_subcategory VARCHAR(16777216),
    cost_of_goods_usd NUMBER(38,4),
    sale_price_usd NUMBER(38,4),
    menu_item_health_metrics_obj VARIANT
);


-- order_header table build
CREATE OR REPLACE TABLE cortex_hol.raw_pos.order_header
(
    order_id NUMBER(38,0),
    truck_id NUMBER(38,0),
    location_id FLOAT,
    customer_id NUMBER(38,0),
    discount_id VARCHAR(16777216),
    shift_id NUMBER(38,0),
    shift_start_time TIME(9),
    shift_end_time TIME(9),
    order_channel VARCHAR(16777216),
    order_ts TIMESTAMP_NTZ(9),
    served_ts VARCHAR(16777216),
    order_currency VARCHAR(3),
    order_amount NUMBER(38,4),
    order_tax_amount VARCHAR(16777216),
    order_discount_amount VARCHAR(16777216),
    order_total NUMBER(38,4)
);

-- order_detail table build
CREATE OR REPLACE TABLE cortex_hol.raw_pos.order_detail 
(
    order_detail_id NUMBER(38,0),
    order_id NUMBER(38,0),
    menu_item_id NUMBER(38,0),
    discount_id VARCHAR(16777216),
    line_number NUMBER(38,0),
    quantity NUMBER(5,0),
    unit_price NUMBER(38,4),
    price NUMBER(38,4),
    order_item_discount_amount VARCHAR(16777216)
);


-- customer loyalty table build
CREATE OR REPLACE TABLE cortex_hol.raw_pos.customers
(
    customer_id NUMBER(38,0),
    first_name VARCHAR(16777216),
    last_name VARCHAR(16777216),
    city VARCHAR(16777216),
    country VARCHAR(16777216),
    postal_code VARCHAR(16777216),
    preferred_language VARCHAR(16777216),
    gender VARCHAR(16777216),
    favourite_brand VARCHAR(16777216),
    marital_status VARCHAR(16777216),
    children_count VARCHAR(16777216),
    sign_up_date DATE,
    birthday_date DATE,
    e_mail VARCHAR(16777216),
    phone_number VARCHAR(16777216)
);

-- review table build
CREATE OR REPLACE TABLE cortex_hol.raw_pos.reviews (
    REVIEW_ID STRING, 
    CUSTOMER_ID INT,
    STAR_RATING INT,
    REVIEW_TEXT STRING,
    REVIEW_DATE DATE
);

--new orders table 
CREATE OR REPLACE TABLE cortex_hol.raw_pos.new_orders (
    ORDER_TS TIMESTAMP_NTZ,
    ORDER_AMOUNT NUMBER(12,2),
    MENU_ITEM_NAME STRING
);



-- menu table load
COPY INTO cortex_hol.raw_pos.menu
FROM @cortex_hol.raw_pos.s3load/menu/;

-- order_header table load
COPY INTO cortex_hol.raw_pos.order_header
FROM @cortex_hol.raw_pos.s3load/order-header/;

-- order_detail table load
COPY INTO cortex_hol.raw_pos.order_detail
FROM @cortex_hol.raw_pos.s3load/order-detail/;

-- reviews table load
COPY INTO cortex_hol.raw_pos.customers
FROM @cortex_hol.raw_pos.s3load/customer/;

COPY INTO cortex_hol.raw_pos.reviews
FROM @cortex_hol.raw_pos.s3load/reviews/;

COPY INTO cortex_hol.raw_pos.new_orders
FROM @cortex_hol.raw_pos.s3load/new_orders/;


-- remove xlarge warehouse 
DROP WAREHOUSE IF EXISTS demo_build_wh;

-- provide usage to new tables for pc_coalesce_role
GRANT USAGE ON DATABASE cortex_hol TO ROLE pc_coalesce_role;
GRANT USAGE ON ALL SCHEMAS IN DATABASE cortex_hol TO ROLE pc_coalesce_role;
GRANT ALL ON SCHEMA cortex_hol.raw_pos TO ROLE pc_coalesce_role;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA cortex_hol.raw_pos TO ROLE pc_coalesce_role;



-- setup completion note
SELECT 'Setup for your HOL is now complete' AS note;
