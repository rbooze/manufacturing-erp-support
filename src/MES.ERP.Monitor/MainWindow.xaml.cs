using MES.ERP.Monitor.ViewModels;
using System.Windows;
using System.Windows.Input;
using MES.ERP.Monitor.Services;

namespace MES.ERP.Monitor
{
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();

            DataContext = new DashboardViewModel();
        }

        private void LotInvestigation_Click(object sender, RoutedEventArgs e)
        {
            var window = new LotInvestigationWindow();
            window.Show();
        }

        private void ERPFailure_Click(object sender, MouseButtonEventArgs e)
        {
            var service = new ProductionService();

            var failedLot = service.GetFailedERPLot();

            var window = new LotInvestigationWindow();

            window.Show();

            if (!string.IsNullOrEmpty(failedLot))
            {
                window.LoadLotFromDashboard(failedLot);
            }

        }
    }

}