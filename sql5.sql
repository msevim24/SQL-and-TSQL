CREATE TABLE my_companies
(
  company_id CHAR(3),
  company_name VARCHAR(20)
);
INSERT INTO my_companies VALUES(100, 'IBM');
INSERT INTO my_companies VALUES(101, 'GOOGLE');
INSERT INTO my_companies VALUES(102, 'MICROSOFT');
INSERT INTO my_companies VALUES(103, 'APPLE');
SELECT * FROM my_companies;

CREATE TABLE orders
(
  company_id CHAR(3),
  order_id CHAR(3),
  order_date DATE
);
INSERT INTO orders VALUES(101, 11, '17-Apr-2020');
INSERT INTO orders VALUES(102, 22, '18-Apr-2020');
INSERT INTO orders VALUES(103, 33, '19-Apr-2020');
INSERT INTO orders VALUES(104, 44, '20-Apr-2020');
INSERT INTO orders VALUES(105, 55, '21-Apr-2020');
SELECT * FROM orders;

--JOINS: 1) INNER JOIN : Ortak (common) data verir.
--       2) LEFT JOIN : Birinci table'ın tüm datasını verir.
--       3) RIGHT JOIN : İkinci table'ın tüm datasını verir.
--       4) FULL JOIN : İki table'ın da tüm datasını verir.
--       5) SELF JOIN : Tek table üzerinde çalışırken iki table varmış gibi çalışılır.

--1)INNER JOIN
--Ortak companyler için company_name, order_id ve order_date değerlerini çağırın.

SELECT mc.company_name, o.order_id, o.order_date
FROM my_companies mc INNER JOIN orders o --ALIAS kullandık
ON mc.company_id =o.company_id; -- FROM kısmına table isimlerini yazıp sonra WHERE ile de ortak sütunları eşleştirseydik olurdu.

--2)LEFT JOIN
--my_companies table'ındaki companyler için order_id ve order_date değerlerini çağırın.

SELECT mc.company_name, o.order_id, o.order_date
FROM  my_companies mc LEFT JOIN orders o
ON mc.company_id = o.company_id;

--3) RIGHT JOIN
--Orders table'ındaki company'ler için company_name, company_id ve order_date değerlerini çağırın.

SELECT mc.company_name, o.company_id, o.order_date
FROM  my_companies mc RIGHT JOIN orders o
ON mc.company_id = o.company_id;

--4)FULL JOIN
--İki table'dan da company_name, order_id ve order_date değerlerini çağırın.

SELECT mc.company_name, o.order_id, o.order_date
FROM  my_companies mc FULL JOIN orders o
ON mc.company_id = o.company_id;

--5)SELF JOIN

CREATE TABLE workers
(
  id CHAR(2),
  name VARCHAR(20),
  title VARCHAR(60),
  manager_id CHAR(2)
);
INSERT INTO workers VALUES(1, 'Ali Can', 'SDET', 2);
INSERT INTO workers VALUES(2, 'John Walker', 'QA', 3);
INSERT INTO workers VALUES(3, 'Angie Star', 'QA Lead', 4);
INSERT INTO workers VALUES(4, 'Amy Sky', 'CEO', 5);
SELECT * FROM workers;

--workers tablosunu kullanarak çalışanların yöneticilerini gösteren bir tablo hazırlayın.
SELECT employee.name, manager.name
FROM workers employee INNER JOIN workers manager --Aslınca SELF JOIN kodunu kullanmıyoruz INNER JOIN ile bişleştiriyoruz.
ON employee.manager_id = manager.id;

--ALTER TABLE: tablo üzerinde değişiklikler yapıyoruz.

--1)Fİled(Sütun) Ekleme:
ALTER TABLE workers
ADD company_industry VARCHAR(20);

--2)Default (Varsayılan) değer ile sütun ekleme:
ALTER TABLE workers 
ADD worker_address VARCHAR(80) DEFAULT 'Miami, FL, USA'

--3)Çoklu Field (Sütun) ekleme
--Çoklu eklerken ne ekleyeceğimizi belirtmemiz gerekiyor Postgre'de
ALTER TABLE workers 
ADD COLUMN number_of_workers CHAR(5) DEFAULT 0, --hepsi sıfır ile başlayacak
ADD COLUMN name_of_ceo VARCHAR(20);

--4)Field(Sütun) nasıl kaldırılır:
ALTER TABLE workers
DROP COLUMN name_of_ceo;

--5)Field yeniden nasıl adlandırılır
ALTER TABLE workers
RENAME COLUMN company_industry TO company_profession;

SELECT * FROM workers;
--6)Table yeniden nasıl adlandırılır
ALTER TABLE workers
RENAME TO employees;

SELECT * FROM employees; --yeni isimle tabloyu görebiliriz.

--7) Field nasıl modifiye edilir: (constraint ekleme, data tipi veya kapasitesini değiştirme)
--NOT: contraint eklerken mevcut data tiplerine dikkat edilmesi gerekiyor.

--a)constraint ekleme:
--a1)number_of_workers sütununa "NOT NULL" constraint ekleyin:

ALTER TABLE employees
ALTER COLUMN number_of_workers SET NOT NULL;

--a2)company_profession sütununa "UNIQUE" constraint ekleyin.
--Multiple null kabul eder ama harici tekrar kabul etmez. Unique için ADD CONSTRAINT
ALTER TABLE employees
ADD CONSTRAINT company_profession_unique UNIQUE(company_profession); --önce isimlendirdik...

SELECT * FROM employees;

--a3)worker_address sütununa "UNIQUE" constraint ekleyin.
ALTER TABLE employees
ADD CONSTRAINT worker_address_unique UNIQUE(worker_address);
--Mevcut veri duplicate değerler almış olduğundan Unique Constraint atanamaz.

--b) Data Tipi/Boyutunu değiştirme:
--b1)company_profession sütununun data tipini CHAR(5) yapın.
ALTER TABLE employees
ALTER COLUMN company_profession TYPE CHAR(5);

--b2)worker_address sütunun data tipini CHAR(5) yapın.
ALTER TABLE employees
ALTER COLUMN worker_address TYPE CHAR(5);
--Daha önce girilen karakter sayısı çok yüksek olduğu için CHAR(5) olarak küçültülememektedir.

--b3)worker_address sütununun data tipini CHAR(30) yapın.
ALTER TABLE employees
ALTER COLUMN worker_address TYPE CHAR(30);

SELECT * FROM employees;

--FUNCTION Nasıl Yazılır?
--Bazı görevleri daha hızlı yapabilmek için function oluşturulur. Mesela ortalama alma vs.
--CRUD operation için function oluşturulabilir.

--SQL'de her function return type olarak bir data verir.
--Return type olarak data vermeyen işlemlere "Procedure" denir.

CREATE OR REPLACE FUNCTION addf(x NUMERIC, y NUMERIC)
RETURNS NUMERIC
LANGUAGE plpgsql
AS 
$$
    BEGIN
    RETURN x+y;
    END
$$

SELECT * FROM addf(-3,3) AS "Addition";

--Koninin hacmini hesaplayan bir formül yazınız.
CREATE OR REPLACE FUNCTION volume_of_column(r NUMERIC, h NUMERIC)
RETURNS NUMERIC
LANGUAGE plpgsql
AS 
$$
    BEGIN
    RETURN (3.14*r*r*h*1/3);
    END
$$

SELECT * FROM volume_of_column(-3,6) AS "Volume";