use belajar_mysql;
select id, lower(name) as 'Name Lower', 
Length(name) as 'Name Length',
Upper(name) as 'Name Upper'  
from products;
select id, created_at, Year(created_at), month(created_at) from products;
select id, category, case category
when 'Makanan' then 'Enak'
when 'Minuman' then 'Segar'
Else 'Apa Itu'
end as 'category'
from products;
select id, 
price,
if(price <= 15000, 'Murah', if(price <= 20000, 'Mahal', 'Mahal Banget')) as 'Mahal?'
from products;
select id, name,ifnull (description, 'Kosong') from products;
select count(id) as 'Total Product' from products;
select max(price) as 'Product Termahal' From products;
select avg(price) as 'Harga rata-rata' from products;
select min(price) as 'Product Termurah' from products;
select sum(quantity) as 'Total Product' from products;

select count(id) as 'Total Product', category from products group by category;
select max(price) as 'Product Termahal', category from products group by category;
select avg(price) as 'Harga rata-rata', category from products group by category;
select min(price) as 'Product Termurah', category from products group by category;
select sum(quantity) as 'Total Product', category from products group by category;

select count(id) as 'total',
category
from products group by category
having total > 1;

alter table products
add constraint price_check check(price >= 1000);
select * from products;
insert into products(id, name, category, price, quantity)
values ('P0018', 'Permen', 'Makanan', 500, 70);  

use belajar_mysql;

alter table products
drop index products_fulltext;

alter table products
add fulltext product_fulltext (name, description);

select * from products where match(name, description)
against ('+ayam -bakso' in boolean mode);

select * from products where match(name, description)
against ('ayam' in natural language mode);

select * from products;

update products
set name = 'Es Jeruk'
where id = 'P0008';

select * from products;

insert into products(id, name, price, quantity)
values ('X0001', 'X Satu', 20000, 299),
('X0002', 'X Dua', 20000, 299),
('X0003', 'X Tiga', 20000, 299);

select avg(price) from products;
select * from products where price > 13575.0000;


select * from products where price > (select avg(price) from products);

select max(price) from products;

update products
set price=1000000
where id = 'X0003';

select price from categories
join products on (products.id_category = categories.id);

select max(price) from  (select price from categories
join products on (products.id_category = categories.id)) as cp;

use belajar