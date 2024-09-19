use orderDB_aug


select * from Supplier
select * from Customer
select * from [OrderNew]
select * from [Order]
select * from Product
select * from OrderItem



SELECT 
    id, 
    DATEADD(YEAR, 10, Orderdate) AS orderdate,
    ordernumber,
    customerid,
    totalamount
INTO Ordernew
FROM [order];


select * from ordernew

select C.*, O.*, OI.*, P.*, S.* from [Order] As O
left join  Customer  As C On O.CustomerId=C.Id
left join  OrderItem As OI On OI.OrderId=O.Id
left Join  Product AS P On OI.ProductId=P.Id
Left Join  Supplier AS S On S.Id=P.SupplierId







select C.*, O.*, OI.*, P.*, S.*, E.CLV_SCORE from [Order] As O
left join  Customer  As C On O.CustomerId=C.Id
left join  OrderItem As OI On OI.OrderId=O.Id
left Join  Product AS P On OI.ProductId=P.Id
Left Join  Supplier AS S On S.Id=P.SupplierId
left join (
select Customer_ID, (0.15*Recency+0.5*Frequency+0.35*Monitory) as CLV_SCORE from (

select C.Customer_ID, 
       Cast((C.Frequency-C.Min_Frequency)/(Max_Frequency-Min_Frequency) as decimal(10,3)) as Frequency,
	    Cast((C.Monitory-C.Min_Monitory)/(Max_Monitory-Min_Monitory) as decimal(10,3)) as Monitory,
		Cast((C.Recency-C.Min_Recency)/(Max_Recency-Min_Recency) as decimal(10,3)) as Recency
	from (
select Id as Customer_ID,
       Cast(Monitory as decimal(10,2)) as Monitory,
	   Cast(Frequency as decimal(10,2)) as Frequency,
	   Cast(Recency as decimal(10,2)) as Recency,
	   Cast(Min_Monitory as decimal(10,2)) as Min_Monitory,
	   Cast(Max_Monitory as decimal(10,2)) as Max_Monitory,
       Cast(Min_Frequency as decimal(10,2)) as Min_Frequency,
       Cast(Max_Frequency as decimal(10,2)) as Max_Frequency,
       Cast(Min_Recency as decimal(10,2)) as Min_Recency,
       Cast(Max_Recency as decimal(10,2)) as Max_Recency
from (
select C.id, Sum(oi.unitPrice*oi.Quantity) as Monitory,
             Count(distinct OrderDate) as Frequency,
			 Datediff(Month, Max(OrderDate),getdate()) as Recency
		from [OrderNew] as O
		left join Customer as C on O.CustomerId=C.Id
		left join OrderItem as OI on OI.OrderId=O.Id
Group by C.ID
)A
Cross Join
(select min(Monitory) as Min_Monitory,
       max(Monitory) as Max_Monitory,
	   Min(Frequency) as Min_Frequency,
	   Max(Frequency) as Max_Frequency,
	   Min(Recency) as Min_Recency,
	   Max(Recency) as Max_Recency
	   from (

select C.id, Sum(oi.unitPrice*oi.Quantity) as Monitory,
             Count(distinct OrderDate) as Frequency,
			 Datediff(Month, Max(OrderDate),getdate()) as Recency
		from [OrderNew] as O
		left join Customer as C on O.CustomerId=C.Id
		left join OrderItem as OI on OI.OrderId=O.Id
Group by C.ID
)A
)B
)C
)D
)E
On C.Id=E.Customer_ID


select * from [order];


