USE ProductionERP;
GO

INSERT INTO Maintenance.EquipmentEvent
(
    EquipmentID,
    EventType,
    EventDate,
    EventStatus,
    Description
)
VALUES
(
    1,
    'Preventive Maintenance',
    '2026-09-05 08:00',
    'Completed',
    'Routine chamber cleaning and calibration'
),
(
    2,
    'Breakdown',
    '2026-09-12 22:15',
    'Completed',
    'Gas flow controller failure'
),
(
    2,
    'Repair',
    '2026-09-13 14:00',
    'Completed',
    'Gas controller replaced and tested'
),
(
    3,
    'Calibration',
    '2026-09-15 09:00',
    'Completed',
    'Optical inspection calibration'
),
(
    4,
    'Software Update',
    '2026-09-18 02:00',
    'Completed',
    'Test station firmware upgrade'
);
GO

-- ==========================================================

INSERT INTO Maintenance.EquipmentAlarm
(
    EquipmentID,
    AlarmCode,
    AlarmSeverity,
    AlarmMessage,
    AlarmTime,
    ResolvedTime,
    ResolutionNotes
)
VALUES
(
    2,
    'TEMP_HIGH',
    'Critical',
    'Reactor temperature exceeded recipe limit',
    '2026-09-12 22:15',
    '2026-09-13 14:00',
    'Reactor shut down and controller replaced'
),
(
    2,
    'GAS_FLOW_LOW',
    'Warning',
    'Gas flow below expected range',
    '2026-09-12 21:45',
    '2026-09-13 14:00',
    'Gas controller replaced'
),
(
    1,
    'PRESSURE_VARIATION',
    'Warning',
    'Chamber pressure variation detected',
    '2026-09-20 11:30',
    '2026-09-20 12:15',
    'Pressure sensor recalibrated'
);
GO

-- ==========================================================

INSERT INTO Maintenance.WorkOrder
(
    WorkOrderNumber,
    EquipmentID,
    AssignedEmployeeID,
    ProblemDescription,
    WorkStatus,
    CreatedDate,
    CompletedDate
)
VALUES
(
    'WO-2026-1001',
    2,
    1,
    'Replace failed gas flow controller',
    'Completed',
    '2026-09-12 22:30',
    '2026-09-13 14:00'
),
(
    'WO-2026-1002',
    1,
    2,
    'Pressure sensor calibration',
    'Completed',
    '2026-09-20 11:45',
    '2026-09-20 12:15'
);
GO

-- ==========================================================

SELECT
    e.EquipmentName,
    ee.EventType,
    ee.EventDate,
    ee.Description
FROM Maintenance.EquipmentEvent ee WITH (NOLOCK)
JOIN Master.Equipment e WITH (NOLOCK)
    ON ee.EquipmentID=e.EquipmentID
ORDER BY 
	ee.EventDate;