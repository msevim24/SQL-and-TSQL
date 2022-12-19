Create Table students
(
student_id smallint,  
student_name varchar(50),
student_age smallint,
student_dob date,
constraint student_id_fk foreign key(student_id) references parents(student_id)
);

-- Check Constraint nasıl eklenir:

Create Table students
(
student_id smallint,  
student_name varchar(50),
student_age smallint,
student_dob date,
constraint student_age_check check(student_age between 0 and 30), -- 0 ve 30 dahil
constraint student_name_chcek check(student_name = upper(student_name)) --isimlerin büyük harf olması şartı
);

--***Table'a veri nasıl girilir: Insert kullanılır

Create Table students
(
student_id smallint Primary Key,  
student_name varchar(50) Unique,
student_age smallint not null,
student_dob date,
constraint student_age_check check(student_age between 0 and 30),
constraint student_name_chcek check(student_name = upper(student_name)) 
);

Insert into students values(101, 'ALI CAN', 13, '10-Aug-2008'); 
--yukarıdaki sıraya göre giriyoruz. Değilse belirtmemiz gerekecek.
--yukarıdaki kısıtlamadan dolayı name'ler büyük olmalı
Insert into students values(102, 'VELI HAN', 14, '10-Aug-2007');
Insert into students values(103, 'AYSE TAN', 14, '10-Sep-2007'); 
--integer değerler single quote ile veya yalın kullanılabilir. Mesela id'yi tek tırnakla zayalım
Insert into students values('104', 'KEMAL KUZU', 14, NULL); 
Insert into students values(105, 'TOM HANGS', 25, '12-Sep-1996'); 
Insert into students values(106, 'ANGELINA JULIE', 30, '15-Sep-1991');
Insert into students values(107, 'BRAD PITT', 21, '26-JUL-1999'); 

Select * from students;

--Spesifik bir sütuna veri nasıl girilir: ilgili sütunlar yazılır, values giriliri girilmeyenler null olur.
Insert into students(student_id, student_age) values (108, 17);
--Gerçek tablodaki sıraya göre değil, içine yazdığımız sıraya göre values giriyoruz.
Insert into students(student_name, student_id, student_age) values ('JOHN WALKER', 109, 24);
Select * from students;

--Varolan bir data nasıl değştirilir: Update kullanılır
--yukarıdaki işlemlerde null olanlardan birine değer girelim...ID'si 108 olana isim girelim
Update students
Set student_name = 'LEO OCEAN'
Where student_id = 108;


-- John Walker dob sütunu 11-Dec-1997 değeriyle değiştir
--Genelde ID üzerinden eşleştiriyoruz. Burada İsim üzerinden de eşleştirebilirdik.
Update students
Set student_dob = '11-Dec-1997'
Where student_id = 109;

Select * from students;


--***2.Dersle devam...

--Çoklu record(satır) nasıl güncellenir
--id'si 106'dan küçük tüm dob değerlerini 01-Aug-2021 tarihine güncelleyelim

Update students 
Set student_dob = '01-Aug-2021'
Where student_id < 106;
--update olan tabloda en sona eklendi.


--Tüm age değerlerini en yüksek age (30) değerine güncelleyin

Update students
Set student_age = (Select max(student_age) from students); --students table'ından max age'i seç/çağır ve eşitle
--Where ile bir sınırlama/filtreleme koymadığımız için hepsi 30 yaşına eşitlendi.


--Tüm student_dob değerlerini en düşük dob değerine güncelleyelim
Update students
Set student_dob = (Select min(student_dob) from students); --Null değeri de değiştirdi.

Select * from students;


--*** Yeni Table oluşturalım
--Sütunları worker_id, worker_name, worker_salary olan bir workers table'ı oluşturun
--worker_id sütununu worker_id_pk adıyla primary key atayın
--4 record girişi yapın, Table'ı konsolda gösterin

Create table workers
(
worker_id smallint,
worker_name varchar(50),
worker_salary smallint,
Constraint worker_id_pk primary key (worker_id)
)

--değerleri girelim

Insert into workers values(101,'Ali Can', 12000);
Insert into workers values(102,'Veli Han', 2000);
Insert into workers values(103,'Ayse Kan', 7000);
Insert into workers values(104,'Angie Ocean', 8500);

Select * from workers;

--Veli Han'ın salary değerinin en yüksek salary değerinin %20 düşüğüne yükseltin
Update workers
Set worker_salary =(Select max(worker_salary)*0.8 from workers)
Where worker_name = 'Veli Han'; --worker_id ile de atanabilirdi

--Ali Can'ın salary değerini en düşük salary değerinin % 30 fazlasına düşürün
Update workers
Set worker_salary =(Select min(worker_salary)*1.3 from workers)
Where worker_name = 'Ali Can';

--Ortalama salary değerinden düşük olan salary değerlerini 1000 arttırın
Update workers
Set worker_salary = worker_salary + 1000 --ortalamanın 1000 üstüne değil kişinin salary'sinin 1000 üstüne
Where worker_salary < (Select avg(worker_salary) from workers);


--Ortalama salary değerinden düşük salary değerlerine ortalama salary değeri atayın
Update workers
Set worker_salary =(Select avg(worker_salary) from workers) --ortalamanın 1000 üstüne değil kişinin salary'sinin 1000 üstüne
Where worker_salary < (Select avg(worker_salary) from workers);

Select * from workers;

--***--***--***--***--***--***--
--is NULL Condition
--Yeni bir tabloda uygulayalım

Create table people
(
ssn char(9), --verinin bıyutu kesin ise...char daha az yer kaplar
name varchar(50),
address Varchar (80)
);

