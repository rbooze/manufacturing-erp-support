using Microsoft.Data.SqlClient;
using MES.ERP.Monitor.Models;

namespace MES.ERP.Monitor.Services;

public class ProductionService
{
    private readonly string _connectionString =
        @"Server=localhost\SQLEXPRESS;
          Database=ProductionERP;
          Trusted_Connection=True;
          TrustServerCertificate=True;";
   
    public List<ProductionLot> GetCompletedLots()
    {
        List<ProductionLot> lots = new();

        string sql = @"
                    SELECT
                        LotID,
                        LotNumber,
                        ProductID,
                        CustomerID,
                        QuantityStarted,
                        QuantityCompleted,
                        LotStatus,
                        CreatedDate,
                        CompletedDate,
                        OrderID
                    FROM Production.Lot
                    WHERE 
                        LotStatus = 'Completed'
                    ORDER BY 
                        LotID DESC;
        ";

        using SqlConnection connection =
            new SqlConnection(_connectionString);

        connection.Open();

        using SqlCommand command =
            new SqlCommand(sql, connection);

        using SqlDataReader reader =
            command.ExecuteReader();

        while (reader.Read())
        {
            ProductionLot lot = new()
            {
                LotID = reader.GetInt32(0),
                LotNumber = reader.GetString(1),
                ProductID = reader.GetInt32(2),

                CustomerID = reader.IsDBNull(3)
                    ? null
                    : reader.GetInt32(3),

                QuantityStarted = reader.IsDBNull(4)
                    ? 0
                    : reader.GetInt32(4),

                QuantityCompleted = reader.GetInt32(5),
                LotStatus = reader.GetString(6),
                CreatedDate = reader.GetDateTime(7),

                CompletedDate = reader.IsDBNull(8)
                    ? null
                    : reader.GetDateTime(8),

                OrderID = reader.IsDBNull(9)
                    ? null
                    : reader.GetInt32(9)
            };

            lots.Add(lot);
        }

        return lots;
    }

    public ProductionSummary GetProductionSummary()
    {
        ProductionSummary summary = new();

        string sql = @"
        SELECT
            COUNT(*) AS TotalLots,
            SUM(CASE WHEN LotStatus = 'Completed' THEN 1 ELSE 0 END) AS CompletedLots,
            SUM(CASE WHEN LotStatus = 'Processing' THEN 1 ELSE 0 END) AS ProcessingLots,
            SUM(CASE WHEN LotStatus = 'Quality Hold' THEN 1 ELSE 0 END) AS QualityHoldLots
        FROM Production.Lot;
    ";

        using SqlConnection connection =
            new SqlConnection(_connectionString);

        connection.Open();

        using SqlCommand command =
            new SqlCommand(sql, connection);

        using SqlDataReader reader =
            command.ExecuteReader();

        if (reader.Read())
        {
            summary.TotalLots = reader.GetInt32(0);

            summary.CompletedLots = reader.GetInt32(1);

            summary.ProcessingLots = reader.GetInt32(2);

            summary.QualityHoldLots = reader.GetInt32(3);

            if (summary.TotalLots > 0)
            {
                summary.CompletionRate =
                    (double)summary.CompletedLots / summary.TotalLots * 100;

                summary.QualityHoldRate =
                    (double)summary.QualityHoldLots / summary.TotalLots * 100;
            }

            summary.ActiveLots =
                summary.ProcessingLots + summary.QualityHoldLots;

            if (summary.TotalLots > 0)
            {
                summary.CompletionRate =
                    (double)summary.CompletedLots / summary.TotalLots * 100;
            }
        }

        return summary;
    }

