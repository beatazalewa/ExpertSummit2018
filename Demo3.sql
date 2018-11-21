USE SniffingCoffee;
GO

DBCC FreeProcCache();
GO

DROP PROCEDURE IF EXISTS dbo.FilterCoffee;
GO
CREATE PROCEDURE dbo.FilterCoffee
 @Country varchar(30)
 WITH RECOMPILE
AS
BEGIN
 SELECT CoffeeName, CoffeePrice, CoffeeDescription 
 FROM SniffingCoffee.dbo.CoffeeInventory
 WHERE CoffeeName LIKE @Country + '%'
END;
GO

--Include Actual Execution Plan
EXEC dbo.FilterCoffee @Country = 'Costa Rica';
GO
EXEC dbo.FilterCoffee @Country = 'Ethiopia';
GO
