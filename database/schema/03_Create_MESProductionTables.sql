USE ProductionERP;
GO

CREATE TABLE Production.Lot
(
    LotID               INT IDENTITY(1,1) PRIMARY KEY,
    LotNumber           VARCHAR(40) NOT NULL UNIQUE,
    ProductID           INT NOT NULL,
    CustomerID          INT NOT NULL,
    QuantityStarted     INT NOT NULL,
    QuantityCompleted   INT NULL,
    LotStatus           VARCHAR(30) NOT NULL,
    CreatedDate         DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    CompletedDate       DATETIME2 NULL,

    CONSTRAINT FK_Lot_Product
        FOREIGN KEY(ProductID)
        REFERENCES Master.Product(ProductID),

    CONSTRAINT FK_Lot_Customer
        FOREIGN KEY(CustomerID)
        REFERENCES Master.Customer(CustomerID)
);
GO

CREATE TABLE Production.EpiwaferRun
(
    RunID               INT IDENTITY(1,1) PRIMARY KEY,
    LotID               INT NOT NULL,
    EquipmentID         INT NOT NULL,
    OperatorID          INT NOT NULL,
    RecipeName          VARCHAR(100) NOT NULL,
    StartTime           DATETIME2 NOT NULL,
    EndTime             DATETIME2 NULL,
    RunStatus           VARCHAR(30) NOT NULL,
    CreatedDate         DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    CONSTRAINT FK_Run_Lot
        FOREIGN KEY(LotID)
        REFERENCES Production.Lot(LotID),

    CONSTRAINT FK_Run_Equipment
        FOREIGN KEY(EquipmentID)
        REFERENCES Master.Equipment(EquipmentID),

    CONSTRAINT FK_Run_Operator
        FOREIGN KEY(OperatorID)
        REFERENCES Master.Employee(EmployeeID)
);
GO

CREATE TABLE Production.ProcessStep
(
    ProcessStepID       INT IDENTITY(1,1) PRIMARY KEY,
    StepNumber          INT NOT NULL,
    StepName            VARCHAR(100) NOT NULL,
    Description         VARCHAR(250) NULL,
    IsActive            BIT NOT NULL DEFAULT 1
);
GO

CREATE TABLE Production.ProcessHistory
(
    HistoryID           INT IDENTITY(1,1) PRIMARY KEY,
    LotID               INT NOT NULL,
    ProcessStepID       INT NOT NULL,
    EquipmentID         INT NULL,
    StartTime           DATETIME2 NOT NULL,
    EndTime             DATETIME2 NULL,
    ProcessStatus       VARCHAR(30) NOT NULL,
    Notes               VARCHAR(500) NULL,

    CONSTRAINT FK_ProcessHistory_Lot
        FOREIGN KEY(LotID)
        REFERENCES Production.Lot(LotID),

    CONSTRAINT FK_ProcessHistory_Step
        FOREIGN KEY(ProcessStepID)
        REFERENCES Production.ProcessStep(ProcessStepID),

    CONSTRAINT FK_ProcessHistory_Equipment
        FOREIGN KEY(EquipmentID)
        REFERENCES Master.Equipment(EquipmentID)
);
GO

CREATE TABLE Production.QualityResult
(
    QualityID           INT IDENTITY(1,1) PRIMARY KEY,
    LotID               INT NOT NULL,
    TestType            VARCHAR(100) NOT NULL,
    MeasurementValue    DECIMAL(12,4) NULL,
    SpecificationMin    DECIMAL(12,4) NULL,
    SpecificationMax    DECIMAL(12,4) NULL,
    Result              VARCHAR(20) NOT NULL,
    TestedDate          DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    CONSTRAINT FK_Quality_Lot
        FOREIGN KEY(LotID)
        REFERENCES Production.Lot(LotID)
);
GO

SELECT 
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE 
	TABLE_SCHEMA='Production'
ORDER BY 
	TABLE_NAME;