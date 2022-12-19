--1. Table
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

--2.Table

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

--**Her bir company için company, number_of_employees ve ortalama salary değerlerini bulun.
Select company, number_of_employees, (Select AVG(salary) from employees
                                    where companies.company =employees.company) AS avg_salary_per_company
from companies;
--İlk select'e tüm istenenleri yazıyoruz ancak avg (salary)'yi çekmek için iki table'daki company'leri eşitliyoruz
--İlk iki sütun companies'ten, avg ise employees tablosundan

--**Herbir company için company_id, company,  en yüksek ve en düşük salary değerlerini bulun.
--Min ve Max için ayrı ayrı hangi tablodan çağıracağımızı yazmamız gerekiyor.
Select company_id, company, (Select MAX(salary) from employees where companies.company =employees.company),
                            (Select MIN(salary) from employees where companies.company =employees.company)
from companies;

--*************************************************--
--***LIKE Condition: Wildcard ile kullanılır
--1) % : 0 ya da daha fazla karakteri temsil eder.

--'E' ile başlayan employee name değerlerini çağırın
Select name
from employees
Where name LIKE 'E%'; --'E' ile başlasın gerisi ne olursa olsun anlamında %

--'e' ile biten employee name değerlerini çağırın
Select name
from employees
Where name LIKE '%e'; --başında ne olursa olsun ama son harf 'e' olsun

--'B' ile başlayıp 't' ile biten employee 'name' değerlerini çağırın.
Select name
from employees
Where name LIKE 'B%t';

--Herhangi bir yerinde 'a' bulunan employee 'name' değerlerini çağırın.
Select name
from employees
Where name LIKE '%a%';

--Herhangi bir yerinde 'e' veya 'r' bulunan employee 'name' değerlerini çağırın.
Select name
from employees
Where name LIKE '%e%r%' OR name LIKE '%r%e%'; --iki ihtimal: ya e daha önce ya da r daha önce

--2) _ : Tek karakteri temsil eder.

--İkinci karakteri 'e' ve dördüncü karakteri 'n' olan "state" değerlerini çağırın.
Select state
from employees
Where state LIKE '_e_n%';

--Sondan ikinci karakteri 'i' olan "state" değerlerini çağırın.
Select state
from employees
Where state LIKE '%i_'; --herhangi bir kararkterle başlayabilir

--İkinci karakteri 'e' olan ve en az 6 karakteri bulunan "state" değerlerini çağırın.

Select state
from employees
Where state LIKE '_e____%';

--Ikinci karakterinden sonra herhangi bir yerinde 'i' bulunan "state" değerlerini çağırın.
Select state
from employees
Where state LIKE '__%i%';

-----*** Yeni bir tablo üzerinden devam edelim

CREATE TABLE words
(
  word_id CHAR(10) UNIQUE,
  word VARCHAR(50) NOT NULL,
  number_of_letters SMALLINT
);
INSERT INTO words VALUES (1001, 'hot', 3);
INSERT INTO words VALUES (1002, 'hat', 3);
INSERT INTO words VALUES (1003, 'hit', 3);
INSERT INTO words VALUES (1004, 'hbt', 3);
INSERT INTO words VALUES (1008, 'hct', 3);
INSERT INTO words VALUES (1005, 'adem', 4);
INSERT INTO words VALUES (1006, 'selena', 6);
INSERT INTO words VALUES (1007, 'yusuf', 5);

SELECT * FROM words;

--***NOT LIKE Condition**--

--Herhangi bir yerinde 'h' bulunmayan "word" değerlerini çağırın.
Select word
from words
Where word NOT LIKE '%h%';

-- 't' veya 'f' ile bitmeyen "word" değerlerini çağırın.
Select word
from words   --olumluda OR olurdu ama olumsuzda AND kullanılır. 
Where word NOT LIKE '%f' AND word NOT LIKE '%t'; 

--Hergangi bir karakterle başlayıp 'a' veya 'e' ile devam etmeyen "word" değerlerini çağırın.
Select word
from words   
Where word NOT LIKE '_a%' AND word NOT LIKE '_e%'; 

-------------****---------------
--Regular Expression Condition--

--İlk karakteri 'h', ikinci karakteri 'o', 'a' veya 'i' ve son karakteri 't' olan "word" değerlerini çağırın.

--1. YOL: Çoklu OR ve column tekrarı nedeniyle tavsiye edilmez. 
Select word
from words   
Where word LIKE 'ho%t' OR word LIKE 'ha%t' OR word LIKE 'hi%t';

--2. YOL: RegEx kullanarak
Select word
from words
Where word ~ 'h[oai](.*)t';

-- Tilda ~ : Benzer anlamında Regex'te LIKE yerine kullanılır.
--[oai]: köşeli parantezin içindekilerden herhangi biri
--(.*): 0 veya herhangi bir sayıda karakter, yani % Wildcard anlamında
-- parantez içindeki nokta "." _ Wildcard anlamında bir karakter

--İlk karakteri 'h', ikinci karakteri 'a'dan 'e'ye herhangi bir karakter ve son karakteri 't' olan "word" değerlerini çağırın.
Select word
from words
Where word ~ 'h[a-e](.*)t'; --iki şeyin arasında anlamında tire "-" kullanılır. [a-e] : a-e arasındakiler

