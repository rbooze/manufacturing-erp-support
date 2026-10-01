USE ProductionERP;
GO

-- Inventory is missing
SELECT
    QueueID,
    ReferenceID AS LotNumber,
    MessageType,
    SourceSystem,
    TargetSystem,
    ProcessingStatus,
    ErrorMessage,
    CreatedDate
FROM Inventory.ERPIntegrationQueue
WHERE 
	ProcessingStatus = 'Failed'
ORDER BY
    CreatedDate DESC;