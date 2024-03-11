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

--Her bir company için company, number_of_employees ve ortalama salary değerini bulunuz.

SELECT company, number_of_employees, (SELECT AVG(salary) FROM employees
                                      WHERE companies.company = employees.company) AS avg_salary --company ortak sütun
FROM companies; --yukarıdaki iki sütun company tablosundan, diğeri de employees'den geldi.

--Her bir company için company_id, company, en yüksek ve en düşük salary değerlerini bulunuz.

SELECT company_id, company, (SELECT MAX(salary) FROM employees WHERE companies.company = employees.company),
                            (SELECT MIN(salary) FROM employees WHERE companies.company = employees.company)
FROM companies;

--LIKE Condition: Wildcard ile kullanılır.
--1) % Wildcard: Sıfır ya da daha fazla karakteri temsil ediyor.

--'E' ile başlayan employee "name" değerlerini çağırın.
SELECT name 
FROM employees
WHERE name LIKE 'E%'; --E ile başlasın, ardından ne gelirse gelsin

--"e" ile biten employee namelerini çağırın.
SELECT name 
FROM employees
WHERE name LIKE '%e'; --başında ne olursa olsun, en sonda "e" olacak

--B ile başlatıp t ile biten name...
SELECT name 
FROM employees
WHERE name LIKE 'B%t';

--Herhangi bir yerinde "a" bulunan name'leri çağırın.
SELECT name 
FROM employees
WHERE name LIKE '%a%';

--Herhangi bir yerinde 'e' veya 'r' bulunan employee 'name' değerlerini çağırın.
SELECT name 
FROM employees
WHERE name LIKE '%e%k%' OR name LIKE '%k%e%';

--2)underscore "_"Wildcard: tek karakteri temsil eder.

--İkinci karakteri 'e' ve dördüncü karakteri 'n' olan "state" değerlerini çağırın.
SELECT state 
FROM employees
WHERE state LIKE '_e_n%'; --% olmayınca n'yi son karakter olarak algılıyor.

--Sondan ikinci karakteri 'i' olan state değerlerini çağırın.
SELECT state 
FROM employees
WHERE state LIKE '%i_';

--İkinci karakteri 'e' olan ve en az 6 karakteri bulunan "state" değerlerini çağırın.
SELECT state 
FROM employees
WHERE state LIKE '_e____%';

--İkinci karakterinden sonra herhangi bir yerinde 'i' bulunan "state" değerlerini çağırın.
SELECT state 
FROM employees
WHERE state LIKE '__%i%';

-----

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

--NOT LIKE Condition

--Herhangi bir yerinde 'h' bulunmayan "word" değerlerini çağırın.
SELECT word
FROM words
WHERE word NOT LIKE '%h%';

--'t' veya 'f' ile bitmeyeb "word" değerlerini çağırın.
SELECT word
FROM words
WHERE word NOT LIKE '%t' AND word NOT LIKE '%f'; 
--NOT LIKE OR'u AND'e çevirir. OR olarak anlaması için AND yazıyoruz.

--Hergangi bir karakterle başlayıp 'a' veya 'e' ile devam etmeyen "word" değerlerini çağırın.
SELECT word
FROM words
WHERE word NOT LIKE '_a%' AND word NOT LIKE '_e%';


--Regular Expression Condition:
--İlk karakteri 'h', ve ikinci karakteri 'o', 'a' veya 'i' ve son karakteri 't'  olan "word" değerlerini çağırın.
--1. Yol: LIKE kullanarak uzun yoldan...==>tekrar sebebiyle tavsiye edilmez.
SELECT word
FROM words
WHERE word LIKE 'ho%t' OR word LIKE 'ha%t' word LIKE 'hi%t';

--2. Yol: Regex kullanarak... ~ tilda işaretiyle yazıyoruz.
SELECT word
FROM words                  --[] or anlamında birden fazla ihtimal varsa
WHERE word ~ 'h[oai](.*)t'; --(.*) sıfır ya da daha çok, olabilir de olmayabilir de anlamında


--Ilk karakteri 'h', son karakteri 't' ve ikinci karakteri 'a'dan 'e'ye herhangi bir karakter olan "word" değerlerini çağırın.
SELECT word
FROM words                  
WHERE word ~ 'h[a-e](.*)t';  --a-e arası

--İlk karakteri 's', 'a' veya 'y' olan "word" değerlerini çağırın.
SELECT word
FROM words                  
WHERE word ~ '^[say](.*)'; -- ^ işareti ilk karakterim şunlardan biri olsun anlamında, ... ile başla

--Son karakteri 'm', 'a' veya 'f' olan "word" değerlerini çağırın.
SELECT word
FROM words                  
WHERE word ~ '(.*)[maf]$'; --(.*) olmasa da olur. $ işareti bunlardan biriyle bitsin anlamında

