USE ProductionERP;
GO

INSERT INTO Production.ProductRecipe
(
    ProductID,
    RecipeName,
    RecipeVersion,
    RecipeStatus,
    EffectiveDate
)
VALUES
(
    1,
    'GAAS_VCSEL_STANDARD',
    'V1.0',
    'Active',
    '2026-01-01'
),
(
    2,
    'GAN_POWER_HIGH_VOLTAGE',
    'V2.0',
    'Active',
    '2026-01-01'
),
(
    3,
    'INP_PHOTONIC_HIGH_SPEED',
    'V1.5',
    'Active',
    '2026-01-01'
);
GO

-- =====================================================

INSERT INTO Production.ProcessRoute
(
    ProductID,
    RouteName,
    Version,
    Status
)
VALUES
(
    1,
    'GAAS_VCSEL_ROUTE',
    'V1',
    'Active'
),
(
    2,
    'GAN_POWER_ROUTE',
    'V1',
    'Active'
),
(
    3,
    'INP_PHOTONIC_ROUTE',
    'V1',
    'Active'
);
GO

-- =====================================================

INSERT INTO Production.ProcessRouteStep
(
    RouteID,
    ProcessStepID,
    SequenceNumber,
    Required
)
VALUES
-- GaAs Route
(
    1,
    1,
    10,
    1
),
(
    1,
    2,
    20,
    1
),
(
    1,
    3,
    30,
    1
),
(
    1,
    4,
    40,
    1
),
(
    1,
    5,
    50,
    1
),

-- GaN Route
(
    2,
    1,
    10,
    1
),
(
    2,
    2,
    20,
    1
),
(
    2,
    3,
    30,
    1
),
(
    2,
    4,
    40,
    1
),
(
    2,
    5,
    50,
    1
),

-- InP Route
(
    3,
    1,
    10,
    1
),
(
    3,
    2,
    20,
    1
),
(
    3,
    3,
    30,
    1
),
(
    3,
    4,
    40,
    1
),
(
    3,
    5,
    50,
    1
);
GO

-- =====================================================

INSERT INTO Production.RecipeParameter
(
    RecipeID,
    ParameterName,
    TargetValue,
    MinimumValue,
    MaximumValue
)
VALUES
(
    2,
    'Growth Temperature',
    1050,
    1040,
    1060
),
(
    2,
    'Chamber Pressure',
    50,
    45,
    55
),
(
    2,
    'Growth Time',
    18,
    16,
    20
);
GO

-- =====================================================

INSERT INTO Production.RecipeParameter
(
    RecipeID,
    ParameterName,
    TargetValue,
    MinimumValue,
    MaximumValue
)
VALUES
(
    1,
    'Growth Temperature',
    700,
    690,
    710
),
(
    1,
    'Growth Time',
    12,
    10,
    14
);
GO

-- =====================================================

INSERT INTO Production.RecipeParameter
(
    RecipeID,
    ParameterName,
    TargetValue,
    MinimumValue,
    MaximumValue
)
VALUES
(
    3,
    'Growth Temperature',
    650,
    640,
    660
),
(
    3,
    'Growth Time',
    15,
    13,
    17
);
GO

SELECT
    r.RecipeName,
    rp.ParameterName,
    rp.TargetValue,
    rp.MinimumValue,
    rp.MaximumValue
FROM Production.ProductRecipe r WITH (NOLOCK)
JOIN Production.RecipeParameter rp WITH (NOLOCK)
    ON r.RecipeID = rp.RecipeID
ORDER BY 
	r.RecipeName;