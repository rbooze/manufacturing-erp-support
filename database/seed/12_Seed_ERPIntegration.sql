USE ProductionERP;
GO


INSERT INTO Inventory.ERPIntegrationQueue
(
    SourceSystem,
    TargetSystem,
    MessageType,
    ReferenceID,
    ProcessingStatus,
    ErrorMessage
)
VALUES
(
    'MES',
    'Dynamics NAV',
    'Production Completion',
    'LOT-GAAS-20260901',
    'Processed',
    NULL
),
(
    'MES',
    'Dynamics NAV',
    'Production Completion',
    'LOT-GAN-20260902',
    'Failed',
    'NAV item journal posting error'
),
(
    'MES',
    'Dynamics NAV',
    'Production Completion',
    'LOT-INP-20260903',
    'Pending',
    NULL
);
GO

SELECT *
FROM Inventory.ERPIntegrationQueue;

-- ===========================================================

INSERT INTO Logging.InterfaceLog
(
    SourceSystem,
    TargetSystem,
    MessageType,
    ReferenceID,
    Status,
    ErrorCode,
    ErrorMessage
)
VALUES
(
    'MES',
    'Dynamics NAV',
    'Production Completion',
    'LOT-GAAS-20260901',
    'Success',
    NULL,
    NULL
),
(
    'MES',
    'Dynamics NAV',
    'Production Completion',
    'LOT-GAN-20260902',
    'Failed',
    'NAV-POST-001',
    'Item journal posting failed'
),
(
    'MES',
    'Dynamics NAV',
    'Production Completion',
    'LOT-INP-20260903',
    'Waiting',
    NULL,
    NULL
);
GO

SELECT
    q.ReferenceID AS LotNumber,
    q.MessageType,
    q.ProcessingStatus,
    q.ErrorMessage,
    l.ErrorCode
FROM Inventory.ERPIntegrationQueue q
LEFT JOIN Logging.InterfaceLog l
    ON q.ReferenceID = l.ReferenceID
WHERE q.ProcessingStatus = 'Failed';