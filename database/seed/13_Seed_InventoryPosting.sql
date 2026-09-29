USE ProductionERP;
GO

INSERT INTO Inventory.Warehouse
(
    WarehouseCode,
    WarehouseName,
    Location,
    WarehouseType
)
VALUES
(
    'FG01',
    'Finished Goods Warehouse',
    'Building A',
    'Finished Goods'
),
(
    'QH01',
    'Quality Hold Warehouse',
    'Building B',
    'Quality Hold'
),
(
    'RM01',
    'Raw Material Warehouse',
    'Building C',
    'Raw Materials'
);
GO

SELECT * FROM Inventory.Warehouse;

-- ==================================================================

INSERT INTO Inventory.InventoryTransaction
(
    LotID,
    ProductID,
    WarehouseID,
    TransactionType,
    Quantity,
    TransactionStatus,
    SourceSystem
)
VALUES
(
    1,
    1,
    1,
    'Production Receipt',
    50,
    'Posted',
    'Dynamics NAV'
),
(
    3,
    3,
    2,
    'Production Receipt',
    40,
    'Posted',
    'Dynamics NAV'
);
GO

-- ==================================================================

INSERT INTO Inventory.Stock
(
    ProductID,
    WarehouseID,
    QuantityAvailable,
    QuantityReserved
)
VALUES
(
    1,
    1,
    50,
    0
),
(
    3,
    2,
    40,
    0
);
GO

SELECT
    l.LotNumber,
    l.LotStatus,
    p.ProductName
FROM Production.Lot l
JOIN Master.Product p
    ON l.ProductID=p.ProductID
WHERE l.LotNumber='LOT-GAN-20260902';

SELECT *
FROM Inventory.InventoryTransaction
WHERE LotID=2;

SELECT *
FROM Inventory.ERPIntegrationQueue
WHERE ReferenceID='LOT-GAN-20260902';