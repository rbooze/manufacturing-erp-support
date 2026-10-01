USE ProductionERP;
GO

DECLARE @OrderNumber VARCHAR(50) = 'PO-20260902-002';

SELECT

    -- Customer Order
    co.OrderNumber,
    co.OrderStatus,
    co.OrderDate,

    -- Customer
    c.CustomerName,

    -- Product
    p.ProductName,

    -- Production Lot
    l.LotNumber,
    l.LotStatus,
    l.QuantityStarted,
    l.QuantityCompleted,

    -- Epiwafer Run
    er.RunID,
    er.RecipeName,
    er.RunStatus,
    er.StartTime AS RunStartTime,
    er.EndTime AS RunEndTime,

    -- Process History
    ph.HistoryID,
    ph.ProcessStepID,
    ph.ProcessStatus,
    ph.StartTime AS ProcessStartTime,
    ph.EndTime AS ProcessEndTime,
    ph.Notes,

    -- Quality
    qr.QualityID,
    qr.TestType,
    qr.MeasurementValue,
    qr.Result,
    qr.TestedDate,

    -- ERP Integration
    iq.QueueID,
    iq.MessageType,
    iq.ProcessingStatus,
    iq.ErrorMessage,

    -- Inventory Transaction
    it.TransactionID,
    it.TransactionType,
    it.Quantity,
    it.TransactionStatus,

    -- Warehouse
    w.WarehouseCode,
    w.WarehouseName,

    -- Stock
    s.QuantityAvailable,
    s.QuantityReserved


FROM Inventory.CustomerOrder co

JOIN Master.Customer c
    ON co.CustomerID = c.CustomerID

JOIN Master.Product p
    ON co.ProductID = p.ProductID

JOIN Production.Lot l
    ON co.OrderID = l.OrderID

LEFT JOIN Production.EpiwaferRun er
    ON l.LotID = er.LotID

LEFT JOIN Production.ProcessHistory ph
    ON l.LotID = ph.LotID

LEFT JOIN Production.QualityResult qr
    ON l.LotID = qr.LotID

LEFT JOIN Inventory.ERPIntegrationQueue iq
    ON l.LotNumber = iq.ReferenceID

LEFT JOIN Inventory.InventoryTransaction it
    ON l.LotID = it.LotID

LEFT JOIN Inventory.Warehouse w
    ON it.WarehouseID = w.WarehouseID

LEFT JOIN Inventory.Stock s
    ON it.ProductID = s.ProductID
    AND it.WarehouseID = s.WarehouseID

WHERE co.OrderNumber = @OrderNumber

ORDER BY
    ph.StartTime;