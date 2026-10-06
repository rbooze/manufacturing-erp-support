USE ProductionERP;
GO

DECLARE @OrderNumber VARCHAR(30) = 'PO-20261001-003';		-- Failed
--DECLARE @OrderNumber VARCHAR(30) = 'PO-20261001-001';		-- Completed

-- Customer Order information
;WITH OrderContext AS
(
    SELECT
        co.OrderID,
        co.OrderNumber,
        co.QuantityOrdered,
        co.OrderStatus,
        co.OrderDate,
        c.CustomerName,
        p.ProductName AS OrderedProductName
    FROM Inventory.CustomerOrder AS co WITH (NOLOCK)
    INNER JOIN Master.Customer AS c WITH (NOLOCK)
        ON c.CustomerID = co.CustomerID
    INNER JOIN Master.Product AS p WITH (NOLOCK)
        ON p.ProductID = co.ProductID
    WHERE 
		co.OrderNumber = @OrderNumber
),

-- Lot information
OrderLots AS
(
    SELECT
        l.OrderID,
        l.LotID,
        l.LotNumber,
        l.ProductID,
        p.ProductName,
        l.QuantityStarted,
        l.QuantityCompleted,
        l.LotStatus,
        l.CreatedDate
    FROM Production.Lot AS l WITH (NOLOCK)
    INNER JOIN OrderContext AS o WITH (NOLOCK)
        ON o.OrderID = l.OrderID
    INNER JOIN Master.Product AS p WITH (NOLOCK)
        ON p.ProductID = l.ProductID
),

-- Trace events through production
TraceEvents AS
(
    SELECT
        o.OrderID,
        CAST(NULL AS INT) AS LotID,
        CAST(NULL AS INT) AS TraceEventID,
        o.OrderDate AS EventTime,
        'Customer Order' AS EventType,
        o.OrderStatus AS EventStatus,
        CONCAT('Product: ', o.OrderedProductName, '; quantity ordered: ', o.QuantityOrdered) AS EventDetails
    FROM OrderContext AS o

    UNION ALL

    SELECT
        l.OrderID,
        l.LotID,
        l.LotID,
        l.CreatedDate,
        'Production Lot',
        l.LotStatus,
        CONCAT('Lot: ', l.LotNumber, '; product: ', l.ProductName,
            '; started: ', l.QuantityStarted, '; completed: ', COALESCE(CONVERT(VARCHAR(20), l.QuantityCompleted), 'unknown'))
    FROM OrderLots AS l

    UNION ALL

    SELECT
        l.OrderID,
        l.LotID,
        ph.HistoryID,
        ph.StartTime,
        'Process Step',
        ph.ProcessStatus,
        CONCAT('Step ', ps.StepNumber, ': ', ps.StepName,
            '; equipment: ', COALESCE(e.EquipmentName, 'not assigned'),
            '; ended: ', COALESCE(CONVERT(VARCHAR(19), ph.EndTime, 120), 'in progress'),
            '; notes: ', COALESCE(ph.Notes, ''))
    FROM OrderLots AS l
    INNER JOIN Production.ProcessHistory AS ph WITH (NOLOCK)
        ON ph.LotID = l.LotID
    INNER JOIN Production.ProcessStep AS ps WITH (NOLOCK)
        ON ps.ProcessStepID = ph.ProcessStepID
    LEFT JOIN Master.Equipment AS e WITH (NOLOCK)
        ON e.EquipmentID = ph.EquipmentID

    UNION ALL

    SELECT
        l.OrderID,
        l.LotID,
        er.RunID,
        er.StartTime,
        'Epitaxy Run',
        er.RunStatus,
        CONCAT('Recipe: ', er.RecipeName,
            '; equipment: ', COALESCE(e.EquipmentName, 'unknown'),
            '; ended: ', COALESCE(CONVERT(VARCHAR(19), er.EndTime, 120), 'in progress'))
    FROM OrderLots AS l
    INNER JOIN Production.EpiwaferRun AS er WITH (NOLOCK)
        ON er.LotID = l.LotID
    LEFT JOIN Master.Equipment AS e WITH (NOLOCK)
        ON e.EquipmentID = er.EquipmentID

    UNION ALL

    SELECT
        l.OrderID,
        l.LotID,
        qr.QualityID,
        qr.TestedDate,
        'Quality Test',
        qr.Result,
        CONCAT('Test: ', qr.TestType,
            '; measured: ', COALESCE(CONVERT(VARCHAR(40), qr.MeasurementValue), 'not recorded'),
            '; specification: ', COALESCE(CONVERT(VARCHAR(40), qr.SpecificationMin), 'n/a'),
            ' to ', COALESCE(CONVERT(VARCHAR(40), qr.SpecificationMax), 'n/a'))
    FROM OrderLots AS l
    INNER JOIN Production.QualityResult AS qr WITH (NOLOCK)
        ON qr.LotID = l.LotID

    UNION ALL

    SELECT
        l.OrderID,
        l.LotID,
        it.TransactionID,
        it.TransactionDate,
        'Inventory Transaction',
        it.TransactionStatus,
        CONCAT(it.TransactionType, '; quantity: ', it.Quantity,
            '; source: ', it.SourceSystem,
            '; warehouse: ', COALESCE(w.WarehouseName, 'unknown'))
    FROM OrderLots AS l
    INNER JOIN Inventory.InventoryTransaction AS it WITH (NOLOCK)
        ON it.LotID = l.LotID
    LEFT JOIN Inventory.Warehouse AS w WITH (NOLOCK)
        ON w.WarehouseID = it.WarehouseID

    UNION ALL

    SELECT
        l.OrderID,
        l.LotID,
        iq.QueueID,
        iq.CreatedDate,
        'ERP Integration',
        iq.ProcessingStatus,
        CONCAT(iq.MessageType, '; ', iq.SourceSystem, ' to ', iq.TargetSystem,
            '; reference: ', iq.ReferenceID,
            '; error: ', COALESCE(iq.ErrorMessage, 'none'),
            '; processed: ', COALESCE(CONVERT(VARCHAR(19), iq.ProcessedDate, 120), 'not yet'))
    FROM OrderLots AS l
    INNER JOIN Inventory.ERPIntegrationQueue AS iq WITH (NOLOCK)
        ON iq.ReferenceID = l.LotNumber
)
SELECT
    o.OrderID,
    o.OrderNumber,
    o.CustomerName,
    o.OrderedProductName,
    o.QuantityOrdered,
    o.OrderStatus,
    o.OrderDate,
    l.LotID,
    l.LotNumber,
    l.ProductName AS LotProductName,
    l.QuantityStarted,
    l.QuantityCompleted,
    l.LotStatus,
    te.EventTime,
    te.EventType,
    te.EventStatus,
    te.TraceEventID,
    te.EventDetails
FROM TraceEvents AS te
INNER JOIN OrderContext AS o
    ON o.OrderID = te.OrderID
LEFT JOIN OrderLots AS l
    ON l.LotID = te.LotID
ORDER BY
    te.EventTime,
    l.LotNumber,
    te.EventType,
    te.TraceEventID;