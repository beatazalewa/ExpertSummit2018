USE SniffingCoffee;
GO

DBCC FreeProcCache();
GO

DROP PROCEDURE IF EXISTS dbo.FilterCoffee;
GO
CREATE PROCEDURE dbo.FilterCoffee
 @ParmCountry varchar(30)
AS
BEGIN
 SELECT CoffeeName, CoffeePrice, CoffeeDescription 
 FROM SniffingCoffee.dbo.CoffeeInventory
 WHERE CoffeeName LIKE @ParmCountry + '%'
END;
GO

--Now execute the following code and look at the query plan

--Include Actual Execution Plan
EXEC dbo.FilterCoffee @ParmCountry = 'Costa Rica' WITH RECOMPILE;
GO

EXEC dbo.FilterCoffee @ParmCountry = 'Ethiopia' WITH RECOMPILE;
GO

--Or add to the stored procedure definition
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
 OPTION(RECOMPILE)
END;
GO

--Now execute the following code and look at the query plan
EXEC dbo.FilterCoffee @Country = 'Costa Rica';
GO

EXEC dbo.FilterCoffee @Country = 'Ethiopia';
GO
