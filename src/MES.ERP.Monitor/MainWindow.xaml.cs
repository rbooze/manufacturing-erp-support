using MES.ERP.Monitor.ViewModels;
using System.Windows;

namespace MES.ERP.Monitor
{
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();

            DataContext = new DashboardViewModel();
        }
    }
}