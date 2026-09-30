# ProductionERP Data Dictionary

**Project:** ProductionERP - Semiconductor MES/ERP Support Simulation

**Author:** Rodney Booze

**Purpose**

ProductionERP is a simulated semiconductor manufacturing environment designed to prepare for an Application Support Engineer role supporting Manufacturing Execution Systems (MES) and Microsoft Dynamics NAV ERP.

The database models:

- Manufacturing execution
- ERP inventory posting
- Equipment maintenance
- Quality management
- Integration monitoring
- Application support

---

# Database Summary

| Schema | Description |
|---------|-------------|
| Master | Master reference data |
| Production | MES manufacturing execution |
| Inventory | ERP inventory and integration |
| Logging | Interface and application logging |
| Maintenance | Equipment reliability |
| Support | Application support operations |

---

# Master Schema

---

## Master.Product

### Purpose

Stores the semiconductor products manufactured by the company.

### Grain

One row per product.

### Primary Key

ProductID

### Foreign Keys

None

### Relationships

- Production.Lot
- Production.ProductRecipe
- Production.ProcessRoute
- Inventory.InventoryTransaction
- Inventory.Stock

| Column | Type | Null | Description |
|---------|------|------|-------------|
| ProductID | INT | No | Primary Key |
| ProductCode | VARCHAR(30) | No | ERP product number |
| ProductName | VARCHAR(100) | No | Product description |
| ProductFamily | VARCHAR(50) | Yes | Product category |
| UnitOfMeasure | VARCHAR(20) | No | Manufacturing unit |

### Typical Support Questions

- Does this product exist?
- Is the correct product assigned to the lot?
- Is the ERP item number correct?

---

## Master.Customer

### Purpose

Stores manufacturing customers.

### Grain

One row per customer.

### Primary Key

CustomerID

### Relationships

- Production.Lot

| Column | Type | Null | Description |
|---------|------|------|-------------|
| CustomerID | INT | No | Primary Key |
| CustomerCode | VARCHAR(30) | No | ERP customer number |
| CustomerName | VARCHAR(100) | No | Customer name |
| Country | VARCHAR(50) | Yes | Customer location |

### Typical Support Questions

- Which customer owns this lot?
- Which orders are affected?

---

## Master.Equipment

### Purpose

Manufacturing equipment used during production.

### Grain

One row per machine.

### Relationships

- Production.ProcessHistory
- Maintenance.EquipmentEvent
- Maintenance.EquipmentAlarm
- Maintenance.WorkOrder

### Typical Support Questions

- Which equipment processed this lot?
- Has this machine experienced alarms?
- Was maintenance performed recently?

---

## Master.Employee

### Purpose

Employees using the manufacturing system.

### Relationships

- Maintenance.WorkOrder
- Support.UserSession
- Support.Incident

### Typical Support Questions

- Which operator released the lot?
- Which technician completed the repair?

---

# Production Schema (MES)

The Production schema represents the Manufacturing Execution System (MES).

It tracks:

- Manufacturing lots
- Production execution
- Process routing
- Recipes
- Equipment processing
- Quality results

The MES is responsible for recording what happened on the manufacturing floor.

---

# Production.Lot

## Purpose

Represents a manufacturing lot (batch) of semiconductor material moving through production.

Examples:

- GaAs optical wafer lot
- GaN power semiconductor lot
- InP photonic wafer lot

## Business Grain

One row per manufacturing lot.

## Primary Key

LotID

## Foreign Keys

- ProductID → Master.Product
- CustomerID → Master.Customer

## Relationships

| Related Table | Relationship |
|---|---|
|Master.Product|Identifies manufactured product|
|Master.Customer|Identifies customer ownership|
|Production.ProcessHistory|Tracks manufacturing execution|
|Inventory.InventoryTransaction|Tracks ERP inventory movement|
|Inventory.ERPIntegrationQueue|Tracks MES-to-ERP transfer|

## Columns

