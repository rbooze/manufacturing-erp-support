# Application Support Engineer Interview Cheat Sheet

## Project: ProductionERP MES/ERP Support Simulation

## Project Summary

I built a simulated semiconductor manufacturing support environment to practice the type of troubleshooting performed by an Application Support Engineer supporting MES and ERP systems.

The system models:

- Manufacturing Execution System (MES)
- ERP inventory processes
- Equipment maintenance
- Quality management
- Application logging
- Batch processing
- Support incidents

The goal was to understand how production data moves through an enterprise system and how support teams investigate issues.

---

# 30 Second Project Explanation

> "I created a simplified MES and ERP environment using SQL Server. The system tracks semiconductor production lots from manufacturing through quality inspection and ERP inventory posting. I built tables for production execution, equipment events, integration queues, application logs, and support incidents. I then created troubleshooting scenarios where I investigate issues by tracing transactions through the system."

---

# Why I Built This Project

A semiconductor manufacturing environment depends on several connected systems:

```
MES
 |
ERP
 |
Inventory
 |
Quality
 |
Equipment
```

A problem in one system can appear as a problem in another.

The project helped me practice:

- SQL troubleshooting
- Data investigation
- Integration analysis
- Root cause analysis
- Documentation

---

# Question: Tell Me About Your SQL Experience

## Answer

> "I have experience writing SQL queries to investigate business problems, not just retrieve data. In this project I used joins across manufacturing, inventory, and support tables to trace transactions and identify where failures occurred."

Examples:

- Finding completed lots missing from ERP
- Investigating failed integration messages
- Comparing production history against quality results
- Reviewing application failures

---

# Question: How Would You Troubleshoot a Production Issue?

## Answer

> "I start by understanding the business impact and confirming the issue. Then I identify which system owns the process, review logs and transaction history, trace the data flow, determine whether the issue is data, configuration, integration, application, or infrastructure related, fix the issue, validate the result, and document the root cause."

---

# Question: Production Says Inventory Is Missing. What Do You Check?

## Answer

I would follow the transaction flow:

```
Production Lot
      |
      v
MES Completion
      |
      v
ERP Integration Queue
      |
      v
ERP Inventory Transaction
      |
      v
Inventory Balance
```

Steps:

1. Confirm the lot completed in MES.
2. Check whether an ERP message was generated.
3. Review interface errors.
4. Verify ERP posting.
5. Confirm inventory balance.

---

# Question: How Would You Investigate an Interface Failure?

## Answer

I would check:

1. Batch job status

```
Support.BatchJobExecution
```

2. Application errors

```
Support.ApplicationLog
```

3. Integration messages

```
Inventory.ERPIntegrationQueue
```

4. Transaction results

```
Inventory.InventoryTransaction
```

Then determine:

- Data issue?
- Configuration issue?
- Application failure?
- Connection problem?

---

# Question: How Would You Investigate a Quality Problem?

## Answer

I would trace backward:

```
Quality Result
      |
      v
Production History
      |
      v
Equipment Used
      |
      v
Equipment Alarm
      |
      v
Maintenance History
```

Questions:

- Which lots failed?
- Did failures occur on the same equipment?
- Was there a maintenance event?
- Did process parameters change?

---

# Question: How Does Your Experience Transfer to Dynamics NAV?

## Answer

> "While I have not supported Dynamics NAV directly, I understand the concepts that are important for ERP support: master data, inventory transactions, production orders, integrations, batch processes, and troubleshooting. I have worked with SQL-based systems and understand how to trace transactions from the operational system into the ERP."

---

# Question: What Is MES?

## Answer

> "MES is the system that manages and records manufacturing execution on the factory floor. It tracks production orders, lots, process steps, equipment usage, quality checks, and manufacturing history."

---

# Question: What Is ERP?

## Answer

> "ERP manages business processes such as inventory, purchasing, finance, and order management. In manufacturing, ERP often receives completed production information from MES and maintains the business inventory record."

---

# Question: MES vs ERP

|MES|ERP|
|-|-|
|Factory execution|Business operations|
|Machine/process data|Inventory/business data|
|Production history|Financial transactions|
|Quality tracking|Orders and supply chain|

---

# Question: What Types of Issues Would You Expect Supporting Manufacturing Systems?

Examples:

## Data Issues

Example:

Incorrect item setup.

Investigation:

```
Master Data
 |
Transaction
 |
Error
```

---

## Integration Issues

Example:

MES completion not posting to ERP.

Investigation:

```
Queue
 |
Logs
 |
Retry
```

---

## Application Issues

Example:

Batch process failure.

Investigation:

```
Job History
 |
Application Logs
 |
Exception
```

---

## User Issues

Example:

Operator cannot complete transaction.

Investigation:

```
User Session
 |
Permissions
 |
Application Logs
```

---

# Question: How Do You Prioritize Issues?

## Answer

I consider:

1. Production impact
2. Number of users affected
3. Customer impact
4. Safety or compliance impact
5. Availability of workaround

Example:

A stopped production line is higher priority than a reporting issue.

---

# Question: What Makes a Good Support Engineer?

## Answer

A good support engineer:

- Understands the business process
- Investigates before making changes
- Communicates clearly
- Documents solutions
- Looks for root cause
- Prevents repeat issues

---

# SQL Topics to Review Before Interview

## JOINs

Know:

- INNER JOIN
- LEFT JOIN
- GROUP BY
- HAVING

---

## Investigation Queries

Practice:

Find failed transactions:

```sql
SELECT *
FROM Inventory.ERPIntegrationQueue
WHERE ProcessingStatus='Failed';
```

Find recent errors:

```sql
SELECT *
FROM Support.ApplicationLog
WHERE LogLevel='ERROR'
ORDER BY LogTime DESC;
```

Find failed quality:

```sql
SELECT *
FROM Production.QualityResult
WHERE Result='FAIL';
```

---

# Python / C# / VB Discussion

If asked about programming:

> "I use programming languages as tools to automate tasks, process data, and troubleshoot systems. My strongest background is SQL and data analysis, but I understand application logic and integration concepts."

---

# Closing Statement

> "What interests me about this role is the combination of manufacturing, systems, and troubleshooting. I enjoy understanding how data moves through a business process and finding the point where something went wrong."

---

# Final Interview Reminder

Do not focus on:

"I have not used Dynamics NAV."

Focus on:

"I understand manufacturing systems, SQL troubleshooting, integrations, and root cause analysis. I can learn the specific application."