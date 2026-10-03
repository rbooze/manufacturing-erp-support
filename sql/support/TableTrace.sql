USE ProductionERP;
GO

-- Customer places order
SELECT 
	co.OrderID,
	co.OrderNumber,
	c.CustomerName,
	co.QuantityOrdered,
	co.OrderStatus,
	co.OrderDate
FROM Inventory.CustomerOrder co WITH (NOLOCK)
INNER JOIN Master.Customer c WITH (NOLOCK)
	ON co.CustomerID = c.CustomerID;

-- ==================================================

-- Lot information
SELECT 
	l.LotID,				--1001
	l.LotNumber,
	p.ProductName,
	c.CustomerName,
	l.QuantityStarted,
	l.QuantityCompleted,
	l.LotStatus,
	l.CreatedDate
FROM Production.Lot l WITH (NOLOCK) 
INNER JOIN Master.Product p WITH (NOLOCK)
	ON l.ProductID = p.ProductID
INNER JOIN Master.Customer c WITH (NOLOCK)
	ON l.CustomerID = c.CustomerID
WHERE 
	l.LotNumber = 'LOT-20260909-0020'
	--OrderID = 2;

-- ==================================================

-- Use a GROUP BY here because Production.ProcessHistory has duplicate data
-- Process History
SELECT 
	MIN(ph.HistoryID) AS HistoryID,
	l.LotNumber,
	ps.StepNumber,
	ps.StepName,
	e.EquipmentName,
	ph.StartTime,
	ph.EndTime,
	ph.ProcessStatus,
	ph.Notes
FROM Production.ProcessHistory ph WITH (NOLOCK)
INNER JOIN Production.Lot l WITH (NOLOCK)
	ON ph.LotID = l.LotID
INNER JOIN Production.ProcessStep ps WITH (NOLOCK)
	ON ph.ProcessStepID = ps.ProcessStepID
LEFT JOIN Master.Equipment e WITH (NOLOCK)
	ON ph.EquipmentID = e.EquipmentID
WHERE
	l.LotID = 25
GROUP BY
    l.LotNumber,
    ps.StepNumber,
    ps.StepName,
    e.EquipmentName,
    ph.StartTime,
    ph.EndTime,
    ph.ProcessStatus,
    ph.Notes
ORDER BY
    ps.StepNumber ASC;

SELECT
	*
FROM Maintenance.EquipmentEvent

SELECT
	*
FROM Maintenance.EquipmentAlarm

-- ==================================================

-- Quality Result - Did the lot pass/why did it fail (DUPLICATE DATA)
SELECT
	qr.QualityID,
	qr.LotID,
	l.LotNumber,
	qr.TestType,
	qr.Result,
	qr.TestedDate
FROM Production.QualityResult qr WITH (NOLOCK)
INNER JOIN Production.Lot l WITH (NOLOCK)
	ON qr.LotID = l.LotID
WHERE
	qr.LotID = 25
	--AND qr.QualityID = 1008

-- ==================================================

-- 
