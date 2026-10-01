USE ProductionERP;
GO

-- Completed manufacturing lots that never became inventory
SELECT
    l.LotNumber,
    l.LotStatus,
    l.QuantityCompleted,

    CASE
        WHEN iq.QueueID IS NULL
        THEN 'Missing ERP Message'

        WHEN iq.ProcessingStatus = 'Failed'
        THEN 'ERP Failure'

        ELSE 'Unknown'
    END AS Issue
FROM Production.Lot l
LEFT JOIN Inventory.ERPIntegrationQueue iq
    ON l.LotNumber = iq.ReferenceID
LEFT JOIN Inventory.InventoryTransaction it
    ON l.LotID = it.LotID
WHERE
    l.LotStatus = 'Completed'
    AND it.TransactionID IS NULL;