    public List<LotInvestigation> GetLotInvestigation(string lotNumber)
    {
        var results = new List<LotInvestigation>();

        using var connection = new SqlConnection(_connectionString);

        connection.Open();

        var query = @"
                    SELECT
                        l.LotNumber,
                        l.LotStatus,

                        o.OrderNumber,

                        c.CustomerName,

                        p.ProductName,

                        ps.StepName,
                        ph.ProcessStatus,
                        ph.Notes,

                        q.TestType,
                        q.MeasurementValue,
                        q.SpecificationMin,
                        q.SpecificationMax,
                        q.Result AS QualityResult,

                        e.ProcessingStatus AS ERPStatus,
                        e.ErrorMessage

                    FROM Production.Lot l

                    LEFT JOIN Inventory.CustomerOrder o
                        ON l.OrderID = o.OrderID

                    LEFT JOIN Master.Customer c
                        ON l.CustomerID = c.CustomerID

                    LEFT JOIN Master.Product p
                        ON l.ProductID = p.ProductID

                    LEFT JOIN Production.ProcessHistory ph
                        ON l.LotID = ph.LotID

                    LEFT JOIN Production.ProcessStep ps
                        ON ph.ProcessStepID = ps.ProcessStepID

                    LEFT JOIN Production.QualityResult q
                        ON l.LotID = q.LotID

                    LEFT JOIN Inventory.ERPIntegrationQueue e
                        ON e.ReferenceID = l.LotNumber

                    WHERE l.LotNumber = @LotNumber;
                    ";

        using var command = new SqlCommand(query, connection);

        command.Parameters.AddWithValue("@LotNumber", lotNumber);

        using var reader = command.ExecuteReader();

        while (reader.Read())
        {
            results.Add(new LotInvestigation
            {
                LotNumber = reader["LotNumber"].ToString(),
                LotStatus = reader["LotStatus"].ToString(),

                OrderNumber = reader["OrderNumber"].ToString(),
                CustomerName = reader["CustomerName"].ToString(),
                ProductName = reader["ProductName"].ToString(),

                StepName = reader["StepName"].ToString(),
                ProcessStatus = reader["ProcessStatus"].ToString(),
                Notes = reader["Notes"].ToString(),

                TestType = reader["TestType"].ToString(),

                MeasurementValue = reader["MeasurementValue"] == DBNull.Value
                    ? null
                    : Convert.ToDecimal(reader["MeasurementValue"]),

                SpecificationMin = reader["SpecificationMin"] == DBNull.Value
                    ? null
                    : Convert.ToDecimal(reader["SpecificationMin"]),

                SpecificationMax = reader["SpecificationMax"] == DBNull.Value
                    ? null
                    : Convert.ToDecimal(reader["SpecificationMax"]),

                QualityResult = reader["QualityResult"].ToString(),

                ERPStatus = reader["ERPStatus"].ToString(),
                ErrorMessage = reader["ErrorMessage"].ToString()
            });
        }

        return results;
    }

    public Dictionary<string, int> GetSupportMetrics()
    {
        var metrics = new Dictionary<string, int>();

        using var connection = new SqlConnection(_connectionString);

        connection.Open();

        var query = @"
        SELECT 
            'ERP Failures' AS Metric,
            COUNT(*) AS Value
        FROM Inventory.ERPIntegrationQueue
        WHERE ProcessingStatus = 'Failed'

        UNION ALL

        SELECT
            'Quality Holds',
            COUNT(*)
        FROM Production.Lot
        WHERE LotStatus = 'Quality Hold'

        UNION ALL

        SELECT
            'Processing Lots',
            COUNT(*)
        FROM Production.Lot
        WHERE LotStatus = 'Processing';
    ";

        using var command = new SqlCommand(query, connection);

        using var reader = command.ExecuteReader();

        while (reader.Read())
        {
            metrics.Add(
                reader["Metric"].ToString(),
                Convert.ToInt32(reader["Value"])
            );
        }

        return metrics;
    }

    public string? GetFailedERPLot()
    {
        using var connection = new SqlConnection(_connectionString);

        connection.Open();

        var query = @"
            SELECT TOP 1 ReferenceID
            FROM Inventory.ERPIntegrationQueue
            WHERE ProcessingStatus = 'Failed'
            ORDER BY CreatedDate DESC;
            ";

        using var command = new SqlCommand(query, connection);

        var result = command.ExecuteScalar();

        return result?.ToString();
    }
}