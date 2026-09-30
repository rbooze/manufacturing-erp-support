CREATE SCHEMA Maintenance;
GO

CREATE TABLE Maintenance.EquipmentEvent
(
    EquipmentEventID     INT IDENTITY(1,1) PRIMARY KEY,
    EquipmentID          INT NOT NULL,
    EventType            VARCHAR(50) NOT NULL,
    EventDate            DATETIME2 NOT NULL,
    EventStatus          VARCHAR(30) NOT NULL,
    Description          VARCHAR(500) NULL,
    CreatedDate          DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    CONSTRAINT FK_EquipmentEvent_Equipment
        FOREIGN KEY(EquipmentID)
        REFERENCES Master.Equipment(EquipmentID)
);
GO

CREATE TABLE Maintenance.EquipmentAlarm
(
    AlarmID             INT IDENTITY(1,1) PRIMARY KEY,
    EquipmentID         INT NOT NULL,
    AlarmCode           VARCHAR(50) NOT NULL,
    AlarmSeverity       VARCHAR(20) NOT NULL,
    AlarmMessage        VARCHAR(500) NOT NULL,
    AlarmTime           DATETIME2 NOT NULL,
    ResolvedTime        DATETIME2 NULL,
    ResolutionNotes     VARCHAR(500) NULL,

    CONSTRAINT FK_EquipmentAlarm_Equipment
        FOREIGN KEY(EquipmentID)
        REFERENCES Master.Equipment(EquipmentID)
);
GO

CREATE TABLE Maintenance.WorkOrder
(
    WorkOrderID          INT IDENTITY(1,1) PRIMARY KEY,
    WorkOrderNumber      VARCHAR(30) NOT NULL UNIQUE,
    EquipmentID          INT NOT NULL,
    AssignedEmployeeID   INT NULL,
    ProblemDescription   VARCHAR(500) NOT NULL,
    WorkStatus           VARCHAR(30) NOT NULL,
    CreatedDate          DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    CompletedDate        DATETIME2 NULL,

    CONSTRAINT FK_WorkOrder_Equipment
        FOREIGN KEY(EquipmentID)
        REFERENCES Master.Equipment(EquipmentID),

    CONSTRAINT FK_WorkOrder_Employee
        FOREIGN KEY(AssignedEmployeeID)
        REFERENCES Master.Employee(EmployeeID)
);
GO

SELECT
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE 
	TABLE_SCHEMA='Maintenance';