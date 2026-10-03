SELECT
    l.LotNumber,
    l.LotStatus,
    ph.ProcessStatus AS 'Process History Status',
    q.Result AS 'Quality Result Status',
    e.ProcessingStatus AS 'ERP Queue Status',
    e.ErrorMessage
FROM Production.Lot l

LEFT JOIN Production.ProcessHistory ph
    ON l.LotID = ph.LotID

LEFT JOIN Production.QualityResult q
    ON l.LotID = q.LotID

LEFT JOIN Inventory.ERPIntegrationQueue e
    ON e.ReferenceID = l.LotNumber

WHERE 
    l.LotNumber = 'LOT-OPT-5003';