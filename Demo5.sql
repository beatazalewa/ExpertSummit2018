USE SniffingCoffee;
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
 OPTION(OPTIMIZE FOR UNKNOWN)
--OPTION (OPTIMIZE FOR (@Country UNKNOWN))
--OPTION (OPTIMIZE FOR (@Country = 'Ethiopia'))
END;
GO

--Include Actual Execution Plan
--Now execute the following code and look at the query plan
EXEC dbo.FilterCoffee @Country = 'Costa Rica';
GO

EXEC dbo.FilterCoffee @Country = 'Ethiopia';
GO

--Change the order - it does not matter
DBCC FreeProcCache();
GO

--Now execute the following code and look at the query plan
EXEC dbo.FilterCoffee @Country = 'Ethiopia';
GO

EXEC dbo.FilterCoffee @Country = 'Costa Rica';
GO

--Two procedures with similar number of rows
DBCC FreeProcCache();
GO

-- Now execute the following code and look at the query plan
EXEC dbo.FilterCoffee @Country = 'Ethiopia';
GO

EXEC dbo.FilterCoffee @Country = 'Brazil';
GO

--Identify automatically created statistics on CoffeeName column
SELECT S.name AS stats_name
FROM sys.stats AS S
	INNER JOIN sys.stats_columns AS SC
ON S.object_id = SC.object_id
AND S.stats_id = SC.stats_id
INNER JOIN sys.columns AS C
ON SC.object_id = C.object_id
AND SC.column_id = C.column_id
WHERE S.object_id = OBJECT_ID(N'dbo.CoffeeInventory')
AND C.name = N'CoffeeName';
GO

DBCC SHOW_STATISTICS (N'dbo.CoffeeInventory', N'IX_CoffeeName')
WITH HISTOGRAM;
GO

DBCC SHOW_STATISTICS ('dbo.CoffeeInventory', N'IX_CoffeeName');
GO
