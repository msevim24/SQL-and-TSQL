--Recordları azalan düzende "name" sütununa göre ve artan düzende "point" sütununa göre sırala.
CREATE TABLE points
(
    name VARCHAR(50),
    point SMALLINT
);
INSERT INTO points values('Ali', 25);
INSERT INTO points values('Veli', 37);
INSERT INTO points values('Kemal', 43);
INSERT INTO points values('Ali', 36);
INSERT INTO points values('Ali', 25);
INSERT INTO points values('Veli', 29);
INSERT INTO points values('Ali', 45);
INSERT INTO points values('Veli', 11);
INSERT INTO points values('Ali', 125);

SELECT * FROM points

SELECT * 
FROM points
ORDER BY name DESC, point; --iki soruyu tek satırda çözebiliyoruz. 
--des name, asc point olunca isimler kendi içinde sıralanmış oluyor.

--------------------------------------
CREATE TABLE employees
(
  employee_id CHAR(9),
  employee_first_name VARCHAR(20),
  employee_last_name VARCHAR(20)
);
INSERT INTO employees VALUES(14, 'Chris', 'Tae');
INSERT INTO employees VALUES(11, 'John', 'Walker');
INSERT INTO employees VALUES(12, 'Amy', 'Star');
INSERT INTO employees VALUES(13, 'Brad', 'Pitt');
INSERT INTO employees VALUES(15, 'Chris', 'Way');
SELECT * FROM employees;

CREATE TABLE addresses
(
  employee_id CHAR(9),
  street VARCHAR(20),
  city VARCHAR(20),
  state CHAR(2),
  zipcode CHAR(5)
);
INSERT INTO addresses VALUES(11, '32nd Star 1234', 'Miami', 'FL', '33018');
INSERT INTO addresses VALUES(12, '23rd Rain 567', 'Jacksonville', 'FL', '32256');
INSERT INTO addresses VALUES(13, '5th Snow 765', 'Hialeah', 'VA', '20121');
INSERT INTO addresses VALUES(14, '3rd Man 12', 'Weston', 'MI', '12345');
INSERT INTO addresses VALUES(15, '11th Chris 12', 'St. Johns', 'FL', '32259');
SELECT * FROM addresses;

----ALIASES (Takma adla isimlendirmeler) AS ile

--Table isimleri için alias nasıl kullanılır?:

--employee_first_name ve state değerlerini çağırın. 
--employee_first_name sütunu için "firstname", state sütunu için "employee state"  isimlerini kullanın.

SELECT e.employee_first_name AS firstname, a.state AS "employee state"  --tırnak içinde olunca "_" kullanmaya gerek yok.
FROM employees e, addresses a  -- tabloların başharfini alarak isimlendirdik.
WHERE e.employee_id = a.employee_id; --ortak olan sütunlar üzerinden çağısıyoruz.

--Tek bir sütuna çoklu sütun nasıl konulur ve ALIAS nasıl kullanılır:

--employee_id değerlerini "id" adıyla,  employee_first_name ve employee_last_name değerlerini tek sütunda "full_name" adıyla çağırın.
SELECT employee_id AS id, employee_first_name || ' ' || employee_last_name AS full_name --|| concat için
FROM employees;  --ikinci concat ad ve soyad arasına boşluk koymak için

--GROUP BY

CREATE TABLE workers
(
  id CHAR(9),
  name VARCHAR(50),
  state VARCHAR(50),
  salary SMALLINT,
  company VARCHAR(20)
);
INSERT INTO workers VALUES(123456789, 'John Walker', 'Florida', 2500, 'IBM');
INSERT INTO workers VALUES(234567890, 'Brad Pitt', 'Florida', 1500, 'APPLE');
INSERT INTO workers VALUES(345678901, 'Eddie Murphy', 'Texas', 3000, 'IBM');
INSERT INTO workers VALUES(456789012, 'Eddie Murphy', 'Virginia', 1000, 'GOOGLE');
INSERT INTO workers VALUES(567890123, 'Eddie Murphy', 'Texas', 7000, 'MICROSOFT');
INSERT INTO workers VALUES(456789012, 'Brad Pitt', 'Texas', 1500, 'GOOGLE');
INSERT INTO workers VALUES(123456710, 'Mark Stone', 'Pennsylvania', 2500, 'IBM');

SELECt * FROM workers;

--Her bir  name değeri için toplam salary değerlerini bulun.
SELECT name, SUM(salary) AS total_salary
FROM workers
GROUP BY name
ORDER BY total_salary DESC;  --oluşturduktan sonra çoktan aza sıralayalım.

--Her bir state değeri için çalışan sayısını bulup azalan düzende sıralayınız.

