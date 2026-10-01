USE ProductionERP;
GO

UPDATE Production.Lot
SET OrderID = 1
WHERE LotID = 1004;

UPDATE Production.Lot
SET OrderID = 2
WHERE LotID = 1002;

UPDATE Production.Lot
SET OrderID = 3
WHERE LotID = 1003;

UPDATE Production.Lot
SET OrderID = 4
WHERE LotID = 1001;

UPDATE Production.Lot
SET OrderID = 5
WHERE LotID = 999;

GO