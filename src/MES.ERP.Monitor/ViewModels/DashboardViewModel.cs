using MES.ERP.Monitor.Models;
using MES.ERP.Monitor.Services;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Runtime.CompilerServices;
using System.Windows.Threading;
using LiveChartsCore;
using LiveChartsCore.SkiaSharpView;
using LiveChartsCore.SkiaSharpView.Painting;
using SkiaSharp;

namespace MES.ERP.Monitor.ViewModels;

public class DashboardViewModel : INotifyPropertyChanged
{
    private readonly ProductionService productionService;

    private int totalLots;

    public int TotalLots
    {
        get => totalLots;
        set
        {
            totalLots = value;
            OnPropertyChanged();
        }
    }

    private int completedLots;

    public int CompletedLots
    {
        get => completedLots;
        set
        {
            completedLots = value;
            OnPropertyChanged();
        }
    }

    private int processingLots;

    public int ProcessingLots
    {
        get => processingLots;
        set
        {
            processingLots = value;
            OnPropertyChanged();
        }
    }

    private int qualityHoldLots;

    public int QualityHoldLots
    {
        get => qualityHoldLots;
        set
        {
            qualityHoldLots = value;
            OnPropertyChanged();
        }
    }

    public ISeries[] ProductionStatusSeries { get; private set; } = [];

    private ObservableCollection<ProductionLot> recentLots = new();

    public ObservableCollection<ProductionLot> RecentLots
    {
        get => recentLots;
        set
        {
            recentLots = value;
            OnPropertyChanged();
        }
    }

    private readonly DispatcherTimer refreshTimer;

    public DashboardViewModel()
    {
        productionService = new ProductionService();

        LoadProductionData();

        refreshTimer = new DispatcherTimer();

        refreshTimer.Interval = TimeSpan.FromSeconds(30);

        refreshTimer.Tick += (s, e) =>
        {
            LoadProductionData();
        };

        refreshTimer.Start();
    }

    private string lastUpdated = "";

    public string LastUpdated
    {
        get => lastUpdated;
        set
        {
            lastUpdated = value;
            OnPropertyChanged();
        }
    }

    private double completionRate;

    public double CompletionRate
    {
        get => completionRate;
        set
        {
            completionRate = value;
            OnPropertyChanged();
        }
    }

    private double qualityHoldRate;

    public double QualityHoldRate
    {
        get => qualityHoldRate;
        set
        {
            qualityHoldRate = value;
            OnPropertyChanged();
        }
    }

    private int activeLots;

    public int ActiveLots
    {
        get => activeLots;
        set
        {
            activeLots = value;
            OnPropertyChanged();
        }
    }
    
    private ProductionLot? selectedLot;

    public ProductionLot? SelectedLot
    {
        get => selectedLot;
        set
        {
            selectedLot = value;
            OnPropertyChanged();
        }
    }

    public event PropertyChangedEventHandler? PropertyChanged;

    private void OnPropertyChanged(
        [CallerMemberName] string? propertyName = null)
    {
        PropertyChanged?.Invoke(
            this,
            new PropertyChangedEventArgs(propertyName));
    }

    private void LoadProductionData()
    {
        ProductionSummary summary =
            productionService.GetProductionSummary();

        TotalLots = summary.TotalLots;

        CompletedLots = summary.CompletedLots;

        ProcessingLots = summary.ProcessingLots;

        QualityHoldLots = summary.QualityHoldLots;

        CompletionRate = summary.CompletionRate;

        QualityHoldRate = summary.QualityHoldRate;

        ActiveLots = summary.ActiveLots;

        List<ProductionLot> lots =
            productionService.GetCompletedLots();

        RecentLots.Clear();

        foreach (ProductionLot lot in lots.Take(10))
        {
            RecentLots.Add(lot);
        }

        LastUpdated =
            $"Last Updated: {DateTime.Now:MM/dd/yyyy HH:mm:ss}";

        ProductionStatusSeries =
        [
            new ColumnSeries<int>
            {
                Name = "Lots",
                Values =
                [
                    CompletedLots,
                    ProcessingLots,
                    QualityHoldLots
                ]
            }
        ];

        OnPropertyChanged(nameof(ProductionStatusSeries));
    }

}