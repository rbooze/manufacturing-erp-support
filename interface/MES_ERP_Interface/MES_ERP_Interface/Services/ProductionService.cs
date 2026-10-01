using Microsoft.Data.SqlClient;
using MES_ERP_Interface.Models;

namespace MES_ERP_Interface.Services;

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
                QuantityCompleted,
                LotStatus
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
                QuantityCompleted = reader.GetInt32(3),
                LotStatus = reader.GetString(4)
            };


            lots.Add(lot);
        }


        return lots;
    }
}
