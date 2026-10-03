USE ProductionERP;
GO

DBCC CHECKIDENT ('Master.Material', RESEED, 0);
DBCC CHECKIDENT ('Master.Customer', RESEED, 0);
DBCC CHECKIDENT ('Master.Product', RESEED, 0);
DBCC CHECKIDENT ('Master.Employee', RESEED, 0);
DBCC CHECKIDENT ('Master.Equipment', RESEED, 0);

DBCC CHECKIDENT ('Inventory.CustomerOrder', RESEED, 0);
DBCC CHECKIDENT ('Production.Lot', RESEED, 0);
DBCC CHECKIDENT ('Production.ProcessHistory', RESEED, 0);
DBCC CHECKIDENT ('Production.QualityResult', RESEED, 0);
GO

SELECT IDENT_CURRENT('Master.Material') AS MaterialID;
SELECT IDENT_CURRENT('Master.Customer') AS CustomerID;
SELECT IDENT_CURRENT('Master.Product') AS ProductID;
SELECT IDENT_CURRENT('Inventory.CustomerOrder') AS OrderID;
SELECT IDENT_CURRENT('Production.Lot') AS LotID;