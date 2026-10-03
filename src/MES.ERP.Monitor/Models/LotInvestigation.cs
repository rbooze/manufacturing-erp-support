namespace MES.ERP.Monitor.Models;

public class LotInvestigation
{
    public string LotNumber { get; set; }

    public string LotStatus { get; set; }

    public string OrderNumber { get; set; }

    public string CustomerName { get; set; }

    public string ProductName { get; set; }

    public string StepName { get; set; }

    public string ProcessStatus { get; set; }

    public string Notes { get; set; }

    public string TestType { get; set; }

    public decimal? MeasurementValue { get; set; }

    public decimal? SpecificationMin { get; set; }

    public decimal? SpecificationMax { get; set; }

    public string QualityResult { get; set; }

    public string ERPStatus { get; set; }

    public string ErrorMessage { get; set; }
}