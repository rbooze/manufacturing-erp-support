USE ProductionERP;
GO

-- Which customers are affected by the integration issue?
SELECT
    co.OrderNumber,
    c.CustomerName,
    p.ProductName,
    l.LotNumber,
	l.LotStatus,
    iq.ProcessingStatus,
    iq.ErrorMessage
FROM Inventory.CustomerOrder co
JOIN Master.Customer c
    ON co.CustomerID = c.CustomerID
JOIN Master.Product p
    ON co.ProductID = p.ProductID
JOIN Production.Lot l
    ON co.OrderID = l.OrderID
LEFT JOIN Inventory.ERPIntegrationQueue iq
    ON l.LotNumber = iq.ReferenceID
WHERE
    iq.ProcessingStatus = 'Failed';