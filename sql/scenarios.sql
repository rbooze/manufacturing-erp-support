/*
Troubleshooting Scenario 1
Completed Production Lot Missing From ERP Inventory

Production reports: "Lot completed in MES, but inventory is not available in ERP."

Production.Lot
       |
       v
ERPIntegrationQueue
       |
       v
InventoryTransaction
       |
       v
Inventory.Stock
*/

-- Verify MES Completion
SELECT 
    *
FROM Production.Lot
WHERE 
	LotNumber = 'LOT-GAAS-20260901';

-- Check Integration Queue
SELECT
	*
FROM Inventory.ERPIntegrationQueue
WHERE
	ReferenceID = 'LOT-GAAS-20260901';

-- Check ERP Transaction
SELECT
	*
FROM Inventory.InventoryTransaction
WHERE
	LotID = 1;

/*
Troubleshooting Scenario 2
Production Yield Dropped
Quality reports: "Recent lots are failing inspection."

QualityResult
       |
       v
ProcessHistory
       |
       v
Equipment
       |
       v
EquipmentAlarm
       |
       v
Maintenance
*/

-- Identify Failed Lots
SELECT 
	*
FROM Production.QualityResult WITH (NOLOCK)
WHERE 
	Result = 'FAIL';

-- Find Equipment Used
SELECT 
	l.LotID,
	ph.EquipmentID,
	ph.StartTime,
	ph.EndTime
FROM Production.Lot l WITH (NOLOCK)
INNER JOIN Production.ProcessHistory ph WITH (NOLOCK)
	ON l.LotID = ph.LotID
WHERE
	l.LotID = 3;

-- Check Equipment History
SELECT
	*
FROM Maintenance.EquipmentAlarm WITH (NOLOCK)
WHERE
	EquipmentID = 1;

/*
Troubleshooting Scenario 3
Nightly Interface Job Failed
Operations reports: "The overnight ERP synchronization did not complete."

BatchJobExecution
        |
        v
ApplicationLog
        |
        v
ERPIntegrationQueue
*/

-- Check Job Status
SELECT
	bje.ExecutionID,
	bj.BatchJobID,
	bj.JobName,
	bje.Status,
	bje.StartTime,
	bje.EndTime,
	bje.ErrorMessage
FROM Support.BatchJobExecution bje WITH (NOLOCK)
INNER JOIN Support.BatchJob bj WITH (NOLOCK)
	ON bje.BatchJobID = bj.BatchJobID
WHERE
	bje.Status = 'FAILED'
ORDER BY
	bj.BatchJobID,
	bje.StartTime;

-- Review Logs
SELECT
	*
FROM Support.ApplicationLog WITH (NOLOCK)
WHERE
	LogLevel = 'ERROR'
ORDER BY
	LogTime DESC;

/*
Troubleshooting Scenario 4
User Cannot Access Application

UserSession
      |
      v
ApplicationLog
      |
      v
Incident History
*/

SELECT
	*
FROM Support.UserSession WITH (NOLOCK);