| Column | Data Type | Nullable | Description |
|---|---|---|---|
|LotID|INT|No|Unique lot identifier|
|LotNumber|VARCHAR(40)|No|Manufacturing lot number|
|ProductID|INT|No|Product being manufactured|
|CustomerID|INT|No|Customer associated with lot|
|QuantityStarted|INT|No|Starting quantity|
|QuantityCompleted|INT|Yes|Completed quantity|
|LotStatus|VARCHAR(30)|No|Current production status|
|CreatedDate|DATETIME2|No|Lot creation timestamp|
|CompletedDate|DATETIME2|Yes|Production completion timestamp|

## Example Status Values

|Status|Meaning|
|---|---|
|Created|Lot created|
|Processing|Currently manufacturing|
|Completed|Production finished|
|Quality Hold|Waiting for inspection|
|Rejected|Failed quality|

## Typical Support Questions

- Did production complete?
- Which customer is affected?
- Why is inventory missing?
- Did this lot enter quality hold?
- Which process steps were completed?

---

# Production.ProcessStep

## Purpose

Defines standard manufacturing operations.

Examples:

- Substrate Preparation
- Epitaxial Growth
- Inspection
- Metrology
- Electrical Testing

## Business Grain

One row per manufacturing operation.

## Primary Key

ProcessStepID

## Relationships

| Related Table | Relationship |
|---|---|
|Production.ProcessHistory|Actual execution|
|Production.ProcessRouteStep|Required route sequence|

## Columns

|Column|Data Type|Nullable|Description|
|---|---|---|---|
|ProcessStepID|INT|No|Primary key|
|StepNumber|INT|No|Manufacturing sequence number|
|StepName|VARCHAR(100)|No|Operation name|
|Description|VARCHAR(500)|Yes|Step details|
|IsActive|BIT|No|Whether step is active|

## Typical Support Questions

- Is the correct process step configured?
- Did the lot skip a required operation?
- Is the MES route correct?

---

# Production.ProcessHistory

## Purpose

Records actual manufacturing execution.

This is one of the most important MES transaction tables.

## Business Grain

One row per lot and process step execution.

## Primary Key

ProcessHistoryID

## Foreign Keys

- LotID → Production.Lot
- ProcessStepID → Production.ProcessStep
- EquipmentID → Master.Equipment

## Relationships

|Related Table|Purpose|
|---|---|
|Production.Lot|Identifies material|
|Production.ProcessStep|Identifies operation|
|Master.Equipment|Identifies machine used|
|Maintenance.EquipmentAlarm|Investigates failures|
|QualityResult|Links inspection results|

## Columns

|Column|Data Type|Nullable|Description|
|---|---|---|---|
|ProcessHistoryID|INT|No|Primary key|
|LotID|INT|No|Manufacturing lot|
|ProcessStepID|INT|No|Operation performed|
|EquipmentID|INT|No|Machine used|
|StartTime|DATETIME2|No|Process start|
|EndTime|DATETIME2|Yes|Process completion|
|ProcessStatus|VARCHAR(30)|No|Execution result|
|Notes|VARCHAR(500)|Yes|Operator comments|

## Typical Support Questions

- Did the lot complete all required steps?
- Where did production stop?
- Which equipment processed the lot?
- Was the same step executed twice?

---

# Production.EpiwaferRun

## Purpose

Stores epitaxial growth runs.

Used for semiconductor wafer manufacturing traceability.

## Business Grain

One row per epitaxial production run.

## Typical Support Questions

- Which reactor processed this material?
- What growth run created this wafer?
- Was the correct recipe used?

---

# Production.QualityResult

## Purpose

Stores inspection and test results.

Examples:

- Defect density
- Electrical resistance
- Optical performance

## Business Grain

One row per lot quality measurement.

## Relationships

|Related Table|Purpose|
|---|---|
|Production.Lot|Material tested|
|Production.ProcessHistory|Process traceability|

## Columns

|Column|Data Type|Nullable|Description|
|---|---|---|---|
|QualityResultID|INT|No|Primary key|
|LotID|INT|No|Tested lot|
|TestType|VARCHAR(100)|No|Inspection type|
|MeasurementValue|DECIMAL|No|Measured value|
|SpecificationMin|DECIMAL|Yes|Lower limit|
|SpecificationMax|DECIMAL|Yes|Upper limit|
|Result|VARCHAR(20)|No|PASS/FAIL|

## Typical Support Questions

- Why did yield decrease?
- Which lots failed inspection?
- Did failures correlate with equipment events?

