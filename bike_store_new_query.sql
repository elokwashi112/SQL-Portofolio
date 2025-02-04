---Analisis Data Penjualan---

--CEK DATA ---
select* from orders;
select * from customers;


--- ANALISIS PENJUALAN DAN PELANGGAN ---
--banyaknya pembeli melakukan pembelian--

select customer_id,
count(customer_id) as banyak_pembelian
from orders
group by customer_id
order by count(customer_id) desc;

--- kesimpulan : pembeli paling banyak melakukan pembelian sebanyak 3 kali--

----pembelian dengan nominal tertinggi---
select customer_id, first_name, last_name,
sum(list_price* quantity) as nominal_belanja
from customers
right join orders using(customer_id)
right join order_items using (order_id)
group by customer_id, first_name, last_name
order by sum(list_price* quantity) desc;

-----perbandingan penjualan produk dengan stoknya---
select s.product_id, sum(oi.quantity) as terjual,
sum(oi.quantity + s.quantity) as total_barang
from order_items oi
left join stocks s using(product_id)
group by s.product_id
order by sum( oi.quantity + s.quantity) desc;

-----produk yang paling dibeli---
select product_id, product_name, 
sum(quantity) as pembelian_prod
from order_items
left join products
using (product_id)
group by product_id, product_name
order by sum(quantity) desc
limit 10;

---produk paling sedikit dibeli---
select product_id, product_name, 
sum(quantity) as pembelian_prod
from order_items
left join products
using (product_id)
group by product_id, product_name
order by sum(quantity) asc
limit 10;

---KINERJA TOKO-----
---toko dengan penjualan atau omset tertinggi-
select store_id, store_name,
sum(list_price * quantity) as omset_penjualan
from stores
right join orders using (store_id)
right join order_items using(order_id)
group by store_id, store_name
order by sum(list_price * quantity) desc;

---barang yang paling banyak di beli tiap toko--
WITH ranked_products AS (
    SELECT 
        o.store_id,
        oi.product_id,
        SUM(oi.quantity) AS total_terjual,
        RANK() OVER (PARTITION BY o.store_id ORDER BY SUM(oi.quantity) DESC) AS rank_produk
    FROM 
        orders o
    JOIN 
        order_items oi ON o.order_id = oi.order_id
    GROUP BY 
        o.store_id, oi.product_id
)
SELECT 
    store_id,
    product_id,
    total_terjual
FROM 
    ranked_products
WHERE 
    rank_produk = 1
ORDER BY 
    store_id;

---KEPEGAWAIAN---
select * from staffs;
--- Total penjualan dari masing-masing staff---
select staff_id, first_name, last_name,
sum (list_price* quantity) as total_penjualan
from staffs
right join orders using(staff_id)
right join order_items using (order_id)
group by staff_id, first_name, last_name
order by sum (list_price* quantity) desc;


----JARAK PELAYANAN KE PENGIRIMAN----
---nilai tengah dari jarak order dan pengiriman---
WITH date_prepare AS(
select order_date, shipped_date, (shipped_date - order_date) as range_hari
from orders
)
,ranked_data as(
select range_hari,
row_number() over(order by range_hari) as row_num,
count(*) over() as total_rows
from date_prepare
)
select avg(range_hari) as median
from ranked_data
where row_num in (
(total_rows+1)/2,
(total_rows+2-mod(total_rows,2))/2
);

select order_id, order_date, shipped_date, (shipped_date - order_date) as range_hari
from orders
where (shipped_date - order_date) > 2;
---- ^ Median^---

---dengan rata-rata---
select order_id, order_date, shipped_date,
(shipped_date-order_date) as range_hari
from orders
where (shipped_date-order_date) >(
select round(avg(shipped_date - order_date),1) as rata_range
from orders);
-- kesimpulan : rata-rata dan median jarak antara order dengan pengiriman adalah 2 hari, masih terdapat di luar tersebut---

--RATA-RATA PENGIRIMAN TIAP TOKO---
SELECT 
    store_id, 
    ROUND(AVG(shipped_date - order_date), 1) AS rata_rata_waktu_pengiriman
FROM orders
GROUP BY store_id
ORDER BY rata_rata_waktu_pengiriman DESC;



---Melihat toko mana saja yang melakukan pengemasan lebih dari 2 hari---
WITH ship_above_avg as(
select store_id, count(order_id) as jumlah_pengiriman
from orders
where (shipped_date-order_date)>(
select round(avg(shipped_date - order_date),1) as rata_range
from orders)
group by store_id
)
select store_id, jumlah_pengiriman
from ship_above_avg
order by jumlah_pengiriman desc;

---kesimpulan : store 2 melakukan pengiriman selama 3 hari setelah order_date---


----ANALISIS RUNTUN WAKTU---
---jumlah pesanan berdasarkan tanggal----
select order_date, count(order_id) as banyak_order
from orders
group by order_date
order by order_date;
---omset masing-masing hari---
select order_date,
sum(list_price * quantity) as omset
from orders
right join order_items using(order_id)
group by order_date
order by order_date;

---tanggal berapa penjualan berada di atas rata-rata omset---
select order_date,
sum(quantity * list_price) as omset
from orders
right join order_items using(order_id)
group by order_date
having sum(quantity * list_price) > (
select avg(omset)
from (select order_date,
sum(quantity * list_price) as omset
from orders
right join order_items using(order_id)
group by order_date) as subquery
)
order by omset desc;

