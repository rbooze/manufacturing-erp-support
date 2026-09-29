USE ProductionERP;
GO


IF NOT EXISTS
(
    SELECT 1
    FROM Production.Lot
    WHERE LotNumber = 'LOT-GAAS-20260901'
)
BEGIN

INSERT INTO Production.Lot
(
    LotNumber,
    ProductID,
    CustomerID,
    QuantityStarted,
    QuantityCompleted,
    LotStatus
)
VALUES
(
    'LOT-GAAS-20260901',
    1,
    1,
    50,
    50,
    'Completed'
);

END
GO


IF NOT EXISTS
(
    SELECT 1
    FROM Production.Lot
    WHERE LotNumber = 'LOT-GAN-20260902'
)
BEGIN

INSERT INTO Production.Lot
(
    LotNumber,
    ProductID,
    CustomerID,
    QuantityStarted,
    QuantityCompleted,
    LotStatus
)
VALUES
(
    'LOT-GAN-20260902',
    2,
    2,
    75,
    75,
    'Completed'
);

END
GO


IF NOT EXISTS
(
    SELECT 1
    FROM Production.Lot
    WHERE LotNumber = 'LOT-INP-20260903'
)
BEGIN

INSERT INTO Production.Lot
(
    LotNumber,
    ProductID,
    CustomerID,
    QuantityStarted,
    QuantityCompleted,
    LotStatus
)
VALUES
(
    'LOT-INP-20260903',
    3,
    3,
    40,
    NULL,
    'Quality Hold'
);

END
GO

-- ========================================================

INSERT INTO Production.EpiwaferRun
(
    LotID,
    EquipmentID,
    OperatorID,
    RecipeName,
    StartTime,
    EndTime,
    RunStatus
)
VALUES
(
    1,
    1,
    4,
    'VCSEL_GAAS_STANDARD',
    '2026-09-01 08:00',
    '2026-09-02 03:00',
    'Completed'
),
(
    2,
    2,
    4,
    'GAN_POWER_HIGH_VOLTAGE',
    '2026-09-02 08:00',
    '2026-09-03 04:00',
    'Completed'
),
(
    3,
    1,
    4,
    'INP_PHOTONIC_HIGH_SPEED',
    '2026-09-03 08:00',
    NULL,
    'Running'
);
GO

-- ========================================================

INSERT INTO Production.ProcessStep
(
    StepNumber,
    StepName,
    Description
)
VALUES
(
    10,
    'Substrate Preparation',
    'Prepare semiconductor substrate'
),
(
    20,
    'Epitaxial Growth',
    'Grow semiconductor layers using reactor'
),
(
    30,
    'Wafer Inspection',
    'Inspect wafer surface defects'
),
(
    40,
    'Metrology Testing',
    'Measure layer thickness and characteristics'
),
(
    50,
    'Electrical Testing',
    'Validate electrical properties'
);
GO

-- ========================================================

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
VALUES
(
    1,
    1,
    1,
    '2026-09-01 08:00',
    '2026-09-01 10:00',
    'Completed',
    'Normal operation'
),
(
    1,
    2,
    1,
    '2026-09-01 10:00',
    '2026-09-02 03:00',
    'Completed',
    'Growth completed successfully'
),
(
    2,
    2,
    2,
    '2026-09-02 08:00',
    '2026-09-03 04:00',
    'Completed',
    'Recipe completed'
),
(
    3,
    2,
    1,
    '2026-09-03 08:00',
    NULL,
    'Running',
    'Monitoring reactor conditions'
);
GO

-- ========================================================

INSERT INTO Production.QualityResult
(
    LotID,
    TestType,
    MeasurementValue,
    SpecificationMin,
    SpecificationMax,
    Result
)
VALUES
(
    1,
    'Layer Thickness',
    2.50,
    2.40,
    2.60,
    'PASS'
),
(
    2,
    'Electrical Resistance',
    0.15,
    0.10,
    0.20,
    'PASS'
),
(
    3,
    'Defect Density',
    125.00,
    0,
    100,
    'FAIL'
);
GO

SELECT
    l.LotNumber,
    ps.StepName,
    ph.ProcessStatus
FROM Production.ProcessHistory ph WITH (NOLOCK)
JOIN Production.Lot l WITH (NOLOCK)
    ON ph.LotID = l.LotID
JOIN Production.ProcessStep ps WITH (NOLOCK)
    ON ph.ProcessStepID = ps.ProcessStepID;

SELECT
    l.LotNumber,
    p.ProductName,
    e.EquipmentName,
    ps.StepNumber,
    ps.StepName,
    ph.ProcessStatus,
    ph.Notes
FROM Production.ProcessHistory ph
JOIN Production.Lot l
    ON ph.LotID = l.LotID
JOIN Master.Product p
    ON l.ProductID = p.ProductID
JOIN Production.ProcessStep ps
    ON ph.ProcessStepID = ps.ProcessStepID
LEFT JOIN Master.Equipment e
    ON ph.EquipmentID = e.EquipmentID
ORDER BY l.LotNumber, ps.StepNumber;