--İlk karakteri 's', 'a' veya 'y' olan "word" değerlerini çağırın.
--İlk karakterin '^' şapka şeklinde özel yazımı var. Sadece köşeli parantez yazınca tam doğru sonuç gelmiyor.
Select word
from words
Where word ~ '^[say](.*)'; --şapka sonrasından yazılanla başlasın anlamında

--Son karakteri 'm', 'a' veya 'f' olan "word" değerlerini çağırın.
--En sona gelecek anlamında dolar işareti "$" kullanılır
Select word
from words
Where word ~ '(.*)[mfa]$'; --(.*) isteğe bağlı

--İlk karakteri 's' ve son karakteri 'a' olan "word" değerlerini çağırın.
Select word
from words
Where word ~ '^s(.*)a$'; --çoklu karakter olmadığı için [] kullanımına gerek yok

--Herhangi bir yerinde 'a' olan "word" değerlerini çağırın.
Select word
from words
Where word ~ 'a'; --sadece a karakteri yeterli

--İlk karakteri 'd' den 't' ye olan, herhangi bir karakter ile devam edip üçüncü karakteri 'l' olan "word" değerlerini çağırın.
Select word
from words
Where word ~ '^[d-t].l'; --Nokta ".", _Wildcard anlamında bir karakterlik yer tutar.

--İlk karakteri 'd' den 't' ye olan,  herhangi iki karakter ile devam edip dördüncü karakteri 'e' olan "word" değerlerini çağırın.
Select word
from words
Where word ~ '^[d-t]..e';

---***Başka bir table ile devam ediyoruz***---

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

--'E' başlayıp ve 'y' ile biten "name" değerleri dışındaki "name" değerlerini çağırın.

--1. YOL: NOT LIKE kullanarak


--2. YOL:Tilda ile
Select name
from workers
Where name ~ '^[^E](.*)[^y]$'; --köşeli parantez içine ^ şapka gelirse "-den farklı" anlamına gelir. 

--'E' ile başlayıp 'y' ile biten "name" değerlerini çağırın.
Select name
from workers
Where name ~ '^E(.*)y$';

--'J', 'B' yada 'E' ile başlayan VE 'r' yada 't' ile biten "name" değerlerini çağırın.
Select name
from workers
Where name ~ '^[JBE](.*)[rt]$';

--Son karakteri 'r' yada 't' olan YA DA ilk karakteri 'J','B', yada 'E' olan "name" değerlerini çağırın.
Select name
from workers
Where name ~ '^[JBE]' OR name ~'[rt]$';

--Son karakteri 'r' yada 't' olmayan VE ilk karakteri 'J','B', yada 'E' olmayan "name" değerlerini çağırın.
--1.YOL:
Select name
from workers
Where name ~ '^[^JBE](.*)[^rt]$'; 

--2.YOL:  AND
Select name
from workers
Where name ~ '^[^JBE]' AND name ~'[^rt]$'; --OR'un tersi olarak AND gelecek.

--Son karakteri 'r' yada 't' olmayan VEYA ilk karakteri 'J','B', yada 'E' olmayan "name" değerlerini çağırın.
Select name
from workers
Where name ~ '^[^JBE]' OR name ~'[^rt]$'; --birinden biri olmayacak.

--Herhangi bir yerinde 'a' yada 'k' bulunan "name" değerlerini çağırın.
Select name
from workers
Where name ~ '[ak]';

--İlk harfi 'A' dan 'F' ye bir karakter olan ve ikinci harfi herhangi bir karakter olup üçüncü harfi 'a' olan "name" değerlerini çağırın.
Select name
from workers
Where name ~ '^[A-F].a';

--İlk harfi 'A' dan 'F' ye bir karakter olan ve ikinci ve üçüncü harfi herhangi bir karakter olup dördüncü harfi 'i' olan "name" değerlerini çağırın.
Select name
from workers
Where name ~ '^[A-F]..i';

--Üçüncü karakteri 'o' yada 'x' olan "state" değerlerini çağırın.
Select state
from workers
Where state ~ '..[ox]';

--Üçüncü karakteri 'o' yada 'x' olmayan "state" değerlerini çağırın.
Select state
from workers
Where state ~ '^..[^ox]'; 
--yukarıdakinden farklı olarak başlangıç olduğunu belirtmek için en başa şapka koyduk. Yoksa diğerlerini de getiriyor.


--ODEV: Sondan üçüncü karakteri 'n' yada 'x' olan  "state" değerlerini çağırın.
Select state
from workers
Where state ~ '(.*)[nx]..$]'; --çalışmadı

--ODEV: Sondan üçüncü karakteri 'n' yada 'x' olmayan  "state" değerlerini çağırın.
Select state
from workers
Where state ~ '(.*)[^nx]..$]'; --çalışmadı

---------***************----------------
--ORDER BY: Recordları artan ya da azalan düzenle sıralamak için kullanılır.
--          ORDER BY sadece SELECT Statement ile kullanılır.

--Words tablosundan recordları artan düzende number_of_letters değerine göre sırala.
Select *
from words
Order By number_of_letters asc; --asc yazmasak da default olarak asc alacak

--Recordları azalan düzende word sütununa göre sırala.
Select *
from words
Order By word desc;

--NOT: Sütun adı yerine sütun numarıyla da sıralama yapabiliriz.
Select *
from words
Order By 3 desc; --Burada 3, number_of_letters sütununu temsil ediyor.


