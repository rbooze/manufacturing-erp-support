using MES_ERP_Interface.Services;

ProductionService service = new();

var lots = service.GetCompletedLots();

Console.WriteLine("MES Completed Production Lots");
Console.WriteLine("--------------------------------");

foreach (var lot in lots)
{
    Console.WriteLine(
        $"Lot: {lot.LotNumber} | " +
        $"Product: {lot.ProductID} | " +
        $"Quantity: {lot.QuantityCompleted} | " +
        $"Status: {lot.LotStatus}"
    );
}

Console.WriteLine();
Console.WriteLine($"Total Lots Found: {lots.Count}");

Console.ReadLine();