Insert into people values (123456789, 'Mark Star', 'Florida');
Insert into people values (234567890, 'Angie Way', 'Virginia');
Insert into people values (345678901, 'Marry Tien', 'New Jersey');
Insert into people (ssn, address) values (456789012, 'Michigan');
Insert into people (ssn, address) values (567890123, 'California');
Insert into people (ssn, name) values (678901234, 'California');

Select * from people;

--null name değerlerini "To be inserted later" değerine güncelleyin

Update people
Set name = 'To be inserted later'
Where name is Null; --eşittir yerine burada IS NULL kullanıyoruz

--null address değerlerini "To be inserted later" değerine güncelleyin
Update people
Set address = 'To be inserted later'
Where address is Null;

Select * from people;

--*** Bir table'dan record(row) nasıl silinir

--ssn = 234567890 olan kaydı silin
Delete from people
Where ssn = '234567890'; --Angie kaydı gitti

--İsimsiz recorları silin ('To be inserted later')
Delete from people
Where name = 'To be inserted later';

--Addresi belli olmayan kayıtları sil
Delete from people
Where address = 'To be inserted later';

-- Tüm recordları silmek istersek...
Delete from people
--(Delete command sadece recordları siler, table'ı yok etmez.)

Select * from people;

---*** Çoklu record silme ***---
--Yukarıdaki tabloyu tekrar getirelim (Tabloyu yandan düşürdük ve kodları tekrar kopyaladık) 

Create table people
(
ssn char(9), --verinin bıyutu kesin ise...char daha az yer kaplar
name varchar(50),
address Varchar (80)
);

Insert into people values (123456789, 'Mark Star', 'Florida');
Insert into people values (234567890, 'Angie Way', 'Virginia');
Insert into people values (345678901, 'Marry Tien', 'New Jersey');
Insert into people (ssn, address) values (456789012, 'Michigan');
Insert into people (ssn, address) values (567890123, 'California');
Insert into people (ssn, name) values (678901234, 'California');

Select * from people;

--Name va Address değerleri null olan recordları silelim
Delete from people
Where name is Null or address is Null;  --and kullanabilmemiz için aynı kayıtta null olması gerekirdi

--ssn değeri 123456789' dan büyük ve 345678901'den küçük olan recordları sil

Delete from people
Where ssn > 123456789 and ssn < 345678901;

Select * from people;

--data tipi char olduğu için bu işlemde hata verir. Tabloda ssn'deki CHAR'ı INT yapmak lazım. 
--Tırnakla yazınca da siliyor.
--people tablosunu düşürüp tekrar int değişikliği ile oluşturduk.
Create table people
(
ssn int, --char'ı int olarak değiştirdik.
name varchar(50),
address Varchar (80)
);

Insert into people values (123456789, 'Mark Star', 'Florida');
Insert into people values (234567890, 'Angie Way', 'Virginia');
Insert into people values (345678901, 'Marry Tien', 'New Jersey');
Insert into people (ssn, address) values (456789012, 'Michigan');
Insert into people (ssn, address) values (567890123, 'California');
Insert into people (ssn, name) values (678901234, 'California');

Select * from people;

--Şimdi iki ssn arasındaki kaydı silebiliriz
Delete from people
Where ssn > 123456789 and ssn < 345678901; --Angie silindi.

Select * from people;

--name değeri olmayan tüm recordları silelim (IS NOT NULLL)

Delete from people 
Where name IS NOT NULL;

Select * from people;

--***TRUNCATE ile silme durumunda roll back transaction yapmıyor.
--TRUNCATE command tğm recordları siler.
--DELETE ile aynı işlevi görür. 

--TRUNCATE ile DELETE arasındaki fark nedir?
--1) DELETE komutunda filtrelemek için WHERE clause lullanılabilir fakat TRUNCATE komutunda kullanılmaz.
--2) DELETE ile silinen recordları geri çağırabiliriz, fakat TRUNCATE'de geri çağrılamaz.
 
Truncate table people;

--Schema(birbiriyle ilişkili tablelar)'dan table nasıl kaldırılır:
Drop table people; --bunu kenardan ilgili table'a sağ tıklayarak da yapabiliyoruz.

--*****--*****--*****--*****--*****--
--DATA QUERY LANGUAGE (DQL)- Data okumak için kullanılan dil (SELECT)

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

--Tüm recordlar nasıl çağrılır:
Select * from workers;

--Spesific bir field (sütun) nasıl çağırılır:
Select name from workers;

--Spesifik çoklu fieldlar nasıl çağırılır:

Select name, salary 
from workers;

--Spisific bir recordı (row) nasıl çağırılır:
Select * --tüm row getirileceği için all anlamında *
from workers
Where id =10001;

--Çoklu spesifik recordlar nasıl çağırılır:
--Mesela id'si 10003'ten küçük olanları çağıralım

Select *
from workers
where id < 10003;

--Salary değerleri 2000, 7000 ya da 12000 olan recordları çağırın
--1. YOL: OR kullanarak
Select * from workers
Where salary = 2000 or salary = 7000 or salary = 12000 ;

--2.YOL: IN kullanarak (OR'ları tekrar etmek yerine IN kullanmak daha pratik)
Select * from workers
Where salary IN  (2000,7000,12000);

--Specific bir cell (hücre) nasıl çağırılır:
--Mesela Veli Han ismini getirelim
Select name
from workers
where id = 10002;

--En yüksek salary değeri olan record'ı çağıralım:
Select * 
from workers
Where salary = (Select max(salary) from workers); --parantez içindeki subquery

--En düşük salary değeri olan name'i çağıralım:
Select name
from workers
Where salary = (Select min(salary) from workers);


