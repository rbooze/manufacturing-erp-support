USE ProductionERP;
GO

CREATE SCHEMA Master;
GO

CREATE SCHEMA Production;
GO

CREATE SCHEMA Inventory;
GO

CREATE SCHEMA Support;
GO

CREATE SCHEMA Logging;
GO

SELECT name
FROM sys.schemas
ORDER BY name;