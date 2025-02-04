SELECT * FROM products;

SELECT SUM(quantityinstock)
FROM products;

SELECT productline,
COUNT(DISTINCT productname) AS jumlahvariasi
FROM products
GROUP BY productline
HAVING COUNT(DISTINCT productname) <5;


SELECT productline, productname, quantityinstock, 
AVG(quantityinstock) OVER(PARTITION BY productline) AS rataratakategori
FROM products;

----CASE 2----

SELECT * FROM orderdetails;


SELECT productcode, priceeach, quantityordered,
dense_rank() over(order by quantityordered desc) as pricerank
from orderdetails;

-----CASE 3----

SELECT * FROM payments;

SELECT customernumber, paymentdate,
LEAD(paymentdate) OVER(PARTITION BY customernumber ORDER BY paymentdate) AS nextpaymentdate,
amount,
LEAD(amount) OVER(PARTITION BY customernumber ORDER BY paymentdate) AS nextpaymentamount
FROM payments;


SELECT * FROM products;

SELECT productname, productline, buyprice,
NTH_VALUE(productname,2) OVER(PARTITION BY productline ORDER BY buyprice DESC) AS secmostexp,
NTH_VALUE(buyprice,2) OVER(PARTITION BY productline ORDER BY buyprice DESC) AS secmostexp_price
FROM products;


SELECT productname, productline, buyprice,
NTH_VALUE(productname,4) OVER(PARTITION BY productline ORDER BY buyprice DESC) AS secmostexp,
NTH_VALUE(buyprice,4) OVER(PARTITION BY productline ORDER BY buyprice DESC) AS secmostexp_price
FROM products;

