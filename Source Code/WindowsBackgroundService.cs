namespace IvantiTaskSyncService
{
    public class WindowsBackgroundService : BackgroundService
    {
        private readonly TaskSyncService _taskSyncService;
        private readonly ILogger<WindowsBackgroundService> _logger;

        public WindowsBackgroundService(
            TaskSyncService taskSyncService, 
            ILogger<WindowsBackgroundService> logger) =>
            (_taskSyncService, _logger) = (taskSyncService, logger);

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            try
            {
                while (!stoppingToken.IsCancellationRequested)
                {
                    _logger.LogInformation("Ivanti Task Sync running at: {time}", DateTimeOffset.Now);
                    _taskSyncService.PerformSync();
                    await Task.Delay(TimeSpan.FromMinutes(5), stoppingToken);
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "{Message}", ex.Message);
                Environment.Exit(1);
            }
        }
    }
}