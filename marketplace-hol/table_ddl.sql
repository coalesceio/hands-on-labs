-- ORDER TABLE
CREATE OR REPLACE TABLE orders (
    order_id INT AUTOINCREMENT PRIMARY KEY,
    customer_id INT,
    total_amount DECIMAL(10, 2),
    order_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP(),
    status STRING,
    shipping_address STRING,
    billing_address STRING,
    payment_method STRING
);

-- ORDER DETAIL TABLE
CREATE OR REPLACE TABLE order_detail (
    order_detail_id INT AUTOINCREMENT PRIMARY KEY,
    order_id INT,
    menu_item_id INT,
    item_name STRING,
    quantity INT,
    price DECIMAL(10, 2),
    discount_amount DECIMAL(10, 2),
    line_total DECIMAL(10, 2) AS (quantity * (price - discount_amount)),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
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
    star_rating INT CHECK (star_rating BETWEEN 1 AND 5),
    review_text STRING,
    review_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (customer_id) REFERENCES orders(customer_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);
