namespace MES.ERP.Monitor.Models;
public class ProductionSummary
{
    public int TotalLots { get; set; }

    public int CompletedLots { get; set; }

    public int ProcessingLots { get; set; }

    public int QualityHoldLots { get; set; }

    public double CompletionRate { get; set; }

    public double QualityHoldRate { get; set; }

    public int ActiveLots { get; set; }
}