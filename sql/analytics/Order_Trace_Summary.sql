DECLARE @OrderNumber VARCHAR(50) = 'PO-20260902-002';

SELECT

    co.OrderNumber,
    c.CustomerName,
    p.ProductName,

    l.LotNumber,
    l.LotStatus,
    l.QuantityCompleted,

    COUNT(DISTINCT ph.HistoryID) AS ProcessStepsCompleted,

    COUNT(DISTINCT qr.QualityID) AS QualityTests,

    MAX(qr.Result) AS QualityResult,

    COUNT(DISTINCT iq.QueueID) AS ERPMessages,

    COUNT(DISTINCT it.TransactionID) AS InventoryTransactions

FROM Inventory.CustomerOrder co

JOIN Master.Customer c
    ON co.CustomerID = c.CustomerID

JOIN Master.Product p
    ON co.ProductID = p.ProductID

JOIN Production.Lot l
    ON co.OrderID = l.OrderID

LEFT JOIN Production.ProcessHistory ph
    ON l.LotID = ph.LotID

LEFT JOIN Production.QualityResult qr
    ON l.LotID = qr.LotID

LEFT JOIN Inventory.ERPIntegrationQueue iq
    ON l.LotNumber = iq.ReferenceID

LEFT JOIN Inventory.InventoryTransaction it
    ON l.LotID = it.LotID

WHERE co.OrderNumber = @OrderNumber

GROUP BY
    co.OrderNumber,
    c.CustomerName,
    p.ProductName,
    l.LotNumber,
    l.LotStatus,
    l.QuantityCompleted;