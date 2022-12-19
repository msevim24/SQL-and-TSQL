--***Constraints***

/* 
Bu kısıtlamalar: 1-Unique, 2-Not Null, 3-Primary Key, 4-Foreign Key, 5-Check Constraint
Tablonun üzerine sağ tıklayıp Properties'e bakınca bu değişiklikler ve ksısıtlamalar görünür.
unique key==> null değer dışındakiler tekrarsız olmalıdır. Çoklu null değer atanabilir.
primary key nul değer alamaz.


*/

--Primary Key oluştururken 2 yol kullanabiliriz.

--1. Yol: Yanlarına yazarak. Bu şekilde kendisi isim ataması yapıyor.
Create Table students
(
student_id smallint Primary Key,  
student_name varchar(50) not null,
student_age smallint,
student_dob date unique
);

Select * from students


--2. Yol: Constraint ile birlikte yazarak. Bu şekilde isim ataması da yapabiliyoruz.

Create Table students
(
student_id smallint,  
student_name varchar(50),
student_age smallint,
student_dob date,
constraint student_id_pk primary key(student_id)
);

--Foreign Key Constraint nasıl eklenir:
--FK'nın kullanılması için bir tabloya daha ihtiyacımız var. Bu yüzden bir de "parents" tablosu oluşturalım

Create table parents
(
student_id Smallint,
parent_name varchar(50),
phone_number char(11),
constraint student_id_pk primary key(student_id)
);

--foreign key oluştururken ilişki kurulacak table için referans vermezsek hata verir.
--Constraints sekmesindeki çift anahtar ikonu FK'yı, tek anahtar PK'yı belirtir.
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
Where student_id = 109

Select * from students;


