namespace MES_ERP_Interface.Models;

public class ProductionLot
{
    public int LotID { get; set; }

    public string LotNumber { get; set; } = "";

    public int ProductID { get; set; }

    public int QuantityCompleted { get; set; }

    public string LotStatus { get; set; } = "";
}
