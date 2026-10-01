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
    'LOT-20260921-0998',
    'Failed',
    'ERP Item Master Mapping Missing',
    SYSDATETIME(),
    NULL
);
GO

-- =========================================

-- Confirm the failure
SELECT
    QueueID,
    ReferenceID,
    MessageType,
    ProcessingStatus,
    ErrorMessage
FROM Inventory.ERPIntegrationQueue
WHERE 
	ReferenceID='LOT-20260921-0998';

-- Confirm no inventory exists
SELECT
    l.LotNumber,
    COUNT(it.TransactionID) AS InventoryTransactions
FROM Production.Lot l
LEFT JOIN Inventory.InventoryTransaction it
	ON l.LotID=it.LotID
WHERE
	l.LotNumber='LOT-20260921-0998'
GROUP BY
    l.LotNumber;