---

# Production.ProductRecipe

## Purpose

Defines manufacturing recipes assigned to products.

A recipe represents the expected manufacturing parameters.

## Business Grain

One row per product recipe version.

## Typical Support Questions

- Was the correct recipe used?
- Is the recipe active?
- Did a recipe change cause failures?

---

# Production.ProcessRoute

## Purpose

Defines the manufacturing path for a product.

Example:

GaN route:

1. Substrate Preparation
2. Epitaxial Growth
3. Inspection
4. Testing

## Business Grain

One row per production route.

---

# Production.ProcessRouteStep

## Purpose

Maps process steps to a production route.

Defines the required manufacturing sequence.

## Business Grain

One row per route step.

## Typical Support Questions

- Was a step missing?
- Did MES follow the correct route?
- Was an operation performed out of order?

---

# Production.RecipeParameter

## Purpose

Stores manufacturing recipe settings.

Examples:

- Temperature
- Pressure
- Growth time
- Gas flow

## Business Grain

One row per recipe parameter.

## Typical Support Questions

- Did a machine exceed limits?
- Was the recipe configured correctly?
- Did parameter changes affect yield?

---

# Inventory Schema (ERP / Dynamics NAV)

The Inventory schema represents ERP inventory processing.

In a typical MES → ERP integration flow:

```
Production.Lot
        |
        v
ERPIntegrationQueue
        |
        v
InventoryTransaction
        |
        v
Stock Balance
```

The MES records manufacturing completion.  
The ERP system records inventory ownership and availability.

---

# Inventory.Warehouse

## Purpose

Stores inventory locations used by ERP.

Examples:

- Finished Goods Warehouse
- Quality Hold Area
- Raw Material Storage

## Business Grain

One row per inventory location.

## Primary Key

WarehouseID

## Relationships

| Related Table | Relationship |
|---|---|
|Inventory.InventoryTransaction|Where inventory movement occurred|
|Inventory.Stock|Current inventory balance|

## Columns

| Column | Data Type | Nullable | Description |
|---|---|---|---|
|WarehouseID|INT|No|Primary key|
|WarehouseCode|VARCHAR(30)|No|ERP warehouse identifier|
|WarehouseName|VARCHAR(100)|No|Warehouse description|
|Location|VARCHAR(100)|Yes|Physical location|
|WarehouseType|VARCHAR(50)|Yes|Warehouse classification|

## Example Values

|Warehouse|Purpose|
|---|---|
|FG01|Finished Goods|
|QH01|Quality Hold|
|RM01|Raw Materials|

## Typical Support Questions

- Where is inventory stored?
- Was material posted to the correct location?
- Why is available inventory different from MES?

---

# Inventory.InventoryTransaction

## Purpose

Records inventory movements in ERP.

This represents the ERP equivalent of a production receipt, adjustment, or transfer.

## Business Grain

One row per inventory movement transaction.

## Primary Key

InventoryTransactionID

## Foreign Keys

- LotID → Production.Lot
- ProductID → Master.Product
- WarehouseID → Inventory.Warehouse

## Relationships

| Related Table | Purpose |
|---|---|
|Production.Lot|Source manufacturing lot|
|Master.Product|Item being moved|
|Inventory.Warehouse|Inventory destination|
|Inventory.Stock|Updates inventory balance|

## Columns

| Column | Data Type | Nullable | Description |
|---|---|---|---|
|InventoryTransactionID|INT|No|Primary key|
|LotID|INT|No|Manufacturing lot|
|ProductID|INT|No|ERP item|
|WarehouseID|INT|No|Inventory location|
|TransactionType|VARCHAR(50)|No|Receipt, issue, transfer|
|Quantity|INT|No|Inventory quantity|
|TransactionStatus|VARCHAR(30)|No|Posted, failed, pending|
|SourceSystem|VARCHAR(50)|No|Originating system|

## Example Transaction Types

|Transaction|Description|
|---|---|
|Production Receipt|Finished production entered into ERP|
|Inventory Adjustment|Quantity correction|
|Transfer|Movement between warehouses|

## Typical Support Questions

- Why is inventory missing?
- Did NAV post the production receipt?
- Was the wrong quantity posted?
- Did duplicate inventory occur?

