--Tüm kayıtlara bakalım
select * from satislar;
--Kayıtların sayısına bakalım
select count(*) from satislar; --190031 kayıt var

select * from satislar a where a.norderid is null; --satışlara alias olarak a verdik.

--null olan kayıtları saydıralım
select count(*) from satislar a where a.norderid is null; --95015 null kayıt var.

--tutarlılık için null kaytıtları birkaç kolondan kontrol edebiliriz
select count(*) from satislar a where a.country is null and a.processeddate is null; --95015, null sayısı aynı.

--satislar tablosunu yedekleyelim.
create table satislar_backup as select * from satislar; --MSSQL'de çalışmadı bu. 

--Duplicate için önerdiği kod aşağıda...

USE [rug_xe]
GO
/****** Object:  Table [dbo].[satislar] ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[satislar](
	[nOrderId] [float] NULL,
	[Company] [nvarchar](255) NULL,
	[Customer ID] [nvarchar](255) NULL,
	[cPostCode] [nvarchar](255) NULL,
	[dReceievedDate] [nvarchar](255) NULL,
	[Country] [nvarchar](255) NULL,
	[status] [nvarchar](255) NULL,
	[Processed] [float] NULL,
	[ProcessedDate] [nvarchar](255) NULL,
	[Source] [nvarchar](255) NULL,
	[Currency] [nvarchar](255) NULL,
	[Subtotal] [float] NULL,
	[Tax] [float] NULL,
	[Total] [float] NULL,
	[OrderItemSKU] [nvarchar](255) NULL,
	[OrderItemTitle] [nvarchar](255) NULL,
	[ItemCategory] [nvarchar](255) NULL,
	[OrderItemQuantity] [float] NULL,
	[DispatchStockUnitCost] [float] NULL,
	[TotalWeight] [float] NULL,
	[PurchasePrice] [float] NULL,
	[TrackingNumber] [float] NULL,
	[PostalService] [nvarchar](255) NULL
) ON [PRIMARY]
GO
--Duplicate için yukarıdaki çalışmadı. satislar'ı rename yapıp denedim sadece sütun isimlerini verdi

--null olan rowları silelim
delete from satislar where norderid is null and company is null; --95015, null sayısı aynı. (95015 rows affected)

--null değerlerin gidip gitmediğini kontrol etmek için tabloyu kontrol edelim
select * from satislar;

--null kayıtlar gittikten sonra kaç row kaldığını saydıralım: 95016 kayıt
select count(*) from satislar;

/* Bu açıklamalar Oracle için...
drop ederken dikkat. roolback olmaz, geri getiremeyiz
DDL komutlarında commit ve rollback olmaz ancak DML komutlarında olur. */

--****DROP COLUMNS***--
--İlk halinde 23 kolon var. Bazılarını düşüreceğiz.
--drop etmek istediğimiz kolonları önce bir kontrol edelim. Gerçekten kullanışsız mı?

--Virgülle çoklu kayıt da silebiliriz ama tek tek bakıyoruz.
--Önce "status" kolonuna bakalım. Burada kategorileri görebiliriz: PAID, UNPAID, RESEND
select count(1), a.status --sütunun biri count olsun biri statusun kendisi. böylece değerlerini de saydıralım.
from satislar a
group by a.status;

--status kolonunu drop ediyoruz.
alter table satislar drop column status;

--kontrol edelim drop işlemini
select * from satislar;

--Aynı kontrol işlemini drop öncesi "company" için de yapalım
select count(1), a.company from satislar a group by a.company;

--Order by ile henagi şirketten ne kadar olduğuna bakabiliriz.
select count(1), a.company 
from satislar a 
group by a.company
order by count(1) desc;

--En fazla redacted (55736) var, sonra NULL(38250). Kalan 95016 kaydın çoğu bu ikisinden oluşuyor.
--company sütununu da drop edebilriiz.
alter table satislar drop column company;

--"DispatchStockUnitCost" kolonunu da düşürmeden önce kontrol edelim.
select count(1), a.DispatchStockUnitCost 
from satislar a 
group by a.DispatchStockUnitCost
order by count(1) desc;  --"order by 1 desc" yazsaydım da çalışırdı. Yani 1. kolona göre sırala

--Anlamsız göründüğü için bunu da düşüreceğiz.
alter table satislar drop column DispatchStockUnitCost;

--***DATE DEĞİŞİMİ***--

--İki tabloda Date değişimi yapalım
--alter table satislar add ProcessedDate date; --Oracle'da add yerine modify kullanılıyor.
--alter table satislar add dReceievedDate date; --Uyarı: Column names in each table must be unique. Column name 'dReceievedDate' in table 'satislar' is specified more than once.

--ALTER TABLE satislar ALTER COLUMN dReceievedDate date; --Alternatif kod ama aşğıdaki hatayı verdi 
--Conversion failed when converting date and/or time from character string.
--Osman hoca truncate etmeden data type değişikliğinin olmayacağını söyledi. Belki de ondandır.


/* gün/ay/yıl şeklindeki tarihler için şöyle bir dönüşüm var. Tersi durumunda as UK_Date_Time_Style yazılıyor sona.
Declare @dReceievedDate nvarchar(255)
select CONVERT(datetime2, @dReceievedDate, 103) as Date_Time_Style;
*/

--Oracle'da yazılan kod: select to_date(a.dReceievedDate, 'dd.mm.rrrrr hh24:mi:ss'), a.* from satislar a;
--Ancak MSSQL to_date'i tanımıyor.