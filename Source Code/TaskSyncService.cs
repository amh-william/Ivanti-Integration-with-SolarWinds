using System.Data;
using Microsoft.Extensions.Configuration;
using System.Data.SqlClient;
using Microsoft.Win32.TaskScheduler;

namespace IvantiTaskSyncService;
public class TaskSyncService
{
    public enum PropertyName
    {
        TaskPath,
        ConnectionString,
        StoredProcedure,
        StoredProcedureParameter
    }
    internal static string _ServerName = "SERVERNAME";
    internal static string _DatabaseName = "DATABASE";
    internal static string[] DefaultValues = {  "\\Ivanti\\Security Controls\\Scans\\",
                                                $"data source={_ServerName};Initial Catalog={_DatabaseName};Integrated Security=True;",
                                                "sp_tblTasks_InsertTask",
                                                "@List"
    };
    private readonly IConfiguration configuration;
    private readonly string _TaskPath;
    private readonly string _ConnectionString;
    private readonly string _StoredProcedure;
    private readonly string _StoredProcedureParameter;

    public TaskSyncService(string[]? args, IConfiguration config)
    {
        this.configuration = config;
        if (null != args)
        {
            if (args.Length == 4)
            {
                _TaskPath = args[0];
                _ConnectionString = args[1];
                _StoredProcedure = args[2];
                _StoredProcedureParameter = args[3];
            }
            else
            {
                _TaskPath = GetConfigItem(PropertyName.TaskPath);
                _ConnectionString = GetConfigItem(PropertyName.ConnectionString);
                _StoredProcedure = GetConfigItem(PropertyName.StoredProcedure);
                _StoredProcedureParameter = GetConfigItem(PropertyName.StoredProcedureParameter);
            }
        }
        else
        {
            _TaskPath = GetConfigItem(PropertyName.TaskPath);
            _ConnectionString = GetConfigItem(PropertyName.ConnectionString);
            _StoredProcedure = GetConfigItem(PropertyName.StoredProcedure);
            _StoredProcedureParameter = GetConfigItem(PropertyName.StoredProcedureParameter);
        }
    }

    internal string GetConfigItem(PropertyName name)
    {
        string? result = GetConfigFromFile(name);
        if (null != result) return result;
        else return DefaultValues[(int)name];
    }

    internal string? GetConfigFromFile(PropertyName name)
    {
        return name switch
        {
            PropertyName.TaskPath => (string)configuration.GetSection("ServiceItems").GetValue("".GetType(), "TaskPath"),
            PropertyName.ConnectionString => configuration.GetConnectionString(configuration.GetSection("ConnectionStrings").GetChildren().First().Key),
            PropertyName.StoredProcedure => (string)configuration.GetSection("ServiceItems").GetValue("".GetType(), "StoredProcedure"),
            PropertyName.StoredProcedureParameter => (string)configuration.GetSection("ServiceItems").GetValue("".GetType(), "StoredProcedureParameter"),
            _ => null,
        };
    }

    internal DataTable GetTasks()
    {
        using DataTable dt = new();
        DataColumn col = new("taskName", "".GetType());
        dt.Columns.Add(col);
        col = new DataColumn("taskDescription", "".GetType());
        dt.Columns.Add(col);
        DateTime dateTime = new();
        {
            col = new DataColumn("taskNextRunTime", dateTime.GetType());
            dt.Columns.Add(col);
            col.Dispose();
        }
        using TaskService myTaskScheduler = new();
        using TaskFolder folder = myTaskScheduler.GetFolder(_TaskPath);
        using TaskCollection taskCollection = folder.GetTasks();
        foreach (Microsoft.Win32.TaskScheduler.Task task in taskCollection)
        {
            using TaskRegistrationInfo taskInfo = task.Definition.RegistrationInfo;
            DataRow row = dt.NewRow();
            row["taskName"] = task.Name;
            row["taskDescription"] = taskInfo.Description;
            row["taskNextRunTime"] = task.NextRunTime.ToUniversalTime();
            dt.Rows.Add(row);
        }
        return dt;
    }

    public void PerformSync()
    {
        using DataTable input = GetTasks();
        using SqlConnection conn = new(_ConnectionString);
        using SqlCommand cmd = new(_StoredProcedure, conn);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.Add(_StoredProcedureParameter, SqlDbType.Structured).Value = input;

        conn.Open();
        cmd.ExecuteNonQuery();
        conn.Close();
    }


}
