USE ProductionERP;
GO


INSERT INTO Master.Material
(
    MaterialName,
    MaterialType,
    ChemicalFormula,
    Description
)
VALUES
(
    'Gallium Arsenide',
    'Compound Semiconductor',
    'GaAs',
    'Used for RF, optical, and sensing applications'
),
(
    'Gallium Nitride',
    'Compound Semiconductor',
    'GaN',
    'Used for power electronics and high frequency applications'
),
(
    'Indium Phosphide',
    'Compound Semiconductor',
    'InP',
    'Used for photonics and optical communication applications'
);
GO

-- ======================================================================

INSERT INTO Master.Product
(
    ProductNumber,
    ProductName,
    MaterialID,
    Application,
    TechnologyPlatform,
    WaferSizeMM
)
VALUES
(
    'GAAS-VCSEL-001',
    'VCSEL Optical Epiwafer',
    1,
    'AI Datacenter Sensing',
    'GaAs VCSEL',
    150
),
(
    'GAN-POWER-001',
    'High Power GaN Epiwafer',
    2,
    'EV Power Electronics',
    'GaN Power',
    150
),
(
    'INP-PHOTONIC-001',
    'InP Photonic Epiwafer',
    3,
    'AI Optical Networking',
    'InP Photonics',
    100
);
GO

-- ======================================================================

INSERT INTO Master.Customer
(
    CustomerNumber,
    CustomerName,
    Industry,
    Region
)
VALUES
(
    'CUST-1001',
    'Optical Computing Systems',
    'AI Datacenter',
    'North America'
),
(
    'CUST-1002',
    'EV Semiconductor Solutions',
    'Automotive',
    'North America'
),
(
    'CUST-1003',
    'Photonics Technology Group',
    'Communications',
    'Europe'
);
GO

-- ======================================================================

INSERT INTO Master.Equipment
(
    EquipmentCode,
    EquipmentName,
    EquipmentType,
    Location,
    EquipmentStatus
)
VALUES
(
    'MOCVD-001',
    'MOCVD Reactor 1',
    'Epitaxy Reactor',
    'Fab Area A',
    'Running'
),
(
    'MOCVD-002',
    'MOCVD Reactor 2',
    'Epitaxy Reactor',
    'Fab Area A',
    'Running'
),
(
    'MET-001',
    'Wafer Metrology System',
    'Measurement',
    'Quality Lab',
    'Running'
),
(
    'INS-001',
    'Wafer Inspection Tool',
    'Inspection',
    'Quality Lab',
    'Running'
);
GO

-- ======================================================================

INSERT INTO Master.Employee
(
    EmployeeNumber,
    FirstName,
    LastName,
    RoleName,
    Department,
    Shift,
    HireDate
)
VALUES
(
    'EMP-1001',
    'Sarah',
    'Miller',
    'Process Engineer',
    'Manufacturing Engineering',
    'Day',
    '2022-05-10'
),
(
    'EMP-1002',
    'James',
    'Chen',
    'Equipment Technician',
    'Equipment Engineering',
    'Night',
    '2021-03-15'
),
(
    'EMP-1003',
    'Maria',
    'Rodriguez',
    'Quality Engineer',
    'Quality',
    'Day',
    '2023-01-20'
),
(
    'EMP-1004',
    'David',
    'Wilson',
    'Manufacturing Operator',
    'Production',
    'Night',
    '2024-02-01'
);
GO

-- ======================================================================

SELECT 'Materials' AS TableName, COUNT(*) AS Records
FROM Master.Material

UNION ALL

SELECT 'Products', COUNT(*)
FROM Master.Product

UNION ALL

SELECT 'Customers', COUNT(*)
FROM Master.Customer

UNION ALL

SELECT 'Equipment', COUNT(*)
FROM Master.Equipment

UNION ALL

SELECT 'Employees', COUNT(*)
FROM Master.Employee;

SELECT
	p.ProductNumber,
	p.ProductName,
	m.MaterialName
FROM Master.Product p WITH (NOLOCK)
JOIN Master.Material m WITH (NOLOCK)
	ON p.MaterialID=m.MaterialID;