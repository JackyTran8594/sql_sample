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
	@pageSize int
	--@parameter nvarchar
)
as
begin 

set nocount off
	
	

select * 
from Sales.SalesOrderDetail s
order by s.SalesOrderID
offset @pageSize * (@currentPage - 1) rows
fetch next @pageSize rows only option (recompile)


end
