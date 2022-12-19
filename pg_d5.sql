--*** ORDER BY konusu devam

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
Select * from points;

--Recordları azalan düzende "name" sütununa göre ve artan düzende "points" sütununa göre sırala.
Select * from points
Order By name desc, point asc; --asc yazmasak da olur

-----*****------------***-----------
--Yeni tablolarla devam edelim. Buarada alias kullarak yapacağız.
--Table 1:
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

--Table 2:
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

--***---
--ALIASES

--Table isimleri için Alias kullanılır.

--employee_first_name ve state değerlerini çağırın. 
--employee_first_name sütunu için "firstname", state sütunu için "employee state" isimlerini kullanın.

Select e.employee_first_name AS firstname, a.state AS "employee state"
From employees e, addresses a --e ve a şeklinde tablo isimleri için kısaltma koyduk.
Where e.employee_id = a.employee_id;

--***Tek bir sütuna çoklu sütun nasıl konulur ve alias nasıl kullanılır***--

--employee_id değerlerini "id" adıyla,  employee_first_name ve employee_last_name değerlerini tek sütunda "full_name" adıyla çağırın.
--Concat işlemi için || kullanılıyor
Select employee_id AS id, employee_first_name || ' ' || employee_last_name AS full_name
From employees;

--***GROUP BY***---

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
Select * From workers;

--Her bir name değeri için toplam salary değerlerini azalan sırayla yazın.
Select name, SUM(salary) AS total_salary
From workers
Group by name
ORder by total_salary DESC;

--Her bir state değeri için çalışan sayısını bulup azalan düzende sıralayınız.
Select state, COUNT(*) AS number_of_workers_per_state -- "*" yerine state ile de saydırabilirdik
From workers
Group by state
Order by number_of_workers_per_state DESC;

--Her bir company için 2000$ üzeri maaş alan çalışan sayısını bulun.
Select company, COUNT(*) AS "2000_plus_salary"
From workers
Where salary > 2000
Group by company
Order by "2000_plus_salary" DESC;

--Her bir company için en düşük ve yüksek salary değerlerini bulun.
Select company, MIN(salary) AS min_salary , MAX(salary) AS max_salary
From workers
Group by company;

--Group By'dan sonra Where Clause kullanılmaz. Onun yerine Having Clause kullanılır, field name ile kullanılmaz.

--*****HAVING Clause******--
--HAVING, GROUP BY ardından filtrelemek için kullanılır. AGG functions ile çalışır.

--Toplam salary değeri 2500 üzeri olan her bir çalışan için salary toplamını bulun.
--Bunu Where ile yapamayız çünkü Aggregate Function (SUM, MAX, MIN, COUNT) Where ile çalışmaz. Field name alır.
Select name, SUM(salary) AS "Total Salary"
From workers
Group By name
Having SUM(salary) > 2500; --Toplam salary'si 2500 olan isimler

--Birden fazla çalışanı olan, her bir state için çalışan toplamlarını bulun.
Select state, COUNT(state) AS num_of_employees
From workers
Group by state
Having COUNT(state) > 1; 
--Having'ten sonra alias'ı değil aggregate function yazılmalı. "num_of_employees" aliasını kabul etmiyor.

--Her bir company için değeri 2000'den fazla olan minimum salary değerlerini bulun.
Select company, MIN(salary) AS min_salary
From workers
Group by company
Having MIN(salary) > 2000;

--Her bir state için değeri 3000'den az olan maximum salary değerlerini bulun.
Select state, MAX(salary) AS max_salary
From workers
Group by state
Having MAX(salary) < 3000;

--*****UNION Operator****--
--1) İki Query sonucunu birleştirmek için kullanılır. 
--2)Değerleri tekrarsız verir.
--3) Tek bir sütuna çok sütun koyabiliriz.
--4) Tek bir sütuna çok sütun koyarken data tipleri aynı olmalı ve data tipleri kapasiteyi aşmamalı.
--salary değeri 3000'den yüksek olan state değerlerini ve 2000'den küçük olan name değerlerini "tekrarsız" olarak bulun.
Select state AS "State or Name", salary
From workers
Where salary > 3000

UNION --İki ayrı task gibi yapıp birleştiriyoruz.

Select name, salary
From workers
Where salary < 2000;

--salary değeri 3000'den yüksek olan state değerlerini ve 2000'den küçük olan name değerlerini "tekrarlı" olarak bulun.
--Tekrarlı olması için UNION ALL kullanılır
Select state AS "State or Name", salary
From workers
Where salary > 3000

UNION ALL

Select name, salary
From workers
Where salary < 2000;

--***INTERSECT***--
--Eğer ortak değere ulaşmak istiyorsak Union yerine INTERSECT kullanılır. 
--Iki sorgu sonucunun common değerlerini verir. Unique recordları alır ve tek sütuna koyar.

--salary değeri 1000'den yüksek, 2000'den az olan "ortak" name değerlerini bulun.
Select name
From workers
Where salary > 1000

INTERSECT

Select name
From workers
Where salary < 2000; --İki taskte çakışan isimleri alıyor.

--salary değeri 2000'den az olan ve company değeri IBM, APPLE yada MICROSOFT olan ortak "name" değerlerini bulun.
Select name 
From workers
Where salary < 2000

INTERSECT

Select name 
From workers
Where company IN('IBM', 'APPLE', 'MICROSOFT');

--*****EXCEPT (MINUS) Operator*****-- Oracle'da MINUS
--Bir sorgu sonucunda başka bir sorgu sonucunu çıkarmak için kullanılır.
--Unique recordları verir.

--Kümelerdeki sisteme göre;
--Union A birleşim B
--Intersect A kesişim B
--Except A fark B

--salary değeri 3000'den az ve GOOGLE'da çalışmayan name değerlerini bulun.
Select name
From workers
Where salary < 3000

EXCEPT

Select name
From workers
Where company = 'GOOGLE';

-----------------***JOIN***----------------- Farklı tablolarda çalışıyor
--1) INNER JOIN: Ortak (common) datayı verir. İki table'daki kesişim datası.
--2) LEFT JOIN: Birinci table'ın tüm datasını verir.
--3) RIGHT JOIN: Ikinci table'ın tüm datasnı verir.
--4) FULL JOIN: Iki table'ın tüm datasını verir.
-- 5) SELF JOIN: Tek table üzerinde çalışırken iki table varmış gibi çalışılır.


