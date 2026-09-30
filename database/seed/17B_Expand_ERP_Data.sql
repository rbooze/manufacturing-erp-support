USE ProductionERP;
GO


/*
=====================================================
017B - Expand ERP Data
Purpose:
Create realistic MES -> ERP support scenarios
=====================================================
*/

-----------------------------------------------------
-- Customer Orders
-----------------------------------------------------

INSERT INTO Inventory.CustomerOrder
(
    OrderNumber,
    CustomerID,
    ProductID,
    QuantityOrdered,
    OrderStatus,
    OrderDate
)
VALUES

('PO-20260901-001',1,1,100,'Open',DATEADD(DAY,-20,SYSDATETIME())),
('PO-20260902-002',2,2,250,'Released',DATEADD(DAY,-18,SYSDATETIME())),
('PO-20260903-003',3,3,75,'Released',DATEADD(DAY,-15,SYSDATETIME())),
('PO-20260904-004',1,1,150,'Completed',DATEADD(DAY,-12,SYSDATETIME())),
('PO-20260905-005',2,2,200,'Open',DATEADD(DAY,-10,SYSDATETIME()));

GO


-----------------------------------------------------
-- ERP Integration Queue
-----------------------------------------------------

DECLARE @i INT = 1;

WHILE @i <= 300
BEGIN

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

CASE
    WHEN @i % 3 = 0 THEN 'Production Receipt'
    WHEN @i % 3 = 1 THEN 'Inventory Adjustment'
    ELSE 'Quality Release'
END,

'LOT-GAN-' + RIGHT('0000'+CAST(@i AS VARCHAR(4)),4),

CASE
    WHEN @i % 20 = 0 THEN 'Failed'
    WHEN @i % 10 = 0 THEN 'Pending'
    ELSE 'Processed'
END,

CASE
    WHEN @i % 20 = 0 THEN
    'ERP posting failed: Item mapping missing'

    WHEN @i % 10 = 0 THEN
    'Waiting for ERP retry'

    ELSE NULL
END,

DATEADD(HOUR,-@i,SYSDATETIME()),

CASE
    WHEN @i % 10 <> 0
    THEN DATEADD(MINUTE,15,DATEADD(HOUR,-@i,SYSDATETIME()))

    ELSE NULL
END
);


SET @i=@i+1;

END

GO


-----------------------------------------------------
-- Inventory Transactions
-----------------------------------------------------

DECLARE @x INT = 1;

WHILE @x <= 500
BEGIN

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

VALUES
(
((@x-1)%1000)+1,

((@x-1)%3)+1,

((@x-1)%3)+1,

CASE
    WHEN @x % 4 = 0 THEN 'Production Receipt'
    WHEN @x % 4 = 1 THEN 'Transfer'
    WHEN @x % 4 = 2 THEN 'Adjustment'
    ELSE 'Quality Release'
END,

50 + (@x % 100),

CASE
    WHEN @x % 25 = 0 THEN 'Failed'
    ELSE 'Posted'
END,

'MES',

DATEADD(DAY,-(@x%30),SYSDATETIME())

);

SET @x=@x+1;

END

GO


-----------------------------------------------------
-- Expand Stock
-----------------------------------------------------

INSERT INTO Inventory.Stock
(
    ProductID,
    WarehouseID,
    QuantityAvailable,
    QuantityReserved,
    LastUpdated
)
VALUES

(1,1,450,50,SYSDATETIME()),
(2,1,700,100,SYSDATETIME()),
(3,1,200,25,SYSDATETIME()),
(1,2,100,0,SYSDATETIME()),
(2,2,75,10,SYSDATETIME()),
(3,3,50,0,SYSDATETIME());

GO


-----------------------------------------------------
-- Verification
-----------------------------------------------------

SELECT
'CustomerOrder' AS TableName,
COUNT(*) AS RecordCount
FROM Inventory.CustomerOrder

UNION ALL

SELECT
'ERPIntegrationQueue',
COUNT(*)
FROM Inventory.ERPIntegrationQueue

UNION ALL

SELECT
'InventoryTransaction',
COUNT(*)
FROM Inventory.InventoryTransaction

UNION ALL

SELECT
'Stock',
COUNT(*)
FROM Inventory.Stock;

GO