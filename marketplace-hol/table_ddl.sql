USE ROLE ACCOUNTADMIN;
CREATE OR REPLACE warehouse compute_wh
warehouse_size = 'xsmall';
CREATE or REPLACE database marketplace_hol;
CREATE or REPLACE schema marketplace_hol.store;

CREATE OR REPLACE file format marketplace_hol.store.csvformat
TYPE = 'CSV' 
FIELD_OPTIONALLY_ENCLOSED_BY = '"'
SKIP_HEADER = 1;

CREATE or REPLACE file format marketplace_hol.store.jsonformat
type = 'JSON';

CREATE OR REPLACE STAGE marketplace_hol.store.store_data
URL = 's3://coalesce-hol-data/marketplace-hol-data/';

-- ORDER TABLE
CREATE OR REPLACE TABLE orders (
    order_id INT  PRIMARY KEY,
    order_detail_id INT,
    customer_id INT,
    total_amount DECIMAL(10, 2),
    order_ts TIMESTAMP_LTZ,
    status STRING,
    payment_method STRING,
    shipping_address STRING
);

-- ORDER DETAIL TABLE
CREATE OR REPLACE TABLE order_detail (
    order_detail_id INT AUTOINCREMENT PRIMARY KEY,
    order_id INT,
    menu_item_id INT,
    item_name STRING,
    quantity INT,
    price DECIMAL(10, 2),
    discount_amount DECIMAL(10, 2)
    
);

--MENU TABLE 

CREATE OR REPLACE TABLE menu (
    menu_id INT AUTOINCREMENT PRIMARY KEY,
    menu_item_id INT UNIQUE,
    item_name STRING,
    item_category STRING,
    item_subcategory STRING,
    ingredients VARIANT,  -- Use VARIANT to store JSON-like structure for ingredients
    cost_to_make DECIMAL(10, 2)
);

--REVIEW TABLE

CREATE OR REPLACE TABLE customer_reviews (
    review_id INT AUTOINCREMENT PRIMARY KEY,
    customer_id INT,
    order_id INT,
    star_rating INT,
    review_text STRING,
    review_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

--CUSTOMER TABLE

CREATE OR REPLACE TABLE customers (
    customer_id INT,
    first_name STRING NOT NULL,
    last_name STRING NOT NULL,
    email STRING UNIQUE NOT NULL,
    phone_number STRING,
    date_of_birth DATE,
    address STRING,
    city STRING,
    state STRING,
    postal_code STRING,
    country STRING
);


COPY INTO marketplace_hol.store.menu
FROM @marketplace_hol.store.store_data/menu.csv
FILE_FORMAT = csvformat;


COPY INTO marketplace_hol.store.order_detail
FROM @marketplace_hol.store.store_data/order_detail.csv
FILE_FORMAT = csvformat;

COPY INTO marketplace_hol.store.orders
FROM @marketplace_hol.store.store_data/orders.csv
FILE_FORMAT = csvformat;

COPY INTO marketplace_hol.store.customers
FROM @marketplace_hol.store.store_data/customers.csv
FILE_FORMAT = csvformat;
