using Microsoft.Data.SqlClient;
using MES.ERP.Monitor.Models;

namespace MES.ERP.Monitor.Services;

public class ProductionService
{
    private readonly string connectionString =
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
            new SqlConnection(connectionString);

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
            new SqlConnection(connectionString);

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
}