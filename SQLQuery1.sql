create proc dbo.sp_paginglist
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

set nocount off

select * 
from Sales.SalesOrderDetail s
where  
	(s.SalesOrderDetailID like +@SalesOrderDetailID+'%' or @SalesOrderDetailID is null) 
	and (s.CarrierTrackingNumber like +@CarrierTrackingNumber+'%' or @CarrierTrackingNumber is null) 
	and (s.ProductId like +@ProductId+ '%' or @ProductId is null) 
	and (s.UnitPrice like +@UnitPrice+'%' or @UnitPrice is null) 
	and (Convert(date,s.ModifiedDate) >= Convert(date,@ModifiedDate_to)  or @ModifiedDate_to is null)
	and (Convert(date,s.ModifiedDate)  <=  Convert(date,@ModifiedDate_from) or @ModifiedDate_from is null) 

order by s.SalesOrderID asc

offset @pageSize * (@currentPage - 1) rows

fetch next @pageSize rows only option (recompile)

end

exec dbo.sp_paginglist 1,200,null,null,'7',null,'2011-06-28', null;

--convert date
SELECT CONVERT(datetime, '2017-08-25');



--create temp table
create table #salesOrderIdTempTable (
	salesOrderId varchar(50),
	salelsOrderDetailId nvarchar(100),
)

alter table #salesOrderIdTempTable 
add productId varchar(20)

--insert temptable

--declare params
declare @stringDate as varchar(20) = null
set @stringDate = '2011-06-28'

--end

insert into #salesOrderIdTempTable
select convert(varchar,s.SalesOrderID), convert(varchar,s.SalesOrderDetailID), s.ProductID from Sales.SalesOrderDetail s
where convert(date,s.ModifiedDate) >= convert(date, @stringDate) 


declare @page as int = 1
declare @size as int = 100
select * from #salesOrderIdTempTable a
where a.productId like '7%'
order by a.salesOrderId asc
offset @size*(@page - 1) rows
fetch next @size row only option(recompile)
 
exec dbo.sp_paginglist 1,100,null,null,'7',null,'2011-06-28', null;

select * from #salesOrderIdTempTable

truncate table #salesOrderIdTempTable

delete #salesOrderIdTempTable
