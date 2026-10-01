namespace MES.ERP.Monitor.Models;

public class ProductionLot
{
    public int LotID { get; set; }

    public string LotNumber { get; set; } = "";

    public int ProductID { get; set; }

    public int? CustomerID { get; set; }

    public int QuantityStarted { get; set; }

    public int QuantityCompleted { get; set; }

    public string LotStatus { get; set; } = "";

    public DateTime CreatedDate { get; set; }

    public DateTime? CompletedDate { get; set; }

    public int? OrderID { get; set; }
}