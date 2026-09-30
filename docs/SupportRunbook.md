# ProductionERP Application Support Runbook

## Purpose

This runbook provides troubleshooting procedures for common MES/ERP application support issues.

The goal is to provide a repeatable process:

1. Identify the issue
2. Determine the affected system component
3. Analyze logs and transactions
4. Identify root cause
5. Apply resolution
6. Document the solution

---

# Support Philosophy

A support engineer should avoid immediately changing data.

The preferred approach:

```
Observe
   |
Investigate
   |
Identify Root Cause
   |
Correct
   |
Validate
   |
Document
```

---

# System Overview

ProductionERP contains:

|System|Purpose|
|-|-|
|MES|Manufacturing execution|
|ERP|Inventory and business transactions|
|Equipment Systems|Machine status and alarms|
|Quality Systems|Inspection results|
|Support Systems|Logging and incident management|

---

# Incident Priority Classification

|Priority|Example|Response|
|-|-|-|
|Critical|Production stopped|Immediate investigation|
|High|Inventory incorrect|Same day|
|Medium|User issue|Normal queue|
|Low|Documentation request|Scheduled|

---

# Troubleshooting Scenario 1

# Completed Production Lot Missing From ERP Inventory

## Problem Statement

Production reports:

> "Lot completed in MES, but inventory is not available in ERP."

---

# Investigation Flow

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
Inventory.Stock
```

---

# Step 1 - Verify MES Completion

Query:

```sql
SELECT
    LotNumber,
    LotStatus,
    QuantityCompleted
FROM Production.Lot
WHERE LotNumber = 'LOT-GAN-20260918-0145';
```

Check:

- Status = Completed
- Quantity exists

---

# Step 2 - Check Integration Queue

```sql
SELECT
    ReferenceID,
    MessageType,
    ProcessingStatus,
    ErrorMessage
FROM Inventory.ERPIntegrationQueue
WHERE ReferenceID='LOT-GAN-20260918-0145';
```

Possible results:

|Status|Meaning|
|-|-|
|Processed|Continue investigation|
|Pending|Integration delay|
|Failed|Review error|

---

# Step 3 - Check ERP Transaction

```sql
SELECT *
FROM Inventory.InventoryTransaction
WHERE LotID = <LotID>;
```

Verify:

- Quantity
- Product
- Warehouse
- Transaction status

---

# Step 4 - Root Cause Examples

Possible causes:

|Cause|Resolution|
|-|-|
|Interface failed|Retry message|
|Invalid item setup|Correct master data|
|Duplicate transaction|Reverse duplicate posting|
|ERP posting error|Correct ERP configuration|

---

# Troubleshooting Scenario 2

# Production Yield Dropped

## Problem Statement

Quality reports:

> "Recent lots are failing inspection."

---

# Investigation Flow

```
QualityResult
       |
       v
ProcessHistory
       |
       v
Equipment
       |
       v
EquipmentAlarm
       |
       v
Maintenance
```

---

# Step 1 - Identify Failed Lots

```sql
SELECT *
FROM Production.QualityResult
WHERE Result='FAIL';
```

---

# Step 2 - Find Equipment Used

```sql
SELECT
    l.LotNumber,
    ph.EquipmentID
FROM Production.Lot l

JOIN Production.ProcessHistory ph
ON l.LotID=ph.LotID;
```

---

# Step 3 - Check Equipment History

```sql
SELECT *
FROM Maintenance.EquipmentAlarm
WHERE EquipmentID=<EquipmentID>;
```

---

# Possible Root Causes

|Cause|Example|
|-|-|
|Equipment drift|Temperature variation|
|Recipe problem|Incorrect parameter|
|Maintenance issue|Sensor failure|
|Operator error|Wrong setup|

---

# Troubleshooting Scenario 3

# Nightly Interface Job Failed

## Problem Statement

Operations reports:

> "The overnight ERP synchronization did not complete."

---

# Investigation Flow

```
BatchJobExecution
        |
        v
ApplicationLog
        |
        v
ERPIntegrationQueue
```

---

# Step 1 - Check Job Status

```sql
SELECT
    b.JobName,
    e.Status,
    e.ErrorMessage
FROM Support.BatchJobExecution e

JOIN Support.BatchJob b
ON e.BatchJobID=b.BatchJobID

WHERE Status='Failed';
```

---

# Step 2 - Review Logs

```sql
SELECT *
FROM Support.ApplicationLog
WHERE LogLevel='ERROR'
ORDER BY LogTime DESC;
```

---

# Step 3 - Determine Failure Type

|Error|Category|
|-|-|
|Timeout|Database/Application|
|Connection failed|Infrastructure|
|Invalid item|Data|
|Permission denied|Security|

---

# Troubleshooting Scenario 4

# User Cannot Access Application

## Investigation Flow

```
UserSession
      |
      v
ApplicationLog
      |
      v
Incident History
```

---

# Check User Session

```sql
SELECT *
FROM Support.UserSession
WHERE EmployeeID=<EmployeeID>;
```

---

# Common Causes

|Issue|Resolution|
|-|-|
|Locked session|Terminate session|
|Incorrect permissions|Update security|
|Application error|Review logs|
|Network issue|Escalate infrastructure|

---

# Root Cause Categories

Every issue should eventually be classified.

|Category|Example|
|-|-|
|Data|Incorrect master data|
|Configuration|Wrong setup|
|Application|Software defect|
|Integration|Interface failure|
|Infrastructure|Database/server issue|
|User Error|Incorrect operation|

---

# Incident Documentation Template

## Incident Number

```
INC-XXXXX
```

## Summary

```
Brief description
```

## Impact

```
Users/process affected
```

## Investigation

```
Queries executed
Logs reviewed
Systems checked
```

## Root Cause

```
Actual cause
```

## Resolution

```
Steps taken
```

## Prevention

```
How recurrence will be avoided
```

---

# Interview Response Framework

When asked:

> "How do you troubleshoot a production issue?"

Answer:

> "First I verify the issue and determine the business impact. Then I identify the system boundary involved, review logs and transactions, trace the data flow, determine whether the problem is data, configuration, integration, application, or infrastructure related, resolve the issue, validate the fix, and document the root cause."

---

# Key Support Mindset

The goal is not just fixing today's problem.

The goal is:

```
Problem
   |
Root Cause
   |
Resolution
   |
Documentation
   |
Prevention
```

A strong application support engineer improves system reliability over time.