USE ProductionERP;
GO

INSERT INTO Support.BatchJob
(
    JobName,
    Description,
    Frequency
)
VALUES
(
    'MES to NAV Inventory Sync',
    'Posts completed production lots to ERP inventory',
    'Every 15 Minutes'
),
(
    'Production Order Import',
    'Imports production orders from ERP',
    'Hourly'
),
(
    'Quality Results Upload',
    'Uploads inspection results to ERP',
    'Every 30 Minutes'
),
(
    'Equipment Status Sync',
    'Synchronizes equipment status from MES',
    'Every 5 Minutes'
),
(
    'Customer Order Export',
    'Exports shipment confirmations',
    'Hourly'
),
(
    'Nightly Production Archive',
    'Archives completed production history',
    'Daily'
);
GO

-- ==================================================================

DECLARE @i INT = 1;

WHILE @i <= 300
BEGIN

INSERT INTO Support.BatchJobExecution
(
    BatchJobID,
    StartTime,
    EndTime,
    Status,
    RecordsProcessed,
    ErrorMessage
)

VALUES
(
    ((@i-1)%6)+1,

    DATEADD(HOUR,-@i,SYSDATETIME()),

    DATEADD(MINUTE,5,DATEADD(HOUR,-@i,SYSDATETIME())),

    CASE
        WHEN @i%25=0 THEN 'Failed'
        WHEN @i%12=0 THEN 'Warning'
        ELSE 'Success'
    END,

    500+(@i%200),

    CASE
        WHEN @i%25=0
        THEN 'Database timeout while posting inventory'
        ELSE NULL
    END
);

SET @i=@i+1;

END
GO

-- ==================================================================

SELECT COUNT(*)
FROM Support.BatchJobExecution;