SELECT state, COUNT(state) AS num_of_employee
FROM workers
GROUP BY state
ORDER BY num_of_employee DESC;

--Her bir company için 2000$ üzeri maaş alan çalışan sayısını bulun.
SELECT company, COUNT(company) AS "Number of Workers" 
FROM workers
WHERE salary > 2000  --Where, group by'dan önce gelir.
GROUP BY company;

--Her bir company için en düşük ve yüksek salary değerlerini bulun.
SELECT company, MIN(salary) AS min_salary, MAX(salary) AS max_salary
FROM workers
GROUP BY company;

--HAVING Clause

--Toplam salary değeri 2500 üzeri olan her bir çalışan için salary toplamını bulun.
SELECT name, SUM(salary) AS "Total Salary"
FROM workers
GROUP BY name  --> Group by'dan sonra Where kullanılmaz, HAVING kullanılmalıdır.
HAVING SUM (salary) > 2500;  --Ayrıca toplama fonksiyonu where ile kullanılamaz.

--Birden fazla çalışanı olan, her bir state için çalışan toplamlarını bulun.
SELECT state, COUNT(state) AS num_of_employees
FROM workers
GROUP BY state
HAVING COUNT(state) > 1 --Having'den sonra Alias yazılamıyor, direkt fonksiyonu yazıyoruz.
--Having, Group Byardından filtreleme için kullanılır.

--Her bir company için değeri 2000'den fazla olan minimum salary değerlerini bulun.
SELECT company, MIN(salary) AS min_salary
FROM workers
GROUP BY company
HAVING MIN(salary)>2000;

--Her bir state için değeri 3000'den az olan maximum salary değerlerini bulun.
SELECT state, MAX(salary) AS max_salary
FROM workers
GROUP BY state
HAVING MAX(salary)<3000;,

--UNION Operator: 
--1) Iki sorgu(query) sonucunu birleştirmek için kullanılır.
--2) Unique recordları verir.
--3) Tek bir sütuna çok sütun koyabiliriz.
--4) Tek bir sütuna çok sütun koyarken data tipleri aynı olmalı, data boyutları kapasiteyi aşmamalı.

--salary değeri 3000'den yüksek olan state değerlerini ve 2000'den küçük olan name değerlerini tekrarsız olarak bulun.
SELECT state AS "State or Name", salary
FROM workers
WHERE salary > 3000
UNION      --Union kullanırken iki tarafta column sayısı eşit olmalı
SELECT name, salary
FROM workers
WHERE salary < 2000;

--salary değeri 3000'den yüksek olan state değerlerini ve 2000'den küçük olan name değerlerini tekrarlı olarak bulun.
SELECT state AS "State/Name", salary
FROM workers
WHERE salary > 3000
UNION ALL           --tekrarlı istediği için ALL ile kullandık, yoksa unique olarak verirdi.    
SELECT name, salary  --UNION ALL kullanınca OR gibi ikisi de ayrı ayrı gelir.
FROM workers
WHERE salary < 2000;

--salary değeri 1000'den yüksek, 2000'den az olan "ortak" name değerlerini bulun.
SELECT name 
FROM workers
WHERE salary > 1000
INTERSECT   --örtüşen/kesişen değerleri almak için kullanıyoruz. Unique recordlar olarak gelir.
SELECT name 
FROM workers
WHERE salary < 2000  --yukarıdakiyle data tipleri aynı olmalı

--salary değeri 2000'den az olan ve company değeri  IBM, APPLE yada MICROSOFT olan ortak "name" değerlerini bulun.
SELECT name 
FROM workers
WHERE salary < 2000
INTERSECT
SELECT name 
FROM workers
WHERE company  IN ('IBM', 'APPLE','MICROSOFT');

--EXCEPT (MINUS) Operator: Farklı küme gibi düşünebiliriz.
--Bir sorgu sonucundan başka bir sorgu sonucunu çıkarmak için kullanılır. Unique recordları verir.

--salary değeri 3000'den az ve GOOGLE'da çalışmayan name değerlerini bulun.
SELECT name
FROM workers
WHERE salary < 3000
EXCEPT
SELECT name
FROM workers
WHERE company = 'GOOGLE';

--UNION'ı iki ayrı sorgu için, JOIN ise iki farklı table'ı birleştirmek için kullanılır.
--JOIN...
--      1)INNER JOIN: Ortak(common) dataları verir. Kesişim kümesini almak için
--      2)LEFT JOIN: Birinci table'ın tüm datasını verir.
--      3)RIGHT JOIN: İkinci table'ın tüm datasını verir.
--      4)FULL JOIN: İki table'ın da tüm datasını verir.
--      5)SELF JOIN: Tek table üzerinde çaışırken iki table varmış gibi çalışılır.
--








