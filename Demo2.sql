USE SniffingCoffee;
GO

DBCC FreeProcCache();
GO

--Include Actual Execution Plan
--Returns 10003 rows
SELECT CoffeeName, CoffeePrice, CoffeeDescription 
FROM dbo.CoffeeInventory
WHERE CoffeeName LIKE 'Costa Rica%';
GO

--Returns 6 rows
SELECT CoffeeName, CoffeePrice, CoffeeDescription 
FROM dbo.CoffeeInventory
WHERE CoffeeName LIKE 'Ethiopia%';
GO

DBCC FreeProcCache();
GO

DROP PROCEDURE IF EXISTS dbo.FilterCoffee;
GO
CREATE PROCEDURE dbo.FilterCoffee
 @Country varchar(30)
AS
BEGIN
 SELECT CoffeeName, CoffeePrice, CoffeeDescription 
 FROM SniffingCoffee.dbo.CoffeeInventory
 WHERE CoffeeName LIKE @Country + '%'
END;
GO

EXEC dbo.FilterCoffee @Country = 'Costa Rica';
GO

EXEC dbo.FilterCoffee @Country = 'Ethiopia';
GO

-- We have two query executions, they are using the same plan, and neither plan is using our nonclustered index on CoffeeName column

-- We must clear the query plan cache for this stored procedure,because SQL Server can use the same query plan:
EXEC dbo.FilterCoffee @Country = 'Ethiopia';
GO

EXEC dbo.FilterCoffee @Country = 'Costa Rica'
GO

-- Clear the query plan cache
SELECT cp.plan_handle, st.[text]
FROM sys.dm_exec_cached_plans AS cp 
CROSS APPLY sys.dm_exec_sql_text(plan_handle) AS st
WHERE [text] LIKE N'CREATE%FilterCoffee%';
GO
-- Never run DBCC FREEPROCCACHE without a parameter in production unless you want to lose all of your cached plans...
DBCC FreeProcCache (0x0500090045AEDB47304A23D79602000001000000000000000000000000000000000000000000000000000000);
GO

-- Check if the plan for the stored procedures disappear
SELECT cp.plan_handle, st.[text]
FROM sys.dm_exec_cached_plans AS cp 
CROSS APPLY sys.dm_exec_sql_text(plan_handle) AS st
WHERE [text] LIKE N'CREATE%FilterCoffee%';
GO

-- Execute the same stored procedure with the same parameter values, but this time with the 'Ethiopia' parameter value first. Look at the execution plan
EXEC dbo.FilterCoffee @Country = 'Ethiopia';
GO

EXEC dbo.FilterCoffee @Country = 'Costa Rica';
GO

-- Now our nonclustered index on CoffeeName column is being utilized. Both queries are still receiving the same plan.

-- We didn't change anything with our stored procedure code, only the order that we executed the query with different parameters.
-- The first time a stored procedure (or query) is ran on SQL server, SQL will generate an execution plan for it and store that plan in the query plan cache
SELECT
 c.usecounts,
 c.cacheobjtype,
 c.objtype,
 c.plan_handle,
 c.size_in_bytes,
 d.name,
 t.text,
 p.query_plan
FROM 
 sys.dm_exec_cached_plans c
 CROSS APPLY sys.dm_exec_sql_text(c.plan_handle) t
 CROSS APPLY sys.dm_exec_query_plan(c.plan_handle) p
 INNER JOIN sys.databases d
 ON t.dbid = d.database_id
WHERE text LIKE 'CREATE%CoffeeInventory%';
GO

-- A query with different values passed as parameters still counts as the "same query" in the eyes of SQL Server
SELECT 
  LEFT(CoffeeName,CHARINDEX(' ',CoffeeName)) AS Country, 
  COUNT(*) AS CountryCount 
FROM dbo.CoffeeInventory 
GROUP BY LEFT(CoffeeName,CHARINDEX(' ',CoffeeName));
GO

-- "Costa Rica" has more than 10,000 rows in this table, while all other country names are in the single digits.

--This means that when we executed our stored procedure for the first time, SQL Server generated an execution plan that used a table scan because it thought this would be the most efficient way to retrieve 10,003 of the 10,052 rows.