--Table'a veri nasıl girilir:
CREATE TABLE students
(
    student_id SMALLINT PRIMARY KEY,
    student_name VARCHAR(50) UNIQUE,
    student_age SMALLINT NOT NULL,
    student_dob DATE,
    CONSTRAINT student_age_check CHECK(student_age BETWEEN 0 AND 30),-- 0 ve 30 dahil
    CONSTRAINT student_name_upper_case CHECK(student_name = upper(student_name))
);
--1.Yol: Tüm sütunlara veri girme:
INSERT INTO students VALUES('101', 'ALI CAN', 13, '10-Aug-2021');
INSERT INTO students VALUES('102', 'VELI HAN', 14, '10-Aug-2007');
--Integer değerler single quotes ile veya yalın kullanılabilir.
INSERT INTO students VALUES(103, 'AYSE TAN', 14, '08-Aug-2007');
INSERT INTO students VALUES(104, 'KEMAL KUZU', 15, null);
--VARCHAR, single quote ile kullanılmak zorundadır.
INSERT INTO students VALUES('105', 'TOM HANKS', 25, '12-Sep-1996');
INSERT INTO students VALUES('106', 'ANGELINA JULIE', 30, '12-Sep-1986');
INSERT INTO students VALUES('107', 'BRAD PITT', 0, '10-Aug-2021');
--2.Yol: Spesifik bir sütuna veri nasıl girilir:
INSERT INTO students(student_id, student_age) VALUES('108', 17);
INSERT INTO students(student_name, student_id, student_age) VALUES('JOHN WALKER', '109', 24);
--Varolan bir data nasıl değiştirilir:
UPDATE students
SET student_name = 'LEO OCEAN'
WHERE student_id = '108';
--John Walker, dob sütununu to 11-Dec-1997 değerine değiştirin.
UPDATE students
SET student_dob = '11-Dec-1997'
WHERE student_id = '109';
--Çoklu hücre(cell) nasıl değiştirilir:
--105 id'li dob hücresini 11-Apr-1996 değerine ve name hücresini TOM HANKS değerine güncelle.
UPDATE students
SET student_dob = '11-Apr-1996',
    student_name = 'TOM HANKS'
WHERE student_id = '105';

--Coklu record(satır) nasıl güncellenir?:
--ID'si 106'dan küçük tüm dob değerlerini 01-Aug-2021 tarihine göre güncelle.

UPDATE students
SET student_dob = '01-Aug-2021'
WHERE student_id < '106'; --Update ettiklerini listenin sonuna atıyor.

--Tüm age değerlerini en yüksek age değerlerine güncelleyin.

UPDATE students 
SET student_age =(SELECT MAX(student_age) FROM students);

--Tüm student_dob değerlerini en düşük stundet_dob değerine güncelleyin.
UPDATE students
SET student_dob = (SELECT MIN(student_dob) FROM students);

SELECT * FROM students;

--TASK:
--Sutunları (fields) worker_id,worker_name, worker_salary olan bir "workers" table'ı oluşturun.
--worker_id sütununu worker_id_pk adıyla primary key atayın 
--4 record girişi yapın ve table'ı konsolda görüntüleyin

CREATE TABLE workers
(
worker_id SMALLINT,
worker_name VARCHAR(50),
worker_salary SMALLINT,
CONSTRAINT worker_id_pk PRIMARY KEY(worker_id)
);

INSERT INTO workers VALUES(101, 'Ali Can', 13000);
INSERT INTO workers VALUES(102, 'Veli Han', 11000);
INSERT INTO workers VALUES(103, 'Ayse Tan', 7000);
INSERT INTO workers VALUES(104, 'Angie Ocean', 8500); 
    
--Veli Han'ın salary değerini en yüksek salary değerinin %20 düşüğüne yükseltin.

UPDATE workers 
SET worker_salary = (SELECT MAX(worker_salary)*0.8 FROM workers)
WHERE worker_id = 102;

--Ali Can'ın salary değerini en düşük salary değerinin %30 fazlasına düşürün.

UPDATE workers 
SET worker_salary = (SELECT MIN(worker_salary)*1.3 FROM workers)
WHERE worker_id = 101;

