USE ProductionERP;
GO

/*
=====================================================
017A - Seed Support Tables
Purpose:
Populate application support environment
=====================================================
*/

-----------------------------------------------------
-- Application Logs
-----------------------------------------------------

INSERT INTO Support.ApplicationLog
(
    LogTime,
    ApplicationName,
    LogLevel,
    ModuleName,
    ReferenceNumber,
    Message,
    ExceptionText
)
VALUES

(DATEADD(HOUR,-2,SYSDATETIME()),
'MES',
'INFO',
'Production',
'LOT-GAN-20260918-0145',
'Production lot completed successfully',
NULL),

(DATEADD(HOUR,-3,SYSDATETIME()),
'ERP Interface',
'ERROR',
'Inventory Posting',
'LOT-GAN-20260918-0145',
'Inventory posting failed',
'Item mapping missing in ERP'),

(DATEADD(HOUR,-5,SYSDATETIME()),
'ERP Interface',
'WARNING',
'Message Queue',
'LOT-GAAS-20260917-0088',
'Retry attempt exceeded',
'Temporary connection failure'),

(DATEADD(DAY,-1,SYSDATETIME()),
'Quality System',
'ERROR',
'Inspection Upload',
'LOT-INP-20260916-0021',
'Quality results upload failed',
'Database timeout'),

(DATEADD(DAY,-2,SYSDATETIME()),
'MES',
'INFO',
'Process Engine',
'LOT-GAN-20260915-0090',
'Process step completed',
NULL),

(DATEADD(DAY,-3,SYSDATETIME()),
'ERP Interface',
'ERROR',
'Integration Service',
'LOT-GAAS-20260914-0012',
'ERP connection unavailable',
'Connection timeout after 30 seconds');

GO

-----------------------------------------------------
-- User Sessions
-----------------------------------------------------

INSERT INTO Support.UserSession
(
    EmployeeID,
    LoginTime,
    LogoutTime,
    ClientApplication,
    IPAddress,
    SessionStatus
)
VALUES

(1,
DATEADD(HOUR,-8,SYSDATETIME()),
DATEADD(HOUR,-1,SYSDATETIME()),
'MES Client',
'10.10.1.15',
'Closed'),

(2,
DATEADD(HOUR,-4,SYSDATETIME()),
NULL,
'Dynamics NAV',
'10.10.1.25',
'Active'),

(3,
DATEADD(HOUR,-3,SYSDATETIME()),
NULL,
'Quality System',
'10.10.1.30',
'Active'),

(4,
DATEADD(HOUR,-1,SYSDATETIME()),
NULL,
'Production Dashboard',
'10.10.1.40',
'Active');

GO

-----------------------------------------------------
-- Support Tickets
-----------------------------------------------------

INSERT INTO Support.SupportTicket
(
    TicketNumber,
    Priority,
    Category,
    SystemAffected,
    Description,
    Status,
    AssignedTo,
    CreatedDate,
    ClosedDate
)
VALUES

(
'INC-10001',
'Critical',
'Integration',
'ERP Integration',
'Completed production lot missing from ERP inventory',
'Open',
4,
DATEADD(HOUR,-5,SYSDATETIME()),
NULL
),

(
'INC-10002',
'High',
'Production',
'MES',
'Operator unable to complete production step',
'Open',
3,
DATEADD(DAY,-1,SYSDATETIME()),
NULL
),

(
'INC-10003',
'High',
'Quality',
'Quality System',
'Quality results upload failed',
'Closed',
2,
DATEADD(DAY,-3,SYSDATETIME()),
DATEADD(DAY,-2,SYSDATETIME())
),

(
'INC-10004',
'Medium',
'Access',
'Application',
'User unable to access manufacturing application',
'Open',
4,
DATEADD(DAY,-2,SYSDATETIME()),
NULL
),

(
'INC-10005',
'High',
'Equipment',
'Maintenance System',
'Equipment alarm causing production delay',
'Open',
3,
DATEADD(DAY,-1,SYSDATETIME()),
NULL
);
GO

-----------------------------------------------------
-- Knowledge Base
-----------------------------------------------------

INSERT INTO Support.KnowledgeBase
(
    ArticleNumber,
    Title,
    Symptoms,
    Resolution,
    CreatedDate
)
VALUES

(
'KB-001',
'Missing ERP Inventory Posting',
'Production complete but ERP inventory unavailable',
'Verify integration queue, correct error, reprocess transaction',
SYSDATETIME()
),

(
'KB-002',
'ERP Interface Failure',
'Transactions remain pending or failed',
'Review application logs and restart integration process',
SYSDATETIME()
),

(
'KB-003',
'Recipe Validation Error',
'Lot cannot proceed to next operation',
'Verify active recipe version',
SYSDATETIME()
),

(
'KB-004',
'Equipment Alarm Investigation',
'Production failure associated with machine issue',
'Review alarm history and maintenance records',
SYSDATETIME()
);

GO

-----------------------------------------------------
-- Root Cause Analysis
-----------------------------------------------------

INSERT INTO Support.RootCauseAnalysis
(
    TicketID,
    RootCauseCategory,
    RootCauseDetail,
    CorrectiveAction,
    PreventiveAction,
    CompletedDate
)
VALUES

(
1,
'Data Configuration',
'ERP item mapping missing for manufactured product',
'Updated item master mapping and reprocessed transaction',
'Added validation before ERP posting',
SYSDATETIME()
),

(
3,
'Application',
'Database timeout during quality upload process',
'Restarted upload service and completed transaction',
'Added monitoring for upload duration',
SYSDATETIME()
);
GO

-----------------------------------------------------
-- Verification
-----------------------------------------------------

SELECT 'ApplicationLog' AS TableName,
COUNT(*) AS RecordCount
FROM Support.ApplicationLog

UNION ALL

SELECT 'UserSession',
COUNT(*)
FROM Support.UserSession

UNION ALL

SELECT 'SupportTicket',
COUNT(*)
FROM Support.SupportTicket

UNION ALL

SELECT 'KnowledgeBase',
COUNT(*)
FROM Support.KnowledgeBase

UNION ALL

SELECT 'RootCauseAnalysis',
COUNT(*)
FROM Support.RootCauseAnalysis;

GO