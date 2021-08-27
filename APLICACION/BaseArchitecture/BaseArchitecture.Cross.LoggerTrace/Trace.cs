using System;
using System.Globalization;
using System.IO;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;
using NLog;
using BaseArchitecture.Cross.SystemVariable.Constant;
using BaseArchitecture.Cross.SystemVariable.Variable;

namespace BaseArchitecture.Cross.LoggerTrace
{
    public class Trace
    {
        public Logger Logger => LogManager.GetCurrentClassLogger();

        #region Method Async

        public async Task RegisterExceptionDemandAsync(string message)
        {
            try
            {
                Logger.Error(message);
            }
            catch (Exception ex)
            {
                await ErrorToFileLogAsync(AppSettingValue.LogFilePath, ex,
                    new IncomeVariable(string.Empty, string.Empty));
            }
        }

        public async Task RegisterApiTraceAsync(IncomeTraceLogger incomeTraceLogger, IncomeVariable incomeVariable)
        {
            try
            {
                var message = new StringBuilder();
                message.Append(JsonConvert.SerializeObject(incomeTraceLogger));
                message.Append(JsonConvert.SerializeObject(incomeVariable));
                Logger.Info(message);
            }
            catch (Exception ex)
            {
                await ErrorToFileLogAsync(AppSettingValue.LogFilePath, ex, incomeVariable);
            }
        }

        public async Task RegisterExceptionAsync(Exception ex, IncomeVariable incomeVariable,
            [CallerFilePath] string filePath = "",
            [CallerLineNumber] long lineNumber = 0,
            [CallerMemberName] string methodName = "")
        {
            try
            {
                var message = new StringBuilder();
                message.Append(JsonConvert.SerializeObject(incomeVariable));
                message.Append(JsonConvert.SerializeObject(new
                {
                    RutaArchivo = filePath,
                    NumeroLinea = lineNumber,
                    NombreMetodo = methodName
                }));
                message.Append(JsonConvert.SerializeObject(ex));
                Logger.Info(message);
            }
            catch
            {
                await ErrorToFileLogAsync(AppSettingValue.LogFilePath, ex, incomeVariable, filePath, lineNumber,
                    methodName);
            }
        }


        private static async Task ErrorToFileLogAsync(string sPathName, Exception ex, IncomeVariable incomeVariable,
            [CallerFilePath] string filePath = "",
            [CallerLineNumber] long lineNumber = 0,
            [CallerMemberName] string methodName = "")
        {
            using (var sw = new StreamWriter($"{sPathName}{DateTime.Now:yyyyMMdd}.txt", true))
            {
                await sw.WriteLineAsync(
                    $"Inicio ============{incomeVariable.UniqueIdentifier}=====================================");
                await sw.WriteLineAsync(DateTime.Now.ToString(CultureInfo.InvariantCulture));
                await sw.WriteLineAsync(JsonConvert.SerializeObject(incomeVariable));
                await sw.WriteLineAsync(JsonConvert.SerializeObject(ex));
                await sw.WriteLineAsync(JsonConvert.SerializeObject(new
                {
                    RutaArchivo = filePath,
                    NumeroLinea = lineNumber,
                    NombreMetodo = methodName
                }));
                await sw.WriteLineAsync(
                    $"Fin =============={incomeVariable.UniqueIdentifier}===================================");
                await sw.FlushAsync();
                sw.Close();
            }
        }

        #endregion

        #region Method Sync

        public void RegisterExceptionDemand(string message)
        {
            try
            {
                Logger.Error(message);
            }
            catch (Exception ex)
            {
                ErrorToFileLog(AppSettingValue.LogFilePath, ex, new IncomeVariable(string.Empty, string.Empty));
            }
        }

        public void RegisterApiTrace(IncomeTraceLogger incomeTraceLogger, IncomeVariable incomeVariable)
        {
            try
            {
                var message = new StringBuilder();
                message.Append(JsonConvert.SerializeObject(incomeTraceLogger));
                message.Append(JsonConvert.SerializeObject(incomeVariable));
                Logger.Info(message);
            }
            catch (Exception ex)
            {
                ErrorToFileLog(AppSettingValue.LogFilePath, ex, incomeVariable);
            }
        }

        public void RegisterException(Exception ex, IncomeVariable incomeVariable,
            [CallerFilePath] string filePath = "",
            [CallerLineNumber] long lineNumber = 0,
            [CallerMemberName] string methodName = "")
        {
            try
            {
                var message = new StringBuilder();
                message.Append(JsonConvert.SerializeObject(incomeVariable));
                message.Append(JsonConvert.SerializeObject(new
                {
                    RutaArchivo = filePath,
                    NumeroLinea = lineNumber,
                    NombreMetodo = methodName
                }));
                message.Append(JsonConvert.SerializeObject(ex));
                Logger.Info(message);
            }
            catch
            {
                ErrorToFileLog(AppSettingValue.LogFilePath, ex, incomeVariable, filePath, lineNumber, methodName);
            }
        }


        private static void ErrorToFileLog(string sPathName, Exception ex, IncomeVariable incomeVariable,
            [CallerFilePath] string filePath = "",
            [CallerLineNumber] long lineNumber = 0,
            [CallerMemberName] string methodName = "")
        {
            using (var sw = new StreamWriter($"{sPathName}{DateTime.Now:yyyyMMdd}.txt", true))
            {
                sw.WriteLine(
                    $"Inicio ============{incomeVariable.UniqueIdentifier}=====================================");
                sw.WriteLine(DateTime.Now.ToString(CultureInfo.InvariantCulture));
                sw.WriteLine(JsonConvert.SerializeObject(incomeVariable));
                sw.WriteLine(JsonConvert.SerializeObject(ex));
                sw.WriteLine(JsonConvert.SerializeObject(new
                {
                    RutaArchivo = filePath,
                    NumeroLinea = lineNumber,
                    NombreMetodo = methodName
                }));
                sw.WriteLine($"Fin =============={incomeVariable.UniqueIdentifier}===================================");
                sw.Flush();
                sw.Close();
            }
        }

        #endregion
    }
}