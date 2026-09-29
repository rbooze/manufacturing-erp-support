USE ProductionERP;
GO

CREATE TABLE Master.Item
(
    ItemID              INT IDENTITY(1,1) PRIMARY KEY,
    ItemNumber          VARCHAR(20) NOT NULL UNIQUE,
    ItemDescription     VARCHAR(100) NOT NULL,
    Category            VARCHAR(50) NOT NULL,
    UnitOfMeasure       VARCHAR(10) NOT NULL,
    StandardCost        DECIMAL(12,2) NOT NULL,
    SellingPrice        DECIMAL(12,2) NOT NULL,
    IsActive            BIT NOT NULL DEFAULT 1,
    CreatedDate         DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);
GO

-- Extended property describing Master.Item
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Master list of manufactured finished goods.',
    @level0type = N'SCHEMA',
    @level0name = 'Master',
    @level1type = N'TABLE',
    @level1name = 'Item';
GO

CREATE TABLE Master.Machine
(
    MachineID           INT IDENTITY(1,1) PRIMARY KEY,
    MachineCode         VARCHAR(20) NOT NULL UNIQUE,
    MachineName         VARCHAR(100) NOT NULL,
    Department          VARCHAR(50) NOT NULL,
    MachineStatus       VARCHAR(20) NOT NULL,
    CommissionDate      DATE NOT NULL,
    CreatedDate         DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);
GO

-- Extended property describing Master.Machine
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Master list of machines in production.',
    @level0type = N'SCHEMA',
    @level0name = 'Master',
    @level1type = N'TABLE',
    @level1name = 'Machine';
GO

CREATE TABLE Master.Employee
(
    EmployeeID          INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeNumber      VARCHAR(20) NOT NULL UNIQUE,
    FirstName           VARCHAR(50) NOT NULL,
    LastName            VARCHAR(50) NOT NULL,
    JobTitle            VARCHAR(50) NOT NULL,
    Shift               VARCHAR(20) NOT NULL,
    IsActive            BIT NOT NULL DEFAULT 1,
    HireDate            DATE NOT NULL,
    CreatedDate         DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Master list of employees.',
    @level0type = N'SCHEMA',
    @level0name = 'Master',
    @level1type = N'TABLE',
    @level1name = 'Employee';
GO

SELECT *
FROM INFORMATION_SCHEMA.TABLES
WHERE 
	TABLE_SCHEMA='Master';

SELECT
TABLE_NAME,
COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE 
	TABLE_SCHEMA='Master'
ORDER BY 
	TABLE_NAME, 
	ORDINAL_POSITION;