---

# Inventory.Stock

## Purpose

Stores current inventory balances.

This represents what ERP users see as available inventory.

## Business Grain

One row per product and warehouse combination.

## Primary Key

StockID

## Foreign Keys

- ProductID → Master.Product
- WarehouseID → Inventory.Warehouse

## Columns

| Column | Data Type | Nullable | Description |
|---|---|---|---|
|StockID|INT|No|Primary key|
|ProductID|INT|No|ERP item|
|WarehouseID|INT|No|Inventory location|
|QuantityAvailable|INT|No|Available inventory|
|QuantityReserved|INT|No|Allocated inventory|

## Typical Support Questions

- Why does ERP show zero inventory?
- Does warehouse stock match production?
- Is inventory reserved incorrectly?

---

# Inventory.ERPIntegrationQueue

## Purpose

Tracks messages sent between MES and ERP.

This is one of the most important troubleshooting tables.

A failed queue message can prevent manufacturing activity from appearing in Dynamics NAV.

## Business Grain

One row per integration message.

## Primary Key

ERPIntegrationID

## Integration Flow

```
MES
 |
 v
ERPIntegrationQueue
 |
 v
Dynamics NAV
```

## Columns

| Column | Data Type | Nullable | Description |
|---|---|---|---|
|ERPIntegrationID|INT|No|Primary key|
|SourceSystem|VARCHAR(50)|No|Sending application|
|TargetSystem|VARCHAR(50)|No|Receiving application|
|MessageType|VARCHAR(100)|No|Business transaction type|
|ReferenceID|VARCHAR(50)|No|Lot/order reference|
|ProcessingStatus|VARCHAR(30)|No|Queue status|
|ErrorMessage|VARCHAR(1000)|Yes|Failure details|

## Example Status Values

|Status|Meaning|
|---|---|
|Pending|Waiting for processing|
|Processed|Successfully completed|
|Failed|Processing error|

## Typical Support Questions

- Why did MES data not reach NAV?
- Which messages failed overnight?
- Can the transaction be reprocessed?
- Is the failure caused by data or ERP configuration?

---

# Common ERP Investigation Query Patterns

## Find completed MES lots missing from ERP

```sql
SELECT
    l.LotNumber,
    l.LotStatus
FROM Production.Lot l
LEFT JOIN Inventory.InventoryTransaction t
    ON l.LotID = t.LotID
WHERE
    l.LotStatus = 'Completed'
    AND t.InventoryTransactionID IS NULL;
```

---

## Find failed ERP interface messages

```sql
SELECT
    ReferenceID,
    MessageType,
    ProcessingStatus,
    ErrorMessage
FROM Inventory.ERPIntegrationQueue
WHERE ProcessingStatus = 'Failed';
```

---

## Trace a lot from MES to ERP

```sql
SELECT
    l.LotNumber,
    p.ProductName,
    q.ProcessingStatus,
    t.TransactionStatus
FROM Production.Lot l

JOIN Master.Product p
    ON l.ProductID = p.ProductID

LEFT JOIN Inventory.ERPIntegrationQueue q
    ON l.LotNumber = q.ReferenceID

LEFT JOIN Inventory.InventoryTransaction t
    ON l.LotID = t.LotID;
```

---

# Interview Notes

A strong Application Support Engineer approach:

1. Verify the MES transaction exists.
2. Confirm the integration message was generated.
3. Review queue status and errors.
4. Validate ERP posting.
5. Confirm inventory balance.
6. Document root cause and resolution.

---

# Maintenance Schema

The Maintenance schema represents equipment reliability and maintenance activity.

In semiconductor manufacturing, equipment problems are often investigated when production yield, cycle time, or quality issues occur.

Common investigation flow:

```
Quality Failure
       |
       v
Production Lot
       |
       v
Process History
       |
       v
Equipment Used
       |
       v
Alarm / Maintenance Event
```

---

# Maintenance.EquipmentEvent

## Purpose

Stores major equipment events.

Examples:

- Preventive maintenance
- Calibration
- Repair
- Breakdown
- Software update

## Business Grain

One row per equipment event.

## Primary Key

EquipmentEventID

## Foreign Keys

- EquipmentID → Master.Equipment

