USE ProductionERP;
GO

INSERT INTO Inventory.ERPIntegrationQueue
(
    SourceSystem,
    TargetSystem,
    MessageType,
    ReferenceID,
    ProcessingStatus,
    ErrorMessage,
    CreatedDate,
    ProcessedDate
)
VALUES
(
    'MES',
    'Dynamics NAV',
    'Production Receipt',
    'LOT-20260922-0997',
    'Processed',
    NULL,
    SYSDATETIME(),
    SYSDATETIME()
);
GO

-- ===============================================================

INSERT INTO Inventory.InventoryTransaction
(
    LotID,
    ProductID,
    WarehouseID,
    TransactionType,
    Quantity,
    TransactionStatus,
    SourceSystem,
    TransactionDate
)
SELECT
    LotID,
    ProductID,
    1,
    'Production Receipt',
    QuantityCompleted,
    'Posted',
    'MES',
    SYSDATETIME()
FROM Production.Lot
WHERE LotNumber='LOT-20260922-0997';
GO

-- ===============================================================

SELECT
	co.OrderNumber,
	l.LotNumber,
	iq.ProcessingStatus AS ERP_Status,
	it.TransactionStatus AS Inventory_Status,
	it.Quantity
FROM Inventory.CustomerOrder co
JOIN Production.Lot l
	ON co.OrderID = l.OrderID
LEFT JOIN Inventory.ERPIntegrationQueue iq
	ON l.LotNumber = iq.ReferenceID
LEFT JOIN Inventory.InventoryTransaction it
	ON l.LotID = it.LotID
WHERE 
	co.OrderNumber='PO-20260902-002';