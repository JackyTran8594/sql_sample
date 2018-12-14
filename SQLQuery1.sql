create proc dbo.sp_paginglist
(
	@currentPage int,
	@pageSize int,
	@SalesOrderDetailID nvarchar = null,
    @CarrierTrackingNumber nvarchar = null,
	@ProductId nvarchar = null,
	@UnitPrice nvarchar = null,
	@ModifiedDate_to varchar = null,
	@ModifiedDate_from varchar = null
)
as
begin 

set nocount off

declare @toDate as varchar(30), @fromDate as varchar(30)


select * 
from Sales.SalesOrderDetail s
where  
	(s.SalesOrderDetailID like +@SalesOrderDetailID+'%' or @SalesOrderDetailID is null) 
	and (s.CarrierTrackingNumber like +@CarrierTrackingNumber+'%' or @CarrierTrackingNumber is null) 
	and (s.ProductId like +@ProductId+ '%' or @ProductId is null) 
	and (s.UnitPrice like +@UnitPrice+'%' or @UnitPrice is null) 
	and (s.ModifiedDate >= Convert(datetime,@ModifiedDate_to)  or @ModifiedDate_to is null)
	and (s.ModifiedDate  <=  Convert(datetime,@ModifiedDate_from) or @ModifiedDate_from is null) 

order by s.SalesOrderID asc

offset @pageSize * (@currentPage - 1) rows

fetch next @pageSize rows only option (recompile)

end



exec dbo.sp_paginglist 1,200,null,null,'7',null,'2014-06-28', '2014-06-30';


select CONVERT(datetime, '28-06-2014',101 );

SELECT CONVERT(datetime, '2017-08-25');



