CREATE TABLE brands(
brand_id SERIAL PRIMARY KEY, 
brand_name VARCHAR(250)
);

COPY brands(
brand_id, brand_name)
FROM 'D:/004. PACMAN/SQL/bike store_exercise/brands.csv'
DELIMITER ','
CSV HEADER;
------------------------------------
CREATE TABLE categories(
category_id SERIAL PRIMARY KEY, 
category_name VARCHAR(250)
);

COPY categories(
category_id, category_name)
FROM 'D:/004. PACMAN/SQL/bike store_exercise/categories.csv'
DELIMITER ','
CSV HEADER;

---------------------------------------
CREATE TABLE customers(
customer_id SERIAL PRIMARY KEY, 
first_name VARCHAR(250),
last_name VARCHAR(250),
phone VARCHAR(250),
email VARCHAR(250),
street VARCHAR(250),
city VARCHAR(250),
st VARCHAR(250),
zip_code INT
);

COPY customers(
customer_id,
first_name,
last_name,
phone,
email,
street,
city,
st,
zip_code
)
FROM 'D:/004. PACMAN/SQL/bike store_exercise/customers.csv'
DELIMITER ','
CSV HEADER NULL AS 'NULL';


-------------------------------------------
-----STORE
CREATE TABLE stores(
store_id SERIAL PRIMARY KEY,
store_name VARCHAR(250),
phone VARCHAR(250),
email VARCHAR(250),
street VARCHAR(250),
city VARCHAR(250),
st VARCHAR(250),
zip_code INT
);

COPY stores(
store_id, store_name, phone, email, street, city, st, zip_code
)
FROM 'D:/004. PACMAN/SQL/bike store_exercise/stores.csv'
DELIMITER ','
CSV HEADER;
-----------------------------------------------

----STAFFS
CREATE TABLE staffs(
staff_id SERIAL PRIMARY KEY,
first_name VARCHAR(250),
last_name VARCHAR(250),
email VARCHAR(250),
phone VARCHAR(250),
active INT,
store_id INT,
manager_id INT,
FOREIGN KEY (store_id) REFERENCES stores (store_id)
);

COPY staffs(
staff_id, first_name, last_name, email, phone,
active, store_id, manager_id)
FROM 'D:/004. PACMAN/SQL/bike store_exercise/staffs.csv'
DELIMITER ','
CSV HEADER NULL AS 'NULL';

--------------------------------------------
------stocks
CREATE TABLE stocks(
store_id INT,
product_id INT,
quantity INT,
FOREIGN KEY (store_id) REFERENCES stores (store_id),
FOREIGN KEY (product_id) REFERENCES products (product_id)
);

COPY stocks(
store_id, product_id, quantity
)
FROM 'D:/004. PACMAN/SQL/bike store_exercise/stocks.csv'
DELIMITER ','
CSV HEADER;

-----------------------------------------------
---tabel order
CREATE TABLE orders(
order_id SERIAL PRIMARY KEY,
customer_id INT,
order_status INT,
order_date DATE,
required_date DATE,
shipped_date DATE,
store_id INT ,
staff_id INT,
FOREIGN KEY (customer_id) REFERENCES customers (customer_id),
FOREIGN KEY (store_id) REFERENCES stores (store_id),
FOREIGN KEY (staff_id) REFERENCES staffs (staff_id)
);

COPY orders(
order_id, customer_id, order_status,
order_date, required_date, shipped_date,
store_id, staff_id)
FROM 'D:/004. PACMAN/SQL/bike store_exercise/orders.csv'
DELIMITER ','
CSV HEADER NULL AS 'NULL';

----tabel product
CREATE TABLE products(
product_id SERIAL PRIMARY KEY,
product_name VARCHAR(250),
brand_id INT, 
category_id INT,
model_year INT,
list_price FLOAT,
FOREIGN KEY (brand_id) REFERENCES brands (brand_id),
FOREIGN KEY (category_id) REFERENCES categories (category_id)
);

COPY products(
product_id, product_name, brand_id, category_id,
model_year, list_price
)
FROM 'D:/004. PACMAN/SQL/bike store_exercise/products.csv'
DELIMITER ','
CSV HEADER;
-------------------------------------------
CREATE TABLE order_items(
order_id INT,
item_id INT,
product_id INT,
quantity INT,
list_price FLOAT,
disc FLOAT,
FOREIGN KEY (order_id) REFERENCES orders (order_id),
FOREIGN KEY (product_id) REFERENCES products (product_id)
);
ALTER TABLE order_items DROP CONSTRAINT order_items_pkey;

COPY order_items(
order_id, item_id, product_id, quantity, list_price, disc)
FROM 'D:/004. PACMAN/SQL/bike store_exercise/order_items.csv'
DELIMITER ','
CSV HEADER;