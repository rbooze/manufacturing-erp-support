USE ProductionERP;
GO

--CREATE SCHEMA Support;
--GO

CREATE TABLE Support.ApplicationLog
(
    LogID               INT IDENTITY(1,1) PRIMARY KEY,
    LogTime             DATETIME2 NOT NULL,
    ApplicationName     VARCHAR(50) NOT NULL,
    LogLevel            VARCHAR(20) NOT NULL,
    ModuleName          VARCHAR(100) NOT NULL,
    ReferenceNumber     VARCHAR(50) NULL,
    Message             VARCHAR(1000) NOT NULL,
    ExceptionText       VARCHAR(MAX) NULL
);
GO

CREATE TABLE Support.BatchJob
(
    BatchJobID          INT IDENTITY(1,1) PRIMARY KEY,
    JobName             VARCHAR(100) NOT NULL,
    Description         VARCHAR(500),
    Frequency           VARCHAR(30),
    IsActive            BIT NOT NULL DEFAULT 1
);
GO

CREATE TABLE Support.BatchJobExecution
(
    ExecutionID         INT IDENTITY(1,1) PRIMARY KEY,
    BatchJobID          INT NOT NULL,
    StartTime           DATETIME2 NOT NULL,
    EndTime             DATETIME2 NULL,
    Status              VARCHAR(20) NOT NULL,
    RecordsProcessed    INT,
    ErrorMessage        VARCHAR(1000),

    CONSTRAINT FK_BatchExecution_Job
        FOREIGN KEY (BatchJobID)
        REFERENCES Support.BatchJob(BatchJobID)
);
GO

CREATE TABLE Support.UserSession
(
    SessionID           INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID          INT NOT NULL,
    LoginTime           DATETIME2 NOT NULL,
    LogoutTime          DATETIME2 NULL,
    ClientApplication   VARCHAR(50),
    IPAddress           VARCHAR(50),
    SessionStatus       VARCHAR(20),

    CONSTRAINT FK_UserSession_Employee
        FOREIGN KEY(EmployeeID)
        REFERENCES Master.Employee(EmployeeID)
);
GO

CREATE TABLE Support.Incident
(
    IncidentID          INT IDENTITY(1,1) PRIMARY KEY,
    IncidentNumber      VARCHAR(30) UNIQUE,
    Priority            VARCHAR(20),
    Status              VARCHAR(20),
    ModuleName          VARCHAR(100),
    ReportedDate        DATETIME2,
    AssignedEmployeeID  INT,
    Summary             VARCHAR(500),
    RootCause           VARCHAR(1000),
    Resolution          VARCHAR(1000),

    CONSTRAINT FK_Incident_Employee
        FOREIGN KEY(AssignedEmployeeID)
        REFERENCES Master.Employee(EmployeeID)
);
GO

CREATE TABLE Support.KnowledgeBase
(
    ArticleID           INT IDENTITY(1,1) PRIMARY KEY,
    ArticleNumber       VARCHAR(30) UNIQUE,
    Title               VARCHAR(200),
    Symptoms            VARCHAR(1000),
    Resolution          VARCHAR(MAX),
    CreatedDate         DATETIME2 DEFAULT SYSDATETIME()
);
GO

SELECT
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE 
	TABLE_SCHEMA = 'Support'
ORDER BY 
	TABLE_NAME;