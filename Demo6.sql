USE SniffingCoffee;
GO

DBCC FreeProcCache();
GO

DROP PROCEDURE IF EXISTS dbo.ScanningStoredProcedure
GO
CREATE PROCEDURE dbo.ScanningStoredProcedure
 @Country varchar(30)
AS
BEGIN
 SELECT CoffeeName, CoffeePrice, CoffeeDescription 
 FROM SniffingCoffee.dbo.CoffeeInventory
 WHERE CoffeeName LIKE @Country + '%'
OPTION (OPTIMIZE FOR (@Country = 'Costa Rica'))
END;
GO

DROP PROCEDURE IF EXISTS dbo.SeekingStoredProcedure
GO
CREATE PROCEDURE dbo.SeekingStoredProcedure
 @Country varchar(30)
AS
BEGIN
 SELECT CoffeeName, CoffeePrice, CoffeeDescription 
 FROM SniffingCoffee.dbo.CoffeeInventory
 WHERE CoffeeName LIKE @Country + '%'
OPTION (OPTIMIZE FOR (@Country = 'Ethiopia'))
END;
GO

DROP PROCEDURE IF EXISTS dbo.FilterCoffee
GO
CREATE PROCEDURE dbo.FilterCoffee
 @Country varchar(30)
AS
BEGIN
 IF @Country = 'Costa Rica'
 BEGIN
  EXEC dbo.ScanningStoredProcedure @Country;
 END
 ELSE
 BEGIN
  EXEC dbo.SeekingStoredProcedure @Country;
 END
END;
GO

--Include Actual Execution Plan
--Now execute the following code and look at the query plan
EXEC dbo.FilterCoffee @Country = 'Costa Rica';
GO

EXEC dbo.FilterCoffee @Country = 'Ethiopia';
GO