USE ProductionERP;
GO

DECLARE @Counter INT = 1;

WHILE @Counter <= 1000
BEGIN
    INSERT INTO Production.Lot
    (
        LotNumber,
        ProductID,
        CustomerID,
        QuantityStarted,
        QuantityCompleted,
        LotStatus,
        CreatedDate
    )
    VALUES
    (
        CONCAT(
            'LOT-',
            FORMAT(DATEADD(DAY,-(@Counter % 30),GETDATE()),'yyyyMMdd'),
            '-',
            RIGHT('0000' + CAST(@Counter AS VARCHAR(4)),4)
        ),

        CASE 
            WHEN @Counter % 3 = 0 THEN 1
            WHEN @Counter % 3 = 1 THEN 2
            ELSE 3
        END,

        CASE 
            WHEN @Counter % 3 = 0 THEN 1
            WHEN @Counter % 3 = 1 THEN 2
            ELSE 3
        END,

        50 + (@Counter % 50),

        CASE
            WHEN @Counter % 20 = 0 THEN NULL
            ELSE 50 + (@Counter % 50)
        END,

        CASE
            WHEN @Counter % 20 = 0 THEN 'Quality Hold'
            WHEN @Counter % 10 = 0 THEN 'Processing'
            ELSE 'Completed'
        END,

        DATEADD(DAY,-(@Counter % 30),GETDATE())
    );

    SET @Counter = @Counter + 1;
END;
GO

SELECT COUNT(*) AS TotalLots
FROM Production.Lot;

-- =============================================================

INSERT INTO Production.ProcessHistory
(
    LotID,
    ProcessStepID,
    EquipmentID,
    StartTime,
    EndTime,
    ProcessStatus,
    Notes
)
SELECT
    l.LotID,
    ps.ProcessStepID,

    CASE 
        WHEN l.ProductID = 1 THEN 1
        WHEN l.ProductID = 2 THEN 2
        ELSE 1
    END,

    DATEADD(HOUR, ps.StepNumber, l.CreatedDate),

    DATEADD(HOUR, ps.StepNumber + 2, l.CreatedDate),

    CASE
        WHEN l.LotStatus='Quality Hold'
             AND ps.ProcessStepID=5
        THEN 'Failed'

        ELSE 'Completed'
    END,

    CASE
        WHEN l.LotStatus='Quality Hold'
        THEN 'Quality investigation required'

        ELSE 'Normal processing'
    END

FROM Production.Lot l

CROSS JOIN Production.ProcessStep ps

WHERE l.LotID > 3;
GO

-- =============================================================

INSERT INTO Production.QualityResult
(
    LotID,
    TestType,
    MeasurementValue,
    SpecificationMin,
    SpecificationMax,
    Result
)
SELECT
    LotID,

    CASE
        WHEN ProductID=1 THEN 'Optical Performance'
        WHEN ProductID=2 THEN 'Electrical Resistance'
        ELSE 'Defect Density'
    END,

    CASE
        WHEN ProductID=3 
            THEN 50 + (LotID % 100)

        ELSE
            0.10 + ((LotID % 10)/100.0)

    END,

    0,

    CASE
        WHEN ProductID=3 THEN 100
        ELSE 1
    END,

    CASE
        WHEN LotID % 25 = 0
        THEN 'FAIL'
        ELSE 'PASS'
    END

FROM Production.Lot
WHERE 
	LotID > 3;
GO

SELECT COUNT(*) 
FROM Production.QualityResult;

SELECT COUNT(*) AS ProcessHistoryCount
FROM Production.ProcessHistory;

-- Find duplicates
SELECT
    LotID,
    ProcessStepID,
    COUNT(*) AS Occurrences
FROM Production.ProcessHistory
GROUP BY
    LotID,
    ProcessStepID
HAVING COUNT(*) > 1
ORDER BY Occurrences DESC;