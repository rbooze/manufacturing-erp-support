USE ProductionERP;
GO

CREATE TABLE Master.Material
(
    MaterialID          INT IDENTITY(1,1) PRIMARY KEY,
    MaterialName        VARCHAR(100) NOT NULL,
    MaterialType        VARCHAR(50) NOT NULL,
    ChemicalFormula     VARCHAR(50) NULL,
    Description         VARCHAR(250) NULL,
    IsActive            BIT NOT NULL DEFAULT 1,
    CreatedDate         DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);
GO

CREATE TABLE Master.Product
(
    ProductID           INT IDENTITY(1,1) PRIMARY KEY,
    ProductNumber       VARCHAR(30) NOT NULL UNIQUE,
    ProductName         VARCHAR(100) NOT NULL,
    MaterialID          INT NOT NULL,
    Application         VARCHAR(100) NOT NULL,
    TechnologyPlatform  VARCHAR(50) NOT NULL,
    WaferSizeMM         INT NOT NULL,
    IsActive            BIT NOT NULL DEFAULT 1,
    CreatedDate         DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    CONSTRAINT FK_Product_Material
        FOREIGN KEY(MaterialID)
        REFERENCES Master.Material(MaterialID)
);
GO

CREATE TABLE Master.Customer
(
    CustomerID          INT IDENTITY(1,1) PRIMARY KEY,
    CustomerNumber      VARCHAR(30) NOT NULL UNIQUE,
    CustomerName        VARCHAR(100) NOT NULL,
    Industry            VARCHAR(50) NOT NULL,
    Region              VARCHAR(50) NULL,
    CreatedDate         DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);
GO

CREATE TABLE Master.Equipment
(
    EquipmentID         INT IDENTITY(1,1) PRIMARY KEY,
    EquipmentCode       VARCHAR(30) NOT NULL UNIQUE,
    EquipmentName       VARCHAR(100) NOT NULL,
    EquipmentType       VARCHAR(50) NOT NULL,
    Location            VARCHAR(50) NOT NULL,
    EquipmentStatus     VARCHAR(30) NOT NULL,
    InstalledDate       DATE NULL,
    CreatedDate         DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);
GO

CREATE TABLE Master.Employee
(
    EmployeeID          INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeNumber      VARCHAR(30) NOT NULL UNIQUE,
    FirstName           VARCHAR(50) NOT NULL,
    LastName            VARCHAR(50) NOT NULL,
    RoleName            VARCHAR(100) NOT NULL,
    Department          VARCHAR(50) NOT NULL,
    Shift               VARCHAR(20) NOT NULL,
    IsActive            BIT NOT NULL DEFAULT 1,
    HireDate            DATE NOT NULL,
    CreatedDate         DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);
GO

SELECT 
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE 
	TABLE_SCHEMA='Master'
ORDER BY 
	TABLE_NAME;