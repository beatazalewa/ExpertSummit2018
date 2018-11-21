USE SniffingCoffee;
GO

DBCC FreeProcCache();
GO

SELECT CoffeeName, CoffeePrice, CoffeeDescription 
/* A2E6C9ED-E75A-42F7-BD22-EB671798B0DC */
FROM dbo.CoffeeInventory
WHERE CoffeeName LIKE 'Costa Rica%';
GO

SELECT CoffeeName, CoffeePrice, CoffeeDescription 
/* A2E6C9ED-E75A-42F7-BD22-EB671798B0DC */
FROM dbo.CoffeeInventory
WHERE CoffeeName LIKE 'Ethiopia%';
GO

SELECT CoffeeName, CoffeePrice, CoffeeDescription 
/* A2E6C9ED-E75A-42F7-BD22-EB671798B0DC */
FROM dbo.CoffeeInventory
WHERE CoffeeName LIKE 'Brazil%';
GO

/* check "cached objects" */
SELECT cacheobjtype, objtype, usecounts, sql
FROM sys.syscacheobjects
WHERE sql LIKE N'%A2E6C9ED-E75A-42F7-BD22-EB671798B0DC%'
  AND sql NOT LIKE N'%sys%';
GO


