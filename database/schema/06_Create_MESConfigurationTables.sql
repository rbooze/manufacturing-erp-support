USE ProductionERP;
GO

CREATE TABLE Production.ProductRecipe
(
    RecipeID            INT IDENTITY(1,1) PRIMARY KEY,
    ProductID           INT NOT NULL,
    RecipeName          VARCHAR(100) NOT NULL,
    RecipeVersion       VARCHAR(20) NOT NULL,
    RecipeStatus        VARCHAR(30) NOT NULL,
    EffectiveDate       DATE NOT NULL,
    CreatedDate         DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    CONSTRAINT FK_ProductRecipe_Product
        FOREIGN KEY(ProductID)
        REFERENCES Master.Product(ProductID)
);
GO

CREATE TABLE Production.ProcessRoute
(
    RouteID             INT IDENTITY(1,1) PRIMARY KEY,
    ProductID           INT NOT NULL,
    RouteName           VARCHAR(100) NOT NULL,
    Version             VARCHAR(20) NOT NULL,
    Status              VARCHAR(30) NOT NULL,

    CONSTRAINT FK_ProcessRoute_Product
        FOREIGN KEY(ProductID)
        REFERENCES Master.Product(ProductID)
);
GO

CREATE TABLE Production.ProcessRouteStep
(
    RouteStepID         INT IDENTITY(1,1) PRIMARY KEY,
    RouteID             INT NOT NULL,
    ProcessStepID       INT NOT NULL,
    SequenceNumber      INT NOT NULL,
    Required            BIT NOT NULL DEFAULT 1,

    CONSTRAINT FK_RouteStep_Route
        FOREIGN KEY(RouteID)
        REFERENCES Production.ProcessRoute(RouteID),

    CONSTRAINT FK_RouteStep_ProcessStep
        FOREIGN KEY(ProcessStepID)
        REFERENCES Production.ProcessStep(ProcessStepID)
);
GO

CREATE TABLE Production.RecipeParameter
(
    ParameterID         INT IDENTITY(1,1) PRIMARY KEY,
    RecipeID            INT NOT NULL,
    ParameterName       VARCHAR(100) NOT NULL,
    TargetValue         DECIMAL(12,4) NOT NULL,
    MinimumValue        DECIMAL(12,4) NULL,
    MaximumValue        DECIMAL(12,4) NULL,

    CONSTRAINT FK_RecipeParameter_Recipe
        FOREIGN KEY(RecipeID)
        REFERENCES Production.ProductRecipe(RecipeID)
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