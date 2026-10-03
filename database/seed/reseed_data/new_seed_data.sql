USE ProductionERP;
GO

-- Master Data --
-- Materials
INSERT INTO Master.Material
(MaterialName, MaterialType, ChemicalFormula, Description, IsActive, CreatedDate)
VALUES
('Gallium Nitride','Compound Semiconductor','GaN','GaN wafer material',1,GETDATE()),
('Silicon Carbide','Compound Semiconductor','SiC','Power semiconductor substrate',1,GETDATE()),
('Indium Phosphide','Compound Semiconductor','InP','Optical semiconductor material',1,GETDATE());
GO

-- Customers
INSERT INTO Master.Customer
(CustomerNumber, CustomerName, Industry, Region, CreatedDate)
VALUES
('CUST-001','AI Semiconductor Corp','Artificial Intelligence','North America',GETDATE()),
('CUST-002','EV Power Systems','Automotive','North America',GETDATE()),
('CUST-003','Vision Technologies','Optical Systems','Europe',GETDATE());
GO

-- Products
DECLARE @GaN INT;
DECLARE @SiC INT;
DECLARE @InP INT;

SELECT @GaN = MaterialID 
FROM Master.Material
WHERE MaterialName='Gallium Nitride';

SELECT @SiC = MaterialID 
FROM Master.Material
WHERE MaterialName='Silicon Carbide';

SELECT @InP = MaterialID 
FROM Master.Material
WHERE MaterialName='Indium Phosphide';

INSERT INTO Master.Product
(ProductNumber,ProductName,MaterialID,Application,TechnologyPlatform,WaferSizeMM,IsActive,CreatedDate)
VALUES
('GAN-001','GaN Power Device',@GaN,'Power Electronics','GaN',150,1,GETDATE()),
('SIC-001','SiC EV Module',@SiC,'Electric Vehicle','SiC',150,1,GETDATE()),
('OPT-001','Optical Sensor',@InP,'Face Recognition','InP',100,1,GETDATE());
GO

-- Employees
INSERT INTO Master.Employee
(EmployeeNumber,FirstName,LastName,RoleName,Department,Shift,IsActive,HireDate,CreatedDate)
VALUES
('EMP-001','John','Smith','Process Engineer','Manufacturing','Day',1,'2020-01-15',GETDATE()),
('EMP-002','Mary','Jones','Equipment Technician','Maintenance','Night',1,'2021-03-10',GETDATE()),
('EMP-003','Robert','Davis','Quality Engineer','Quality','Day',1,'2019-06-20',GETDATE());
GO

-- Equipment
INSERT INTO Master.Equipment
(EquipmentCode,EquipmentName,EquipmentType,Location,EquipmentStatus,InstalledDate,CreatedDate)
VALUES
('EQ-001','Epitaxy Reactor 01','Epitaxy Reactor','Fab A','Running','2022-01-01',GETDATE()),
('EQ-002','Inspection Station 01','Inspection','Fab A','Running','2022-02-01',GETDATE()),
('EQ-003','Test Station 01','Electrical Test','Fab B','Running','2022-03-01',GETDATE());
GO

-- Process Steps
INSERT INTO Production.ProcessStep
(StepNumber,StepName,Description,IsActive)
VALUES
(10,'Wafer Preparation','Prepare substrate wafer',1),
(20,'Epitaxy Growth','Grow semiconductor layers',1),
(30,'Inspection','Visual and dimensional inspection',1),
(40,'Electrical Test','Electrical characterization',1),
(50,'Final Release','Production release',1);
GO

-- Customer Orders
INSERT INTO Inventory.CustomerOrder
(OrderNumber,CustomerID,ProductID,QuantityOrdered,OrderStatus,OrderDate)
VALUES
('PO-20261001-001',1,1,100,'Completed','2026-10-01'),
('PO-20261001-002',2,2,150,'Released','2026-10-01'),
('PO-20261001-003',3,3,75,'Released','2026-10-01');

