USE [AdventureWorks2014]
GO
/****** Object:  StoredProcedure [dbo].[sp_paginglist]    Script Date: 12/13/2018 11:43:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[sp_paginglist]
(
	@currentPage int,
	@pageSize int,
	@SalesOrderDetailID nvarchar = null,
    @CarrierTrackingNumber nvarchar = null,
	@ProductId nvarchar = null,
	@UnitPrice nvarchar = null,
	@ModifiedDate_to Datetime = null,
	@ModifiedDate_from Datetime = null
)
as
begin 

set nocount off

select * 
from Sales.SalesOrderDetail s
where  (s.SalesOrderDetailID like '+@SalesOrderDetailID+%' or @SalesOrderDetailID is null) 
	and (s.CarrierTrackingNumber like '+@CarrierTrackingNumber+%' or @CarrierTrackingNumber is null) 
	and (s.ProductId like '+@ProductId+%' or @ProductId is null) 
	and (s.UnitPrice like '+@UnitPrice+%' or @UnitPrice is null) 
	and (s.ModifiedDate >= '+@ModifiedDate_to+' or @ModifiedDate_to is null) 
	and (s.ModifiedDate <= '+@ModifiedDate_from+' or @ModifiedDate_from is null) 
order by s.SalesOrderID desc
offset @pageSize * (@currentPage - 1) rows
fetch next @pageSize rows only option (recompile)

end
