create proc dbo.sp_paginglist
(
	@currentPage int,
	@pageSize int,
	@parameter nvarchar
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


exec dbo.sp_paginglist 1,10000;



