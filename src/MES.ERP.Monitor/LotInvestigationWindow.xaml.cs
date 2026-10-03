using MES.ERP.Monitor.Services;
using System.Windows;

namespace MES.ERP.Monitor;

public partial class LotInvestigationWindow : Window
{
    private readonly ProductionService _service;

    public LotInvestigationWindow()
    {
        InitializeComponent();

        _service = new ProductionService();
    }

    private void Search_Click(object sender, RoutedEventArgs e)
    {
        LoadLot(LotNumberTextBox.Text);

        //var lotNumber = LotNumberTextBox.Text;

        //var results = _service.GetLotInvestigation(lotNumber);

        //if (results.Count == 0)
        //{
        //    MessageBox.Show("Lot not found");
        //    return;
        //}

        //var first = results[0];

        //LotText.Text = $"Lot: {first.LotNumber}";
        //OrderText.Text = $"Order: {first.OrderNumber}";
        //CustomerText.Text = $"Customer: {first.CustomerName}";
        //ProductText.Text = $"Product: {first.ProductName}";
        //StatusText.Text = $"Status: {first.LotStatus}";

        //ProcessGrid.ItemsSource = results;

        //QualityText.Text =
        //    $"Test: {first.TestType}\n" +
        //    $"Result: {first.QualityResult}\n" +
        //    $"Measurement: {first.MeasurementValue}\n" +
        //    $"Specification: {first.SpecificationMin} - {first.SpecificationMax}";

        //ERPText.Text =
        //    $"ERP Status: {first.ERPStatus}\n" +
        //    $"Error: {first.ErrorMessage}";
    }

    private void OpenLotInvestigation_Click(object sender, RoutedEventArgs e)
    {
        var window = new LotInvestigationWindow();
        window.Show();
    }

    private void LoadLot(string lotNumber)
    {
        var results = _service.GetLotInvestigation(lotNumber);

        if (results.Count == 0)
        {
            MessageBox.Show("Lot not found");
            return;
        }

        var first = results[0];

        LotText.Text = $"Lot: {first.LotNumber}";
        OrderText.Text = $"Order: {first.OrderNumber}";
        CustomerText.Text = $"Customer: {first.CustomerName}";
        ProductText.Text = $"Product: {first.ProductName}";
        StatusText.Text = $"Status: {first.LotStatus}";

        ProcessGrid.ItemsSource = results;

        QualityText.Text =
            $"Test: {first.TestType}\n" +
            $"Result: {first.QualityResult}\n" +
            $"Measurement: {first.MeasurementValue}\n" +
            $"Specification: {first.SpecificationMin} - {first.SpecificationMax}";

        ERPText.Text =
            $"ERP Status: {first.ERPStatus}\n" +
            $"Error: {first.ErrorMessage}";
    }

    public void LoadLotFromDashboard(string lotNumber)
    {
        LotNumberTextBox.Text = lotNumber;

        LoadLot(lotNumber);
    }
}