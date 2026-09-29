USE ProductionERP;
GO

CREATE TABLE Logging.InterfaceLog
(
    InterfaceLogID      INT IDENTITY(1,1) PRIMARY KEY,
    SourceSystem        VARCHAR(50) NOT NULL,
    TargetSystem        VARCHAR(50) NOT NULL,
    MessageType         VARCHAR(50) NOT NULL,
    ReferenceID         VARCHAR(50) NOT NULL,
    Status              VARCHAR(30) NOT NULL,
    ErrorCode           VARCHAR(50) NULL,
    ErrorMessage        VARCHAR(500) NULL,
    LogTimestamp        DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);
GO

CREATE TABLE Logging.ApplicationLog
(
    ApplicationLogID    INT IDENTITY(1,1) PRIMARY KEY,
    ApplicationName     VARCHAR(100) NOT NULL,
    ComponentName       VARCHAR(100) NULL,
    Severity            VARCHAR(20) NOT NULL,
    ErrorMessage        VARCHAR(500) NOT NULL,
    StackTrace          VARCHAR(MAX) NULL,
    CreatedDate         DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);
GO

CREATE TABLE Support.SupportTicket
(
    TicketID            INT IDENTITY(1,1) PRIMARY KEY,
    TicketNumber        VARCHAR(20) NOT NULL UNIQUE,
    Priority            VARCHAR(20) NOT NULL,
    Category            VARCHAR(50) NOT NULL,
    SystemAffected      VARCHAR(50) NOT NULL,
    Description         VARCHAR(1000) NOT NULL,
    Status              VARCHAR(30) NOT NULL,
    AssignedTo          INT NULL,
    CreatedDate         DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    ClosedDate          DATETIME2 NULL,

    CONSTRAINT FK_Ticket_Assignee
        FOREIGN KEY(AssignedTo)
        REFERENCES Master.Employee(EmployeeID)
);
GO

CREATE TABLE Support.RootCauseAnalysis
(
    RCAID               INT IDENTITY(1,1) PRIMARY KEY,
    TicketID            INT NOT NULL,
    RootCauseCategory   VARCHAR(100) NOT NULL,
    RootCauseDetail     VARCHAR(1000) NOT NULL,
    CorrectiveAction    VARCHAR(1000) NOT NULL,
    PreventiveAction    VARCHAR(1000) NULL,
    CompletedDate       DATETIME2 NULL,

    CONSTRAINT FK_RCA_Ticket
        FOREIGN KEY(TicketID)
        REFERENCES Support.SupportTicket(TicketID)
);
GO

SELECT 
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA IN ('Logging','Support')
ORDER BY 
	TABLE_SCHEMA, 
	TABLE_NAME;