-- Lots
INSERT INTO Production.Lot
(LotNumber,ProductID,CustomerID,QuantityStarted,QuantityCompleted,LotStatus,CreatedDate,CompletedDate,OrderID)
VALUES
('LOT-GAN-5001',1,1,100,98,'Completed',GETDATE(),GETDATE(),1),
('LOT-SIC-5002',2,2,150,NULL,'Processing',GETDATE(),NULL,2),
('LOT-OPT-5003',3,3,75,70,'Quality Hold',GETDATE(),NULL,3);

-- Process History
DECLARE @Lot1 INT;
DECLARE @Lot2 INT;
DECLARE @Lot3 INT;

DECLARE @Step1 INT;
DECLARE @Step2 INT;
DECLARE @Step3 INT;
DECLARE @Step4 INT;

DECLARE @Eq1 INT;
DECLARE @Eq2 INT;
DECLARE @Eq3 INT;

SELECT @Lot1 = LotID 
FROM Production.Lot 
WHERE LotNumber = 'LOT-GAN-5001';

SELECT @Lot2 = LotID 
FROM Production.Lot 
WHERE LotNumber = 'LOT-SIC-5002';

SELECT @Lot3 = LotID 
FROM Production.Lot 
WHERE LotNumber = 'LOT-OPT-5003';

SELECT @Step1 = ProcessStepID
FROM Production.ProcessStep
WHERE StepName = 'Wafer Preparation';

SELECT @Step2 = ProcessStepID
FROM Production.ProcessStep
WHERE StepName = 'Epitaxy Growth';

SELECT @Step3 = ProcessStepID
FROM Production.ProcessStep
WHERE StepName = 'Inspection';

SELECT @Step4 = ProcessStepID
FROM Production.ProcessStep
WHERE StepName = 'Electrical Test';

SELECT @Eq1 = EquipmentID
FROM Master.Equipment
WHERE EquipmentCode = 'EQ-001';

SELECT @Eq2 = EquipmentID
FROM Master.Equipment
WHERE EquipmentCode = 'EQ-002';

SELECT @Eq3 = EquipmentID
FROM Master.Equipment
WHERE EquipmentCode = 'EQ-003';

INSERT INTO Production.ProcessHistory
(LotID, ProcessStepID, EquipmentID, StartTime, EndTime, ProcessStatus, Notes)
VALUES

-- Completed lot
(@Lot1,@Step1,@Eq1,
DATEADD(hour,-8,GETDATE()),
DATEADD(hour,-7,GETDATE()),
'Complete',
'Wafer preparation completed'),

(@Lot1,@Step2,@Eq1,
DATEADD(hour,-7,GETDATE()),
DATEADD(hour,-5,GETDATE()),
'Complete',
'Epitaxy growth completed'),

(@Lot1,@Step3,@Eq2,
DATEADD(hour,-5,GETDATE()),
DATEADD(hour,-4,GETDATE()),
'Complete',
'Inspection passed'),

-- Processing lot
(@Lot2,@Step1,@Eq1,
GETDATE(),
NULL,
'Running',
'Currently in wafer preparation'),

-- Quality issue lot
(@Lot3,@Step4,@Eq3,
DATEADD(hour,-3,GETDATE()),
DATEADD(hour,-2,GETDATE()),
'Failed',
'Electrical test failure detected');
GO

-- Quality Results
DECLARE @LotCompleted INT;
DECLARE @LotHold INT;

SELECT @LotCompleted = LotID
FROM Production.Lot
WHERE LotNumber = 'LOT-GAN-5001';

SELECT @LotHold = LotID
FROM Production.Lot
WHERE LotNumber = 'LOT-OPT-5003';

INSERT INTO Production.QualityResult
(
    LotID,
    TestType,
    MeasurementValue,
    SpecificationMin,
    SpecificationMax,
    Result,
    TestedDate
)
VALUES
(
    @LotCompleted,
    'Electrical Test',
    98.5,
    95.0,
    100.0,
    'Pass',
    GETDATE()
),
(
    @LotHold,
    'Electrical Test',
    91.0,
    95.0,
    100.0,
    'Fail',
    GETDATE()
);

GO