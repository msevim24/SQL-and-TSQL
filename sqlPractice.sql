/****** Script for SelectTopNRows command from SSMS  ******/

-- Example 1-------------------------------------------------------------

select sum(Toplam_Order_sayisi) as Genel_Order_Toplami
From
(
SELECT EmployeeID, count(OrderID) as Toplam_Order_sayisi
FROM [NORTHWND].[dbo].[Orders]
group by EmployeeID 
) a


--Example 2--------------------------------------------------------------

SELECT o.EmployeeID, e.FirstName,e.LastName , count(OrderID) as Toplam_Order_sayisi
FROM [NORTHWND].[dbo].[Orders] o
left join [NORTHWND].[dbo].[Employees] e on o.EmployeeID=e.EmployeeID
group by o.EmployeeID,e.FirstName,e.LastName

--Example 3--------------------------------------------------------------

SELECT [OrderID]
     ,[ProductID]
     ,[UnitPrice]
     ,[Quantity]
     ,[Discount]
     ,([UnitPrice]*[Quantity])-([UnitPrice]*[Quantity]*Discount) as TOPLAM
FROM [NORTHWND].[dbo].[Order Details]

  --Example 4--------------------------------------------------------------

Select OrderID,sum(TOPLAM) as TOPLAM_TUTAR
From
 (
 SELECT [OrderID]
        ,[ProductID]
        ,[UnitPrice]
        ,[Quantity]
        ,[Discount]
	    ,([UnitPrice]*[Quantity])-([UnitPrice]*[Quantity]*Discount) as TOPLAM
 FROM [NORTHWND].[dbo].[Order Details]
 ) a
Group by OrderID

  --Example 5--------------------------------------------------------------

SELECT o.[OrderID]
       ,[CustomerID]
       ,[EmployeeID]
       ,[OrderDate]
       ,[RequiredDate]
       ,[ShippedDate]
       ,[ShipVia]
       ,[Freight]
	   ,tutar.TOPLAM_TUTAR+o.Freight as TOTAL
	   ,[ShipName]
       ,[ShipAddress]
       ,[ShipCity]
       ,[ShipRegion]
       ,[ShipPostalCode]
       ,[ShipCountry]
 FROM [NORTHWND].[dbo].[Orders] o
  left join
  ( Select OrderID,sum(TOPLAM) as TOPLAM_TUTAR
  From
  (
  SELECT [OrderID]
        ,[ProductID]
        ,[UnitPrice]
        ,[Quantity]
        ,[Discount]
	    ,([UnitPrice]*[Quantity])-([UnitPrice]*[Quantity]*Discount) as TOPLAM
   FROM [NORTHWND].[dbo].[Order Details]
  ) a
  Group by OrderID ) tutar
  on o.OrderID=tutar.OrderID

  --Example 6--------------------------------------------------------------

  SELECT o.[OrderID]      
      ,[ShipVia]
	  ,tutar.TOPLAM_TUTAR+o.Freight as TOTAL
	  ,[ShipCity]
      ,[ShipAddress]      
  FROM [NORTHWND].[dbo].[Orders] o
  left join
  ( Select OrderID,sum(TOPLAM) as TOPLAM_TUTAR
  From
  (
  SELECT [OrderID]
     	  ,([UnitPrice]*[Quantity])-([UnitPrice]*[Quantity]*Discount) as TOPLAM
  FROM [NORTHWND].[dbo].[Order Details]
  ) a
  Group by OrderID ) tutar
  on o.OrderID=tutar.OrderID
  where ShipCity='London'

   --Example 7--------------------------------------------------------------

    Select count(*) from [NORTHWND].[dbo].[Customers]
	where Region is null


	update [NORTHWND].[dbo].[Customers]
	set Region = 'XX'
	where Region is null

	Select count(*) from [NORTHWND].[dbo].[Customers]
	where Region = 'XX' 


 --Example 8--------------------------------------------------------------

 alter table [NORTHWND].[dbo].[Products] add categorie nvarchar(50);

    update [NORTHWND].[dbo].[Products]
  set categorie=
  case 
  when UnitPrice<10 then 'Bronz'
  when UnitPrice >=10 and UnitPrice<=20 then 'Silver'
  else 'Gold' end 


  --Example 9--------------------------------------------------------------

 CREATE TABLE KARGO (
 CustomerID nvarchar(5) ,
 CompanyName nvarchar(40) ,
 ShipperName nvarchar(40)
)


insert into KARGO
Select c.CustomerID,c.CompanyName , s.CompanyName as KargoName 
from Orders o 
left join Customers  c on o.CustomerID=c.CustomerID
left join Shippers s on o.ShipVia=s.ShipperID

Select * from KARGO

--Example 10 --------------------------------------------------------------

select distinct c.CustomerID,c.CompanyName,c.Address,c.City,c.Region 
INTO GOLD_CUSTOMERS  
from [dbo].[Products] p
left join [dbo].[Order Details] od on p.ProductID=od.ProductID
left join [dbo].[Orders] o on od.OrderID=o.OrderID
Left join [dbo].[Customers] c on o.CustomerID=c.CustomerID
where p.categorie ='GOLD' 

Select * from GOLD_CUSTOMERS 

--Example 11 --------------------------------------------------------------


SELECT o.EmployeeID, count(OrderID) as Toplam_Order_sayisi,
e.FirstName ,
e.LastName,
case when count(OrderID) between 80 and 100 then '*'
when count(OrderID) between 101 and 125 then '**'
else '***' end as derece
FROM [NORTHWND].[dbo].[Orders] o 
left join [dbo].[Employees] e on o.EmployeeID=e.EmployeeID
group by o.EmployeeID ,e.FirstName ,e.LastName
having count(OrderID) >=80

