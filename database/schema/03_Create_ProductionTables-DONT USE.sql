USE ProductionERP;
GO

CREATE TABLE Production.WorkOrder
(
    WorkOrderID            INT IDENTITY(1,1) PRIMARY KEY,
    WorkOrderNumber        VARCHAR(20) NOT NULL UNIQUE,
    ItemID                 INT NOT NULL,
    MachineID              INT NOT NULL,
    EmployeeID             INT NOT NULL,
    QuantityPlanned        INT NOT NULL,
    QuantityCompleted      INT NULL,
    Status                 VARCHAR(20) NOT NULL,
    Priority               VARCHAR(20) NOT NULL,
    ScheduledStartDate     DATETIME2 NOT NULL,
    ScheduledEndDate       DATETIME2 NOT NULL,
    ActualStartDate        DATETIME2 NULL,
    ActualEndDate          DATETIME2 NULL,
    CreatedDate            DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    LastModifiedDate       DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    CONSTRAINT FK_WorkOrder_Item
        FOREIGN KEY(ItemID)
        REFERENCES Master.Item(ItemID),

    CONSTRAINT FK_WorkOrder_Machine
        FOREIGN KEY(MachineID)
        REFERENCES Master.Machine(MachineID),

    CONSTRAINT FK_WorkOrder_Employee
        FOREIGN KEY(EmployeeID)
        REFERENCES Master.Employee(EmployeeID)
);
GO

-- ======================================================================

CREATE TABLE Production.OperationHistory
(
    OperationID            INT IDENTITY(1,1) PRIMARY KEY,
    WorkOrderID            INT NOT NULL,
    OperationSequence      INT NOT NULL,
    OperationName          VARCHAR(100) NOT NULL,
    StartTime              DATETIME2 NOT NULL,
    EndTime                DATETIME2 NULL,
    OperationStatus        VARCHAR(20) NOT NULL,
    DurationMinutes        INT NULL,

    CONSTRAINT FK_Operation_WorkOrder
        FOREIGN KEY(WorkOrderID)
        REFERENCES Production.WorkOrder(WorkOrderID)
);
GO

-- ======================================================================

CREATE TABLE Production.QualityInspection
(
    InspectionID          INT IDENTITY(1,1) PRIMARY KEY,
    WorkOrderID           INT NOT NULL,
    InspectionDate        DATETIME2 NOT NULL,
    InspectorID           INT NOT NULL,
    QuantityInspected     INT NOT NULL,
    QuantityRejected      INT NOT NULL,
    Result                VARCHAR(20) NOT NULL,
    Comments              VARCHAR(500) NULL,

    CONSTRAINT FK_QI_WorkOrder
        FOREIGN KEY(WorkOrderID)
        REFERENCES Production.WorkOrder(WorkOrderID),

    CONSTRAINT FK_QI_Inspector
        FOREIGN KEY(InspectorID)
        REFERENCES Master.Employee(EmployeeID)
);
GO

-- ======================================================================

SELECT 
	TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE 
	TABLE_SCHEMA='Production';