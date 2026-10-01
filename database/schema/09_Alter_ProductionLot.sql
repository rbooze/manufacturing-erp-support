ALTER TABLE Production.Lot
ADD OrderID INT NULL;
GO

ALTER TABLE Production.Lot
ADD CONSTRAINT FK_Lot_CustomerOrder
FOREIGN KEY (OrderID)
REFERENCES Inventory.CustomerOrder(OrderID);
GO