--Ortalama salary değerinden düşük olan salary değerlerini 1000 arttır.
UPDATE workers 
SET worker_salary = worker_salary + 1000 
WHERE worker_salary < (SELECT AVG (worker_salary) FROM workers); --update'ler sona gelir.

--Ortalama salary değerinden düşük olan salary değerlerini ortalamaya eşitleyin.
UPDATE workers 
SET worker_salary = (SELECT AVG (worker_salary) FROM workers)
WHERE worker_salary < (SELECT AVG (worker_salary) FROM workers);

SELECT * FROM workers;

--IS NULL Condition
CREATE TABLE people
(
ssn INT,
name VARCHAR(50),
address VARCHAR(80)
);

INSERT INTO people VALUES(123456789, 'Mark Star', 'Florida');
INSERT INTO people VALUES(234567890, 'Angie Way', 'Virginia');
INSERT INTO people VALUES(345678901, 'Maryy Tien', 'New Jersey');
INSERT INTO people(ssn, address) VALUES(456789012, 'Michigan');
INSERT INTO people(ssn, address) VALUES(567890123, 'California');
INSERT INTO people(ssn, name) VALUES(567890123, 'California');

SELECT * FROM people;

--Null name değerlerini "To be inserted later" değerine güncelleyin. 

UPDATE people
SET name = 'To be inserted later'
WHERE name IS NULL;

--Null address değerlerini "To be inserted later" değerine güncelleyin
UPDATE people
SET address = 'To be inserted later'
WHERE address IS NULL;

--Bir Table'dan record(row) nasıl silinir?
DELETE FROM people
WHERE ssn = '234567890';

--Isimsiz recordları sil
DELETE FROM people
WHERE name = 'To be inserted later';

--Tüm recordları(rowları) silmek için...
DELETE FROM people; --Delete command sadece recordları siler. Tablo durur ancak veriler gider.

--Name ve address değerleri null olan recordları silin
DELETE FROM people
WHERE name IS NULL OR address IS NULL;

--ssn değeri 123456789'dan büyük ve 345678901'den küçük olan recordları silin.
DELETE FROM people
WHERE ssn > '123456789' AND ssn < '345678901';

--name değeri null olmayan tüm recordları silin
DELETE FROM people
WHERE name IS NOT NULL;

-- TRUNCATE commandtüm recordları siler.
--DELETE ile kımsen ayni işlevi görür, farkı;
--1)DELETE comutunda  filtrelemek için WHERE claus kullanılabilir. TRUNCATE'de kullanılamaz.
--2)DELETE komutunda sildiğimiz recordları geri çağırabiliriz(roll back), fakat TRUNCATE'de çağıramayız.
TRUNCATE TABLE people;

--Schema(ilişkili table'lar)'dan table nasıl kaldırılır?:
DROP TABLE people; --bunu yandan manuel de yapabiliyoruz.


SELECT * FROM people;

--DQL: Data Query Language. Data okumak için kullanılan dil.

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

--Tüm recordlar nasıl çağırılar:
SELECT *
FROM workers;

--Spesific bir field(sütun) nasıl çağırılır?:
SELECT name
FROM workers;

--Spesific çoklu fieldlar nasıl çağırılır?:
SELECT name, salary
FROM workers;

--Spesific bir record(row) nasıl çağırılır?:
SELECT *  --tüm sütunlardan id'si verilen satırı getir
FROM workers
WHERE id = 10001;

--Çoklu spesific recordlar nasıl çağırılır?:
SELECT *  
FROM workers
WHERE id < 10003;

--Salary değerleri 2000, 7000 ya da 12000 olanları çağırın.
--1.Yol
SELECT *  
FROM workers
WHERE salary = 2000 OR salary = 7000 OR salary = 12000;

--2.yol, tekrar tekrar OR kullanmak yerine IN ile yazıyoruz.
SELECT *  
FROM workers
WHERE salary IN(2000, 7000, 12000);

--Spesific bir hücre nasıl çağırılır?:
SELECT name 
FROM workers
WHERE id = 10002;


--En yüksek salary değeri olan record'ı çağırın.
SELECT *   --tüm sütunlar içinden max salary içeren sütunu arıyoruz
FROM workers
WHERE salary = (SELECT MAX (salary) FROM workers);

--En düşük salary değeri olan name'i çağırın.
SELECT name  
FROM workers
WHERE salary = (SELECT MIN (salary) FROM workers);



