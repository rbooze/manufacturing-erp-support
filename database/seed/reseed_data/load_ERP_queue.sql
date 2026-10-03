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

-- Successful production receipt
(
    'MES',
    'ERP',
    'Production Receipt',
    'LOT-GAN-5001',
    'Success',
    NULL,
    DATEADD(hour,-2,GETDATE()),
    DATEADD(hour,-1,GETDATE())
),

-- Failed ERP integration scenario
(
    'MES',
    'ERP',
    'Production Receipt',
    'LOT-OPT-5003',
    'Failed',
    'ERP Item Master Mapping Missing',
    DATEADD(hour,-1,GETDATE()),
    NULL
),

-- Pending interface scenario
(
    'MES',
    'ERP',
    'Production Receipt',
    'LOT-SIC-5002',
    'Pending',
    NULL,
    GETDATE(),
    NULL
);
GO

SELECT
    QueueID,
    SourceSystem,
    TargetSystem,
    MessageType,
    ReferenceID,
    ProcessingStatus,
    ErrorMessage
FROM Inventory.ERPIntegrationQueue;