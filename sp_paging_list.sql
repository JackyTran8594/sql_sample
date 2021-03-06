/******Using offset&fetch ******/
USE [AdventureWorks2014]
GO
/****** Object:  StoredProcedure [dbo].[sp_paging_offset&fetch]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_paging_offset&fetch]
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
go

exec dbo.[sp_paging_offset&fetch] 2,100,null,null,'7',null,'2011-06-28',null
go

/******end******/



/******Using CTE - Common table expression******/

USE [AdventureWorks2014]
GO
/****** Object:  StoredProcedure [dbo].[sp_paging_CTE]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_paging_CTE] 
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
	declare @colums varchar

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

exec dbo.sp_paging_CTE 2,100,null,null,'7',null,'2011-06-28',null
go
/******end******/