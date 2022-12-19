CREATE TABLE workers
(
    id SMALLINT,
    name VARCHAR(50),
    salary SMALLINT,
    CONSTRAINT id4_pk PRIMARY KEY(id)
);
INSERT INTO workers VALUES(10001, 'Ali Can', 12000);
INSERT INTO workers VALUES(10002, 'Veli Han', 2000);
INSERT INTO workers VALUES(10003, 'Mary Star', 7000);
INSERT INTO workers VALUES(10004, 'Angie Ocean', 8500);

--En düşük ve en büyük salary değerlerine sahip recordları çağıralım
Select * from workers
Where salary = (Select min(salary) from workers) or salary = (Select max(salary) from workers);
--Ancak or ile yazınca tekrar tekrar salary =... şeklinde yazmamız gerekiyor.

--2. Yol: IN içine select ile en küçük ve en büyük salary yazarak
Select * from workers
Where salary IN ((Select min(salary)from workers), (Select max(salary)from workers));

--Max salary değerini bul
Select max(salary) --tüm row değil, sadece max salary
from workers;

--Eğer çağırdığımız sütuna geçici isim de vermek istersek AS ile yazabiliriz.
Select max(salary) AS maximum_salary
from workers;

--En düşük salary değerini bul, AS ile tablo ismi ver
Select min(salary) AS minimum_salary
from workers;

--Salary ortalamasını bul
Select avg(salary) AS average_salary
from workers;

--Record adedini (satır sayısı) bul: COUNT ile kayıt saydırabiliriz
--Herhangi bir sütun ismi ile saydırabiliriz.

Select count(name) AS number_of_workers
from workers;

--Asteriks ile saydırınca da aynı sonuç
Select count(*) AS number_of_workers
from workers;

--Salary değerlerinin toplamını bul. SUM ile
Select sum(salary) as total_salary
from workers;

--En yüksek ikinci salary değerini çağır

Select max(salary) as second_highest_salary
from workers
where salary < (Select max(salary) from workers); --en yüksekten bir düşük olanı seçtik

--En düşük ikinci salary'i bul
Select min(salary) as second_lowest_salary
from workers
where salary > (Select min(salary) from workers); --en küçüğünden bir büyük olanı çağırdık

