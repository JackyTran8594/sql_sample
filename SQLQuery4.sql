

declare @currentPage as int, @pageSize as int
declare @stringParams as nvarchar
set @currentPage = 1
set @pageSize = 50	
declare @SalesOrderDetailID nvarchar = null
declare @CarrierTrackingNumber nvarchar = null
declare @ProductId nvarchar = null
declare @UnitPrice nvarchar = null
declare @ModifiedDate_to Datetime = null
declare @ModifiedDate_from Datetime = null 

--declare @sql nvarchar(max)

--set @sql = '1=1';

--if @SalesOrderDetailID is not null
--	set @sql = @sql + ' and s.SalesOrderDetailID like '@SalesOrderDetailID%''

--if @CarrierTrackingNumber is not null
--	set @sql = @sql + ' and s.CarrierTrackingNumber like '@CarrierTrackingNumber%''

--if @ProductId is not null
--	set @sql = @sql + ' and s.ProductId like '@ProductId%''

--if @UnitPrice is not null
--	set @sql = @sql + ' and s.UnitPrice like '@UnitPrice%''

--if @ModifiedDate_to is not null
--	set @sql = @sql + ' and s.ModifiedDate_to >= @ModifiedDate_to'

--if @ModifiedDate_from is not null
--	set @sql = @sql + ' and s.ModifiedDate_from <= @ModifiedDate_from'

select * 
from Sales.SalesOrderDetail s
where  (s.SalesOrderDetailID like '@SalesOrderDetailID%' or @SalesOrderDetailID is null) 
	and (s.CarrierTrackingNumber like '@CarrierTrackingNumber%' or @CarrierTrackingNumber is null) 
	and (s.ProductId like '@ProductId%' or @ProductId is null) 
	and (s.UnitPrice like '@UnitPrice%' or @UnitPrice is null) 
	and (s.ModifiedDate >= '@ModifiedDate_to' or @ModifiedDate_to is null) 
	and (s.ModifiedDate <= '@ModifiedDate_from' or @ModifiedDate_from is null) 
order by s.SalesOrderID desc
offset @pageSize * (@currentPage - 1) rows
fetch next @pageSize rows only option (recompile)



select * from Sales.SalesOrderDetail

	
select * from Sales.SalesOrderDetail s
where s.ProductID like '%76'


use AdventureWorks2014;

declare @paramArray as nvarchar = '43659, 4911-403C-98,776';




DECLARE @ID NVARCHAR(300)= '1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20';
DECLARE @Marks NVARCHAR(300)= '0,1,2,5,8,9,4,6,7,3,5,2,7,1,9,4,0,2,5,0';
DECLARE @StudentsMark TABLE
(id    NVARCHAR(300),
 marks NVARCHAR(300)
); 
--insert into @StudentsMark 
;WITH CTE
     AS (
     SELECT Split.a.value('.', 'NVARCHAR(MAX)') id,
            ROW_NUMBER() OVER(ORDER BY
                             (
                                 SELECT NULL
                             )) RN
     FROM
     (
         SELECT CAST('<X>'+REPLACE(@ID, ',', '</X><X>')+'</X>' AS XML) AS String
     ) AS A
     CROSS APPLY String.nodes('/X') AS Split(a)),
     CTE1
     AS (
     SELECT Split.a.value('.', 'NVARCHAR(MAX)') marks,
            ROW_NUMBER() OVER(ORDER BY
                             (
                                 SELECT NULL
                             )) RN
     FROM
     (
         SELECT CAST('<X>'+REPLACE(@Marks, ',', '</X><X>')+'</X>' AS XML) AS String
     ) AS A
     CROSS APPLY String.nodes('/X') AS Split(a))
     INSERT INTO @StudentsMark
            SELECT C.id,
                   C1.marks
            FROM CTE C
                 LEFT JOIN CTE1 C1 ON C1.RN = C.RN;
SELECT *
FROM @StudentsMark;

use AdventureWorks2014

--ALTER DATABASE AdventureWorks2014 SET COMPATIBILITY_LEVEL = 120

--SELECT Value FROM STRING_SPLIT('Lorem ipsum dolor sit amet.', ' ');


DECLARE @IDs VARCHAR(500);
DECLARE @Number VARCHAR(500);
DECLARE @charSpliter CHAR;

SET @charSpliter = ','
SET @IDs = '1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20' + @charSpliter;

WHILE CHARINDEX(@charSpliter, @IDs) > 0
BEGIN
    SET @Number = SUBSTRING(@IDs, 0, CHARINDEX(@charSpliter, @IDs))
    SET @IDs = SUBSTRING(@IDs, CHARINDEX(@charSpliter, @IDs) + 1, LEN(@IDs))

    PRINT @Number

END



declare @page as int = 1
declare @size as int = 100
declare @start as int = (@page - 1)*@size + 1
declare @lastInSize as int = @page*@size
declare @totalRecord as int = null

;with SalesOrderDetail_CTE as
(
	select * ,
	row_number() over (order by SalesOrderID asc) as 'rowNumber'
	from Sales.SalesOrderDetail
)

select *
from SalesOrderDetail_CTE
where rowNumber >= @start and rowNumber <= @lastInSize
for xml raw('SalesOrderDetail')

exec dbo.sp_paginglist 1,100,null,null,null,null,null, null;

alter proc sp_paging_CTE 
(
	@currentPage int,
	@pageSize int,
	@SalesOrderDetailID nvarchar = null,
    @CarrierTrackingNumber nvarchar = null,
	@ProductId nvarchar(20) = null,
	@UnitPrice nvarchar(20) = null,
	@ModifiedDate_to varchar(20) = null,
	@ModifiedDate_from varchar(20) = null
)
as
begin

	declare @start as int = (@currentPage - 1)*@pageSize + 1
	declare @lastInSize as int = @currentPage*@pageSize

	
;with SalesOrderDetail_CTE as
(
	select * ,
	row_number() over (order by SalesOrderID asc) as 'rowNumber'
	from Sales.SalesOrderDetail s
	where  
	(s.SalesOrderDetailID like +@SalesOrderDetailID+'%' or @SalesOrderDetailID is null) 
	and (s.CarrierTrackingNumber like +@CarrierTrackingNumber+'%' or @CarrierTrackingNumber is null) 
	and (s.ProductId like +@ProductId+ '%' or @ProductId is null) 
	and (s.UnitPrice like +@UnitPrice+'%' or @UnitPrice is null) 
	and (Convert(date,s.ModifiedDate) >= Convert(date,@ModifiedDate_to)  or @ModifiedDate_to is null)
	and (Convert(date,s.ModifiedDate)  <=  Convert(date,@ModifiedDate_from) or @ModifiedDate_from is null) 
	
)

select *
from SalesOrderDetail_CTE s
where rowNumber >= @start and rowNumber <= @lastInSize
order by s.SalesOrderID asc

end
go

exec dbo.sp_paging_CTE 2,100





