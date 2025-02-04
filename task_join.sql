-----CASE 1 -------
-----CASE 1.1-----

SELECT * FROM orderdetails;
SELECT * FROM products;

SELECT *
FROM products
LEFT JOIN orderdetails
ON products.productcode = orderdetails.productcode
WHERE orderdetails.productcode IS NULL;


------CASE 1.2 ------
#SALAH#
WITH new_data AS(
	SELECT productcode,productname, quantityinstock,
		quantityordered as n_items_sold,
		quantityinstock + quantityordered AS total_quantity
	FROM products
	JOIN orderdetails
	USING (productcode)
),
new_percent AS(
	SELECT productcode
		(n_items_sold / total_quantity)*100 AS percentsold
	FROM new_data
	GROUP BY productcode
)
SELECT productname, quantityinstock, n_items_sold, total_quantity, percentsold
FROM new_percent
WHERE percentsold < 0.2;
SELECT productname, quantityinstock,
	quantityordered*1.0 as n_items_sold,
	quantityinstock + quantityordered*1.0 as total_quantity,
	(quantityordered*1.0 / (quantityinstock+quantityordered*1.0))*100 as percentsold
FROM products
JOIN orderdetails
	ON products.productcode = orderdetails.productcode
WHERE (quantityordered*1.0 / (quantityinstock+quantityordered*1.0))*100 < 20;

SELECT productcode, productname,
quantityinstock AS stok_product,
SUM(quantityordered) AS sold_product,
quantityinstock + SUM(quantityordered) AS total_stock
FROM products
JOIN orderdetails
USING (productcode)
GROUP BY productcode, productname;




-----CASE 1.3 -------
SELECT 
productname, msrp, priceeach,
0.8*msrp AS minimumprice,
priceeach/msrp*100 AS percent_priceeach_msrp
FROM products
JOIN orderdetails
USING(productcode)
WHERE priceeach < msrp*0.8;


-----CASE 1.4-------
WITH total_sales_product AS(
	SELECT productcode,
		SUM(quantityordered*priceeach) as total_sales
	FROM orderdetails
	GROUP BY productcode
),
total_sales_each_category as(
	SELECT productline,
			SUM(total_sales) AS total_sales_category
	FROM products
	JOIN total_sales_product
		ON products.productcode = total_sales_product.productcode
	GROUP BY productline
)
SELECT productline, total_sales_category
FROM total_sales_each_category
WHERE total_sales_category > (SELECT AVG(total_sales_category) FROM total_sales_each_category);