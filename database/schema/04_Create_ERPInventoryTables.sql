USE ProductionERP;
GO

CREATE TABLE Inventory.Warehouse
(
    WarehouseID        INT IDENTITY(1,1) PRIMARY KEY,
    WarehouseCode      VARCHAR(20) NOT NULL UNIQUE,
    WarehouseName      VARCHAR(100) NOT NULL,
    Location           VARCHAR(100) NULL,
    WarehouseType      VARCHAR(50) NOT NULL,
    CreatedDate        DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);
GO

CREATE TABLE Inventory.Stock
(
    StockID             INT IDENTITY(1,1) PRIMARY KEY,
    ProductID           INT NOT NULL,
    WarehouseID         INT NOT NULL,
    QuantityAvailable   INT NOT NULL,
    QuantityReserved    INT NOT NULL DEFAULT 0,
    LastUpdated         DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    CONSTRAINT FK_Stock_Product
        FOREIGN KEY(ProductID)
        REFERENCES Master.Product(ProductID),

    CONSTRAINT FK_Stock_Warehouse
        FOREIGN KEY(WarehouseID)
        REFERENCES Inventory.Warehouse(WarehouseID)
);
GO

CREATE TABLE Inventory.InventoryTransaction
(
    TransactionID       INT IDENTITY(1,1) PRIMARY KEY,
    LotID               INT NULL,
    ProductID           INT NOT NULL,
    WarehouseID         INT NOT NULL,
    TransactionType     VARCHAR(30) NOT NULL,
    Quantity            INT NOT NULL,
    TransactionStatus   VARCHAR(30) NOT NULL,
    SourceSystem        VARCHAR(50) NOT NULL,
    TransactionDate     DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    CONSTRAINT FK_Transaction_Lot
        FOREIGN KEY(LotID)
        REFERENCES Production.Lot(LotID),

    CONSTRAINT FK_Transaction_Product
        FOREIGN KEY(ProductID)
        REFERENCES Master.Product(ProductID),

    CONSTRAINT FK_Transaction_Warehouse
        FOREIGN KEY(WarehouseID)
        REFERENCES Inventory.Warehouse(WarehouseID)
);
GO

CREATE TABLE Inventory.CustomerOrder
(
    OrderID             INT IDENTITY(1,1) PRIMARY KEY,
    OrderNumber         VARCHAR(30) NOT NULL UNIQUE,
    CustomerID          INT NOT NULL,
    ProductID           INT NOT NULL,
    QuantityOrdered     INT NOT NULL,
    OrderStatus         VARCHAR(30) NOT NULL,
    OrderDate           DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    CONSTRAINT FK_Order_Customer
        FOREIGN KEY(CustomerID)
        REFERENCES Master.Customer(CustomerID),

    CONSTRAINT FK_Order_Product
        FOREIGN KEY(ProductID)
        REFERENCES Master.Product(ProductID)
);
GO

CREATE TABLE Inventory.ERPIntegrationQueue
(
    QueueID             INT IDENTITY(1,1) PRIMARY KEY,
    SourceSystem        VARCHAR(50) NOT NULL,
    TargetSystem        VARCHAR(50) NOT NULL,
    MessageType         VARCHAR(50) NOT NULL,
    ReferenceID         VARCHAR(50) NOT NULL,
    ProcessingStatus    VARCHAR(30) NOT NULL,
    ErrorMessage        VARCHAR(500) NULL,
    CreatedDate         DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    ProcessedDate       DATETIME2 NULL
);
GO

SELECT 
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE 
	TABLE_SCHEMA='Inventory'
ORDER BY 
	TABLE_NAME;