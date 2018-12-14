

declare @currentPage as int, @pageSize as int
declare @stringParams as nvarchar
set @currentPage = 1
set @pageSize = 50	


select * 
from Sales.SalesOrderDetail s
where  s.ProductID like '76%' and s.CarrierTrackingNumber like 'FB%'
order by s.SalesOrderID
offset @pageSize * (@currentPage - 1) rows
fetch next @pageSize rows only option (recompile)



	
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