## Relationships

| Related Table | Purpose |
|---|---|
|Master.Equipment|Equipment involved|
|Maintenance.WorkOrder|Maintenance activity|
|Maintenance.EquipmentAlarm|Related alarms|

## Columns

| Column | Data Type | Nullable | Description |
|---|---|---|---|
|EquipmentEventID|INT|No|Primary key|
|EquipmentID|INT|No|Machine affected|
|EventType|VARCHAR(50)|No|Event classification|
|EventDate|DATETIME2|No|When event occurred|
|EventStatus|VARCHAR(30)|No|Current state|
|Description|VARCHAR(500)|Yes|Event details|

## Typical Support Questions

- Was equipment down when a lot failed?
- Did failures start after maintenance?
- Which machines have repeated problems?

---

# Maintenance.EquipmentAlarm

## Purpose

Stores machine-generated alarms.

Examples:

- Temperature exceeded limit
- Gas flow failure
- Pressure variation
- Sensor fault

## Business Grain

One row per equipment alarm occurrence.

## Primary Key

AlarmID

## Foreign Keys

- EquipmentID → Master.Equipment

## Columns

| Column | Data Type | Nullable | Description |
|---|---|---|---|
|AlarmID|INT|No|Primary key|
|EquipmentID|INT|No|Machine generating alarm|
|AlarmCode|VARCHAR(50)|No|System alarm code|
|AlarmSeverity|VARCHAR(20)|No|Critical, Warning|
|AlarmMessage|VARCHAR(500)|No|Alarm description|
|AlarmTime|DATETIME2|No|Alarm timestamp|
|ResolvedTime|DATETIME2|Yes|Resolution time|
|ResolutionNotes|VARCHAR(500)|Yes|Fix description|

## Typical Support Questions

- Did a machine alarm before a quality failure?
- Are alarms increasing?
- Was the alarm resolved correctly?

---

# Maintenance.WorkOrder

## Purpose

Tracks technician maintenance activity.

## Business Grain

One row per maintenance work order.

## Primary Key

WorkOrderID

## Foreign Keys

- EquipmentID → Master.Equipment
- AssignedEmployeeID → Master.Employee

## Columns

|Column|Data Type|Nullable|Description|
|---|---|---|---|
|WorkOrderID|INT|No|Primary key|
|WorkOrderNumber|VARCHAR(30)|No|Maintenance ticket|
|EquipmentID|INT|No|Machine repaired|
|AssignedEmployeeID|INT|Yes|Technician|
|ProblemDescription|VARCHAR(500)|No|Problem details|
|WorkStatus|VARCHAR(30)|No|Open/Completed|
|CreatedDate|DATETIME2|No|Created timestamp|
|CompletedDate|DATETIME2|Yes|Completion timestamp|

## Typical Support Questions

- Who repaired the equipment?
- How long was downtime?
- Are recurring failures occurring?

---

# Support Schema

The Support schema represents the application support environment.

It tracks:

- Application errors
- Scheduled jobs
- User activity
- Incidents
- Resolutions

---

# Support.ApplicationLog

## Purpose

Stores application events and errors.

This is usually one of the first places a support engineer checks.

## Business Grain

One row per application event.

## Columns

|Column|Data Type|Nullable|Description|
|---|---|---|---|
|LogID|INT|No|Primary key|
|LogTime|DATETIME2|No|Event timestamp|
|ApplicationName|VARCHAR(50)|No|Application source|
|LogLevel|VARCHAR(20)|No|INFO/WARNING/ERROR|
|ModuleName|VARCHAR(100)|No|Application module|
|ReferenceNumber|VARCHAR(50)|Yes|Related transaction|
|Message|VARCHAR(1000)|No|Event message|
|ExceptionText|VARCHAR(MAX)|Yes|Technical details|

## Example Messages

```
Inventory posting failed

Recipe version not found

Database timeout

ERP connection unavailable
```

## Typical Support Questions

- What failed?
- When did it fail?
- Which transaction was affected?
- Is this a recurring issue?

---

# Support.BatchJob

## Purpose

Stores scheduled application jobs.

Examples:

- MES to NAV synchronization
- Production import
- Quality upload
- Archive jobs

## Business Grain

