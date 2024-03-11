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

SELECT * FROM workers;

--En düşük ve en büyük salary değerlerine sahip recordları çağırın.
-- 1.Yol, IN ile kısa yoldan
SELECT * 
FROM workers
WHERE salary IN ((SELECT MAX(salary) FROM workers),(SELECT MIN(salary) FROM workers));

--2.Yol, OR ile uzun yoldan
SELECT * 
FROM workers
WHERE salary = (SELECT MAX(salary) FROM workers) OR salary = (SELECT MIN(salary) FROM workers);

--En yüksek salary değerini bulun ve isimlendirin. AS ile yaptığımız bu işlem geçici field oluştururç
SELECT MAX (salary) AS maximum_salary
FROM workers;

--En düşük salary değerini bulun ve isimlendirin.
SELECT MIN (salary) AS minimum_salary
FROM workers;

--Salary ortalamasını bulun ve isimlendirin.
SELECT AVG (salary) AS average_salary
FROM workers;

--Record sayısını (adetini) bulun. COUNT()
SELECT COUNT(name) AS number_of_workers
FROM workers;

--Salary değerlerinin toplamını bulun.
SELECT SUM(salary) AS total_salary
FROM workers;

--Interview Question: En yüksek ikinci salary değerini bulun.
SELECT MAX(salary) AS second_highest_salary  -- En büyükten sonraki büyük değeri çağırıyoruz.
FROM workers
WHERE salary < (SELECT MAX(salary) FROM workers);

--En düşük ikinci salary'i bulun
SELECT MIN(salary) AS second_lowest_salary  
FROM workers
WHERE salary > (SELECT MIN(salary) FROM workers);

--En yüksek üçüncü salary değerini bulun
--En yüksek ikinciden küçük olanı ver şeklinde çağıracağız. En yüksek ikinciyi diğer tarafa koyacağız.
SELECT MAX(salary) AS third_max_salary  
FROM workers
WHERE salary < (SELECT MAX(salary)
                FROM workers
                WHERE salary < (SELECT MAX(salary) FROM workers));
                
--En düşük üçüncü salary değerini bulun
SELECT MIN(salary) AS third_lowest_salary  
FROM workers
WHERE salary > (SELECT MIN(salary)
                FROM workers
                WHERE salary > (SELECT MIN(salary) FROM workers));
                
--Salary değeri en yüksek olan ikinci record'ı (tüm satır) çağırın.
--1. Yol
SELECT *
FROM workers
WHERE salary = (SELECT MAX(salary)
                FROM workers
                WHERE salary < (SELECT MAX(salary) FROM workers));
                
--2. Yol (Tavsiye edilen yol), ORDER BY ile sort yapıyoruz
SELECT * 
FROM workers
ORDER BY salary DESC --azalan şekilde sırala
OFFSET 1 ROW  --OFFSET ile 1 satır atla
FETCH NEXT 1 ROW ONLY;-- sadece sonraki birini yakala

--Osman Bey'in komutları
select * from (
            select row_number() OVER (ORDER BY salary) rownum,  a.* from workers a) bb
where rownum=3;

--Salary değeri en düşük ikinci değere sahip record'ı çağırın. ÖDEV 1. Yol ve 2. Yol

--Salary değeri en yüksek 3. olan record'ı çağırın.
--1. Yol: Uzun yol
SELECT *
FROM workers 
WHERE salary = (SELECT MAX(salary) AS third_max_salary
                FROM workers
                WHERE salary < (SELECT MAX(salary)
                FROM workers
                WHERE salary < (SELECT MAX(salary) FROM workers)));

--2. Yol:
SELECT *
FROM workers
ORDER BY salary DESC
OFFSET 2 ROW 
FETCH NEXT 1 ROW ONLY;

-- YENI TABLE
CREATE TABLE customers_products
(
  product_id INT,
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

SELECT * FROM customers_products

--product_name değeri orange, apple ve palm olan recordları çağırın
--1. Yol, OR ile uzum yoldan
SELECT *
FROM customers_products
WHERE product_name = 'Orange'OR product_name = 'Apple'OR product_name = 'Palm';

--2. Yol, IN ile kısa yoldan
SELECT *
FROM customers_products
WHERE product_name IN('Orange', 'Apple', 'Palm');

--product_name değeri Orange, Apple ya da Palm olmayan recordı çağırın. (NOT IN)
SELECT *
FROM customers_products
WHERE product_name NOT IN('Orange', 'Apple', 'Palm');

--BETWEEN Condition/NOT BETWEEN

--product_id'si 30'dan küçük-eşit VE 20'den büyük-eşit olanları çağırın
--1. Yol
SELECT *
FROM customers_products
WHERE product_id <= 30 AND product_id >=20;

--2 Yol: Between ile kısa yoldan...
SELECT *
FROM customers_products
WHERE product_id BETWEEN 20 AND 30; --20 ve 30 dahil

--product_id değeri 20'den küçük ve 30'dan büyük recordları çağırın.
SELECT *
FROM customers_products
WHERE product_id NOT BETWEEN 20 AND 30;

--EXISTS Condition - EXISTS Condition 'Subquery' ile kullanılır.
--      Eğer Subquery herhangi bir data çağırırsa 'Outer Query' çalıştırılır.
--      Eğer Subquery herhangi bir data çağırmazsa 'Outer Query' çalıştırılmaz.
--      EXISTS Condition Select, Insert, Update, Delete komutlarında kullanılabilir.

--Yeni Tablo
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

--customer_name değerleri arasında Lary varsa tüm customer_name değerlerini "No name" olarak güncelle.
--güncelle dendiği için UPDATE ile başlıyoruz.

UPDATE customers_likes
SET customer_name = 'No name'
WHERE EXISTS(SELECT liked_product FROM customers_likes WHERE customer_name = 'Lary');
--Yukarıda liked_product yerine herhangi bir sütun ismi de yazabilirdik. Önemli olan True vermesi

--liked_product değerleri arasında Orange, Pineapple ya da Avacoda varsa name değerlerini "No name" olarak güncelle.

UPDATE customers_likes
SET customer_name = 'No name'
WHERE EXISTS(SELECT customer_name FROM customers_likes WHERE liked_product IN ('Orange', 'Pineapple', 'Avocado'));

SELECT * FROM customers_likes;

--customer_name değerleri arasında Orange değeri varsa recordları silin. Tamamını siliyor
DELETE FROM customers_likes
WHERE EXISTS (SELECT liked_product FROM customers_likes WHERE liked_product = 'Orange');

--SUBQUERY

--Yeni Table
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

--2. Table

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

--number_of_employees değeri 15000'den büyük olan name ve company değerlerini çağırın.
SELECT name, company
FROM employees
WHERE company IN (SELECT company FROM companies WHERE number_of_employees > 15000);

--Florida'da bulunan company_id ve company değerlerini çağırın.
SELECT company_id, company
FROM companies
WHERE company IN (SELECT company FROM employees WHERE state = 'Florida'); 
--Parantez içinden IBM ve APPLE gelecek şekilde companyleri çağırıyoruz.

--company_id değeri 100'den büyük olan name ve state değerlerini çağırın.
SELECT name, state
FROM employees
WHERE company IN (SELECT company FROM companies WHERE company_id > '100');