--En yüksek üçüncü salary değerini bul (ikinci max salary'den bir düşük olan)

Select max(salary) as third_max_salary
from workers
where salary < (Select max(salary) --yukarıda ikinci max salary'i buraya kopyaladık.
                from workers 
                where salary < (Select max(salary) from workers));
                
--En düşük 3. salary değerini bulun
Select min(salary) as third_min_salary
from workers 
where salary > (Select min(salary) as second_lowest_salary --yukarıdaki 3. en düşüğü kopyaladık
                from workers
                where salary > (Select min(salary) from workers));
                
--Salary değeri en yüksek 2. değere sahip recordı çağır: Burada tüm row isteniyor (*)

--1. YOL: Sunquery kullanarak
Select *
from workers
where salary = (Select max(salary) --yukarıda ikinci max salary'i alıp eşitledik
                from workers 
                where salary < (Select max(salary) from workers));
                
--2. YOL: ORDER BY, OFFSET, FETCH ile çağırma
Select *
from workers
Order by salary desc --çoktan aza doğru sırala
Offset 1 row --1 satır atla
Fetch next 1 row only;  --sadece sıradaki satırı ver. Kaç satır yazarsak o kadar verir
                
--Salary değeri en düşük 2. değere sahip recordı çağır:

--1. YOL:
Select * from workers
Where salary = (Select min(salary) --tüm row istediği için eşitledik
                from workers 
                where salary > (Select min(salary) as second_lowest_salary from workers));

--2. YOL:
Select * from workers
Order by salary asc --azdan çoğa sıralayıp bir tane atlayıp ikincisini aldık
Offset 1 row
Fetch next 1 row only;


--Salary değeri en düşük üçüncü record'ı çağır:

--1. YOL:
Select * from workers
Where salary = (Select min(salary) --yukarıdaki 3. en düşüğü kopyaladık
                from workers 
                where salary > (Select min(salary) as second_lowest_salary 
                    from workers
                    where salary > (Select min(salary) from workers)));
                    
-- 2. YOL:
Select *
from workers
Order by salary asc --küçüktün büyüğe
Offset 2 row --baştan 2 atla, yani en düşük 3. salary
Fetch next 1 row Only;

--------------------***----------------------
--Yeni Table

CREATE TABLE customers_products
(
  product_id CHAR(10),
  customer_name VARCHAR(50),
  product_name VARCHAR(50)
);
INSERT INTO customers_products VALUES (10, 'Mark', 'Orange');
INSERT INTO customers_products VALUES (10, 'Mark', 'Orange');
INSERT INTO customers_products VALUES (20, 'John', 'Apple');
INSERT INTO customers_products VALUES (30, 'Amy', 'Palm');
INSERT INTO customers_products VALUES (20, 'Mark', 'Apple');
INSERT INTO customers_products VALUES (10, 'Adem', 'Orange');
INSERT INTO customers_products VALUES (40, 'John', 'Apricot');
INSERT INTO customers_products VALUES (20, 'Eddie', 'Apple');

Select * from customers_products;

--Product name değeri "Orange", "Apple" ve "Palm" olan recordları çağıralım 

--1.YOL: IN
Select * from customers_products
Where product_name IN ('Orange', 'Apple', 'Palm');

--2. YOl: Or ile eşitlik kurarak uzun yoldan
Select * from customers_products
Where product_name = 'Orange' OR product_name = 'Apple' OR product_name = 'Palm';

--product_name değeri "Orange", "Apple" ve "Palm" olmayan recordları çağıralım (Yani 'Apricot')
--Bu durumda not in kullanabiliriz
Select * from customers_products
Where product_name NOT IN ('Orange', 'Apple', 'Palm');

---***Between Condition***---
--product_id'si 30'a küçük veye eşit VE (and) 20'den büyük veya eşit olan ercordları çağırın

--1. YOL: AND ile
Select * from customers_products
Where product_id <= '30' and product_id >= '20'; --sayı char, yani string girildiği için tırnakta aldık

--2.YOL: BETWEEN AND ile
Select * from customers_products
Where product_id between '20' and '30'; 

--product_id değeri 20'den küçük, 30'dan büyük recordları çağır 
--yani 20-30 arası haricindekiler (NOT BETWEEN)
Select * from customers_products
Where product_id NOT between '20' and '30'; 

--***EXISTS Condition: Subquery ile kullanılır. 
--Eğer Subquery herhangi bir data çağırırsa 'outer query' çalıştırır.
--Eğer Subquery herhangi bir data çağırmazsa 'outer query' çalıştırmaz.
--EXISTS Condition Select, Insert, Update, Delete komutlarında kullanılabilir.

--Yeni bir table ile örnek

CREATE TABLE customers_likes
(
  product_id CHAR(10),
  customer_name VARCHAR(50),
  liked_product VARCHAR(50)
);
INSERT INTO customers_likes VALUES (10, 'Mark', 'Orange');
INSERT INTO customers_likes VALUES (50, 'Mark', 'Pineapple');
INSERT INTO customers_likes VALUES (60, 'John', 'Avocado');
INSERT INTO customers_likes VALUES (30, 'Lary', 'Cherries');
INSERT INTO customers_likes VALUES (20, 'Mark', 'Apple');
INSERT INTO customers_likes VALUES (10, 'Adem', 'Orange');
INSERT INTO customers_likes VALUES (40, 'John', 'Apricot');
INSERT INTO customers_likes VALUES (20, 'Eddie', 'Apple');
SELECT * FROM customers_likes;

--customer_name değerleri arasında Lary varsa (Exists) customer_name değerlerini 'No name' olarak güncelle.

Update customers_likes
Set customer_name = 'No name'
Where Exists(Select liked_product From customers_likes Where customer_name = 'Lary'); 
--Exists içine True verecek bir query yazıyoruz (mesela liked_product) ve sonra eğer Lary var ise koşulu koyuyoruz

-- liked_product değerleri arasında Orange, Pineapple ya da Avocado varsa customer_name değerlerini 'No name' olarak güncelle
--kayıtları sildiğimiz için tabloyu tekrar çağırıp yaptık
Update customers_likes
Set customer_name = 'No name'
Where Exists(Select liked_product From customers_likes 
             Where  liked_product IN ('Orange', 'Pineapple', 'Avocado' ));


--***SUBQUERY***--

--İki tablo üzerinden Subquery yapmaya çalışacağız.

--Table 1: employees

CREATE TABLE employees
(
  id CHAR(9),
  name VARCHAR(50),
  state VARCHAR(50),
  salary SMALLINT,
  company VARCHAR(20)
);
INSERT INTO employees VALUES(123456789, 'John Walker', 'Florida', 2500, 'IBM');
INSERT INTO employees VALUES(234567890, 'Brad Pitt', 'Florida', 1500, 'APPLE');
INSERT INTO employees VALUES(345678901, 'Eddie Murphy', 'Texas', 3000, 'IBM');
INSERT INTO employees VALUES(456789012, 'Eddie Murphy', 'Virginia', 1000, 'GOOGLE');
INSERT INTO employees VALUES(567890123, 'Eddie Murphy', 'Texas', 7000, 'MICROSOFT');
INSERT INTO employees VALUES(456789012, 'Brad Pitt', 'Texas', 1500, 'GOOGLE');
INSERT INTO employees VALUES(123456710, 'Mark Stone', 'Pennsylvania', 2500, 'IBM');
SELECT * FROM employees;


--Table 2: companies

CREATE TABLE companies
(
  company_id CHAR(9),
  company VARCHAR(20),
  number_of_employees SMALLINT
);
INSERT INTO companies VALUES(100, 'IBM', 12000);
INSERT INTO companies VALUES(101, 'GOOGLE', 18000);
INSERT INTO companies VALUES(102, 'MICROSOFT', 10000);
INSERT INTO companies VALUES(103, 'APPLE', 21000);
SELECT * FROM companies;

--number_of_employees değeri 15000'den büyük name ve company değerlerini çağır
--primary key ve foreign key olmadan bu şekilde yapabiliriz.

-- İki tabloda da olan ortak sütun (company) üzerinden yapabiliriz
Select name, company --iki sütun employees tablosunda var.
From employees
Where company IN(Select company --iki tablodaki ortak sütun, yani companies tablosunda da var
                 from companies Where number_of_employees > 15000);
                 

--Florida'da bulunan company_id ve company değerlerini çağırın
Select company_id, company
from companies  --Where ile biten ilk table'a ve Select ile başlayan subquery'deki 2. table'a ortak sütun
Where company IN(Select company 
                 from employees where state = 'Florida');
                 

--company_id değeri 100'den büyük olan name ve state değerlerini çağır
Select name, state
from employees
Where company IN(Select company
                from companies where company_id > '100');
