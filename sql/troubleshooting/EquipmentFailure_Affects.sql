SELECT * FROM Inventory.CustomerOrder
SELECT * FROM Production.Lot WHERE OrderID = 2
SELECT top 5 * FROM Production.ProcessHistory where LotID = 1002

select * from Master.Equipment
select * from Maintenance.EquipmentAlarm

SELECT 
	*
FROM Production.ProcessHistory 
WHERE 
	ProcessStatus = 'Failed' 
	AND EquipmentID = 1
	AND StartTime >= '2026-09-20'