One row per scheduled job.

## Columns

|Column|Data Type|Nullable|Description|
|---|---|---|---|
|BatchJobID|INT|No|Primary key|
|JobName|VARCHAR(100)|No|Job name|
|Description|VARCHAR(500)|Yes|Job purpose|
|Frequency|VARCHAR(30)|Yes|Schedule|
|IsActive|BIT|No|Enabled status|

---

# Support.BatchJobExecution

## Purpose

Stores execution history for scheduled jobs.

## Business Grain

One row per job execution.

## Foreign Keys

- BatchJobID → Support.BatchJob

## Columns

|Column|Data Type|Nullable|Description|
|---|---|---|---|
|ExecutionID|INT|No|Primary key|
|BatchJobID|INT|No|Job executed|
|StartTime|DATETIME2|No|Execution start|
|EndTime|DATETIME2|Yes|Execution end|
|Status|VARCHAR(20)|No|Success/Failed|
|RecordsProcessed|INT|Yes|Volume processed|
|ErrorMessage|VARCHAR(1000)|Yes|Failure details|

## Typical Support Questions

- Did the overnight process run?
- When did it fail?
- How many records processed?
- Was the failure data or application related?

---

# Support.UserSession

## Purpose

Tracks application user activity.

## Business Grain

One row per user session.

## Foreign Keys

- EmployeeID → Master.Employee

## Columns

|Column|Data Type|Nullable|Description|
|---|---|---|---|
|SessionID|INT|No|Primary key|
|EmployeeID|INT|No|User|
|LoginTime|DATETIME2|No|Login timestamp|
|LogoutTime|DATETIME2|Yes|Logout timestamp|
|ClientApplication|VARCHAR(50)|Yes|Application used|
|IPAddress|VARCHAR(50)|Yes|Client location|
|SessionStatus|VARCHAR(20)|Yes|Active/Closed|

## Typical Support Questions

- Can the user connect?
- Is there a stuck session?
- Was the correct application used?

---

# Support.Incident

## Purpose

Stores support tickets and their resolution history.

## Business Grain

One row per support incident.

## Columns

|Column|Data Type|Nullable|Description|
|---|---|---|---|
|IncidentID|INT|No|Primary key|
|IncidentNumber|VARCHAR(30)|No|Ticket number|
|Priority|VARCHAR(20)|Yes|Severity|
|Status|VARCHAR(20)|Yes|Open/Closed|
|ModuleName|VARCHAR(100)|Yes|Affected system|
|ReportedDate|DATETIME2|Yes|Reported time|
|AssignedEmployeeID|INT|Yes|Owner|
|Summary|VARCHAR(500)|Yes|Issue summary|
|RootCause|VARCHAR(1000)|Yes|Cause|
|Resolution|VARCHAR(1000)|Yes|Fix|

## Typical Support Questions

- Has this happened before?
- What was the root cause?
- Is there a known resolution?

---

# Support.KnowledgeBase

## Purpose

Stores documented solutions.

A mature support organization converts repeated incidents into knowledge articles.

## Business Grain

One row per knowledge article.

## Columns

|Column|Data Type|Nullable|Description|
|---|---|---|---|
|ArticleID|INT|No|Primary key|
|ArticleNumber|VARCHAR(30)|No|KB identifier|
|Title|VARCHAR(200)|No|Article title|
|Symptoms|VARCHAR(1000)|Yes|Observed problem|
|Resolution|VARCHAR(MAX)|Yes|Solution|
|CreatedDate|DATETIME2|No|Creation date|

---

# Support Investigation Workflow

## Interface Failure

```
BatchJobExecution
        |
        v
ApplicationLog
        |
        v
ERPIntegrationQueue
        |
        v
InventoryTransaction
```

## Quality Issue

```
QualityResult
        |
        v
ProcessHistory
        |
        v
EquipmentAlarm
        |
        v
Maintenance.WorkOrder
```

## User Issue

```
UserSession
        |
        v
ApplicationLog
        |
        v
Incident
```

---

# Application Support Principle

A support engineer should always determine:

1. What happened?
2. When did it happen?
3. Who was affected?
4. What system component failed?
5. Was the issue data, configuration, integration, or application logic?
6. How do we prevent recurrence?