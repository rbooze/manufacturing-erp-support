USE ProductionERP;
GO

-- Are messages stuck in the interface queue?
SELECT
    QueueID,
    ReferenceID AS LotNumber,
    MessageType,
    ProcessingStatus,
    CreatedDate,

    DATEDIFF(
        MINUTE,
        CreatedDate,
        SYSDATETIME()
    ) AS MinutesWaiting
FROM Inventory.ERPIntegrationQueue
WHERE 
	ProcessingStatus IN ('Pending','Processing')
ORDER BY
    CreatedDate;