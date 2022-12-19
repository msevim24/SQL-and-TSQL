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

--1) INNER JOIN: Sadece JOIN de aynı anlamda

--Ortak companyler için company_name, order_id ve order_date değerlerini çağırın.
--JOIN'den sonra ortak sütünları ON ile eşitleyerek yazıyoruz.
Select  c.company_name, o.order_id, o.order_date
From my_companies c JOIN orders o
ON c.company_id = o.company_id;

--2) LEFT JOIN

--my_companies table'ındaki companyler için order_id ve order_date değerlerini çağırın.
Select  c.company_name, o.order_id, o.order_date
From my_companies c LEFT JOIN orders o
ON c.company_id = o.company_id;  --left/right join'de karşılığı olmayanlar birleşmede null gelir.

--3) RIGHT JOIN
--1. YOL:
--Orders table'ındaki company'ler için company_name, company_id ve order_date değerlerini çağırın.
Select  c.company_name, o.company_id, o.order_date
From my_companies c RIGHT JOIN orders o  
ON c.company_id = o.company_id; --Bu sefer Left'ten gelenlerin olmayan değeri için NULL

--2. YOL: ya da sıralam adeğiştirilip left join yapılabilir.
Select  c.company_name, o.company_id, o.order_date
From orders o LEFT JOIN  my_companies c 
ON o.company_id = c.company_id; --Aynı data gelir.

--4) FULL JOIN

--İki table'dan da company_name, order_id ve order_date değerlerini çağırın.
Select  c.company_name, o.company_id, o.order_date
From orders o FULL JOIN  my_companies c 
ON o.company_id = c.company_id; --Iki tarafta da eksik bilgiler NULL olarak gelecek.

--5)SELF JOIN

--Burada tek tablo üzerinden join işlemi yapıldığı için Self Join oluyor. Tablolara farklı isimler veriyoruz.
--Workers tablosundan yapalım
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
--SELF JOIN olarak kodu tanımıyor. Galiba mantık Self Join ama kod INNER JOIN
Select employee.name, manager.name
From workers employee INNER JOIN workers manager --farklı tabloymuş gibi isimlendiriyoruz.
ON employee.manager_id = manager.id;

--****ALTER TABLE*****--

--1)Field(Sütun) Ekleme:
ALTER TABLE workers
ADD company_industry VARCHAR(20); --yeni bir sütun ekledik. Data type ekledik.

--2)Default değer ile sütun ekleme
ALTER TABLE workers
ADD worker_address VARCHAR(80) DEFAULT 'Miami, FL, USA'; --tüm satırlara default olarak bu adresi atadı.

--3)Çoklu field ekleme
ALTER TABLE workers
ADD COLUMN number_of_workers CHAR(5) DEFAULT 0, --default olarak hepsine 0 değeri yaz.
ADD COLUMN number_of_ceo VARCHAR(20); --değer verilmediği için NULL

--4) Field (sütun) nasıl kaldırılır
ALTER TABLE workers
DROP COLUMN number_of_ceo; --ceo kolonunu sildik.

--5) Table nasıl yeniden adlandırılır: RENAME TO ...
ALTER TABLE workers
RENAME TO calisanlar; --Tabloya yeni isim verdik.

--6)Field (sütun) nasıl yeniden adlandırılır: RENAME COLUMN ... TO ...
ALTER TABLE calisanlar
RENAME COLUMN company_industry TO company_profession;

--7) Field nasıl modifiye edilir (constraint ekleme, data typi ya da kapasitesini değiştirme)

--NOT: Constraint eklerken mevcut data tiplerine dikkat ediniz.

--a)Constraint ekleme:

--a1)number_of_workers sütununu "not null" constraint ekleylim
ALTER TABLE calisanlar
ALTER COLUMN number_of_workers SET NOT NULL; --SET ile yapılıyor. 
--Yandan tablodaki sütun ismine sağ tıklayıp Properties yaparak bakılabilir değişikliğe

----a2)company_profession sütununa "UNIQUE" constraint ekleyin.
ALTER TABLE calisanlar
ADD CONSTRAINT company_profession_unique UNIQUE(company_profession);
--Önce constraint için isim veriyoruz, sonra hangisine ne şekilde constraint verceğimizi yazıyoruz.

--a3)worker_address sütununa "UNIQUE" constraint ekleyin.
ALTER TABLE calisanlar
ADD CONSTRAINT worker_address_unique UNIQUE(worker_address);
--!!!Mevcut veri tekrarlı olduğundan Unique constraint atanamadı. Yani zaten hepsi "Miami, FL, USA"
--Uyarı: Key (worker_address)=(Miami, FL, USA) is duplicated.

--b)Data Tipi/Boyutunu değiştirme:
--b1)company_profession sütununun data tipini CHAR(5) yapın.
ALTER TABLE calisanlar
ALTER COLUMN company_profession TYPE CHAR(5); --type değişimi için ALTER COLUMN...TYPE ...

--b2)worker_address sütunun data tipini CHAR(5) yapın.
ALTER TABLE calisanlar
ALTER COLUMN worker_address TYPE CHAR(5); --Daha önce girilen adresler 5'ten fazla. O yüzden kabul etmez.
--Uyarı: value too long for type character(5)

--b3)worker_address sütununun data tipini CHAR(30) yapın.
ALTER TABLE calisanlar
ALTER COLUMN worker_address TYPE CHAR(30); --bunu kabul etti çünkü mevcut adres karakteri 30'dan az.

Select * From calisanlar;

--***Function (Fonksiyon) nasıl yazılır:      ***--

--Bazı görevleri daha hızlı yapabilmek için function oluşturulur.
--CRUD operation için function oluşturulur
--SQL'de her function return typr olarak bir data verir.
--Return type olarak data vermeyen işlemlere "Procedure" denir.

CREATE OR REPLACE FUNCTION addf (x NUMERIC, y NUMERIC) --function için bir isim veriyoruz. Function daha önce varsa Replace geçerli olur. 
RETURNS NUMERIC --değişkenler için de isim ve türünü tanımlıyoruz. RETURNS çoğul şeklinde
LANGUAGE plpgsql --Dili Postgre sql olsun
AS --Dolar işareti ile başlayıp bitiyor
$$
    BEGIN

    RETURN x+y; --neyi return olarak vermesini istiyorsak...

    END
$$

SELECT * FROM addf(2,3) AS "Addition"; --Fonksiyona yeni isim verdik. x ve y değerlerin verdik.


--Koninin hacmini hesaplayan bir function yazın
CREATE OR REPLACE FUNCTION volume (r NUMERIC, h NUMERIC) 
RETURNS NUMERIC --değişkenler için de isim ve türünü tanımlıyoruz. RETURNS çoğul şeklinde
LANGUAGE plpgsql --Dili Postgre sql olsun
AS --Dolar işareti ile başlayıp bitiyor
$$
    BEGIN

    RETURN 3.14*r*r*h*1/3; --neyi return olarak vermesini istiyorsak...

    END
$$

SELECT * FROM volume (2,5);

