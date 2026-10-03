USE ProductionERP;
GO

-- Disable constraints
EXEC sp_MSforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL';
GO

DELETE FROM Production.ProcessHistory;
DELETE FROM Production.QualityResult;
DELETE FROM Production.EpiwaferRun;

DELETE FROM Inventory.InventoryTransaction;
DELETE FROM Inventory.ERPIntegrationQueue;

DELETE FROM Production.ProcessRouteStep;
DELETE FROM Production.ProcessRoute;

DELETE FROM Production.ProductRecipe;
DELETE FROM Production.RecipeParameter;

DELETE FROM Production.Lot;

DELETE FROM Inventory.CustomerOrder;

DELETE FROM Inventory.Stock;

DELETE FROM Master.Product;
DELETE FROM Master.Material;
DELETE FROM Master.Customer;
DELETE FROM Master.Employee;
DELETE FROM Master.Equipment;

DELETE FROM Inventory.Warehouse;

DELETE FROM Production.ProcessStep

DELETE FROM Support.RootCauseAnalysis;
DELETE FROM Support.SupportTicket;
DELETE FROM Support.Incident;
DELETE FROM Support.UserSession

DELETE FROM Maintenance.EquipmentAlarm;
DELETE FROM Maintenance.EquipmentEvent;
DELETE FROM Maintenance.WorkOrder;

DELETE FROM Support.RootCauseAnalysis;
DELETE FROM Support.SupportTicket;
DELETE FROM Support.Incident;
DELETE FROM Support.UserSession;
GO

--- Re-enable constraints
EXEC sp_MSforeachtable 'ALTER TABLE ? WITH CHECK CHECK CONSTRAINT ALL';
GO

SELECT 'Customer' AS TableName, COUNT(*) AS Rows FROM Master.Customer
UNION ALL
SELECT 'Product', COUNT(*) FROM Master.Product
UNION ALL
SELECT 'Employee', COUNT(*) FROM Master.Employee
UNION ALL
SELECT 'Equipment', COUNT(*) FROM Master.Equipment
UNION ALL
SELECT 'Lot', COUNT(*) FROM Production.Lot
UNION ALL
SELECT 'Orders', COUNT(*) FROM Inventory.CustomerOrder;