--İlk karakteri 's' ve son karakteri 'a' olan "word" değerlerini çağırın.
SELECT word
FROM words                  
WHERE word ~ 's(.*)a'; --Çoklu değilse [], ^ ve $ işaretlerine gerek yok.

--Herhangi bir yerinde 'a' olan "word" değerlerini çağırın.
SELECT word
FROM words                  
WHERE word ~ 'a'; --%a% gibi çalışır.

--İlk karakteri 'd' den 't' ye olan, herhangi bir karakter ile devam edip üçüncü karakteri 'l' olan "word" değerlerini çağırın.
SELECT word
FROM words                  
WHERE word ~ '^[d-t].l'; --aradaki nokta herhangi bir karakter demek

--İlk karakteri 'd' den 't' ye olan,  herhangi iki karakter ile devam edip dördüncü karakteri 'e' olan "word" değerlerini çağırın.
SELECT word
FROM words                  
WHERE word ~ '^[d-t]..e';


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
SELECT * FROM workers

--'E' başlayıp ve 'y' biten "name" değerleri dışındaki "name" değerlerini çağırın.
--1.Yol: NOT LIKE kullanarak--ODEV

--2 Yol: Regex ile
SELECT name 
FROM workers
WHERE name ~ '^[^E](.*[^y]$)'; --Köşeli parantez içinde ^ kullanınca " 'den farklı" amlamı taşır.
--Yani 'E' ile başlamasın 'y' ile bitmesin 

--E ile başlayıp y ile biteni bulalım...
SELECT name 
FROM workers
WHERE name ~ '^[E](.*)[y]$';

--'J', 'B' yada 'E' ile başlayan VE 'r' yada 't' ile biten "name" değerlerini çağırın.
SELECT name 
FROM workers
WHERE name ~ '^[JBE](.*)[rt]$';

--Son karakteri 'r' yada 't' olan YADA ilk karakteri 'J','B', yada 'E' olan "name" değerlerini çağırın.
SELECT name 
FROM workers
WHERE name ~ '^[JBE]' OR name ~ '[rt]$';

--Son karakteri 'r' yada 't' olmayan VE ilk karakteri 'J','B', yada 'E' olmayan "name" değerlerini çağırın.
SELECT name 
FROM workers
WHERE name ~ '^[^JBE](.*)[^rt]$';

--Son karakteri 'r' ya da 't' olmayan VEYA ilk karakteri 'J','B', ya da 'E' olmayan "name" değerlerini çağırın.
SELECT name 
FROM workers
WHERE name ~ '^[^JBE]' OR name ~ '[^rt]$'; --birinden biri olmasın dendiği için condition'dan birini verebilir.

--Herhangi bir yerinde 'a' yada 'k' bulunan "name" değerlerini çağırın.

SELECT name 
FROM workers
WHERE name ~ '[ak]';

--İlk harfi 'A' dan 'F' ye bir karakter olan ve ikinci harfi herhangi bir karakter olup üçüncü harfi 'a' olan "name" değerlerini çağırın.
SELECT name 
FROM workers
WHERE name ~ '^[A-F].a';

--İlk harfi 'A' dan 'F' ye bir karakter olan ve ikinci ve üçüncü harfi herhangi bir karakter olup dördüncü harfi 'i' olan "name" değerlerini çağırın.
SELECT name 
FROM workers
WHERE name ~ '^[A-F]..i';

--Üçüncü karakteri 'o' yada 'x' olan "state" değerlerini çağırın.
SELECT state 
FROM workers
WHERE state ~ '..[o-x]';

--Üçüncü karakteri 'o' yada 'x' olmayan "state" değerlerini çağırın
SELECT state 
FROM workers
WHERE state ~ '^..[^o-x]';

--ODEV
--Sondan üçüncü karakteri 'n' yada 'x' olan  "state" değerlerini çağırın.
--Sondan üçüncü karakteri 'n' yada 'x' olmayan  "state" değerlerini çağırın.


--ORDER BY: recordları artan ya da azalan düzende sıralamak için kullanırız. Default ascending
--ORDER BY sadece SELECT statement ile kullanılır.

--Recordları artan düzende number_of_letters değerine göre sırala.
SELECT *
FROM words
ORDER BY number_of_letters;  --default olarak ascending olduğu için belirtmedik.

--Recordları azalan düzende "word" sütununa göre sıralayın.
SELECT *
FROM words
ORDER BY word DESC; 

--Not: Sütun adları yerine sütun numarası ile de sorting yapabiliriz. 
SELECT *
FROM words
ORDER BY 3 DESC;  -- 3 burada 3. sütun yerine geçer.
