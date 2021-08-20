using System;

namespace BaseArchitecture.Cross.SystemVariable.Constant
{
    public class IncomeConfigureFile
    {
        //public static readonly string NameFileUpload = DateTime.Now.Year.ToString()+"."
        public static string NameFile;
        public static string NameFolder;
        public static string Turno;
        public static string FechaActual; //fecha actual del sistema
        public static int EstadoEjecucion; // si esta permitido o no de ejecutar el proceso de tipo 1
        public static int ProcessTransacSharepoint; //inicializa el tipo de proceso 
        public static int FileExiststoUpload;

        public static void SetFileExiststoUpload(int Existe)
        {
            FileExiststoUpload = Existe;
        }
        public static int GetFileExiststoUpload()
        {
            return FileExiststoUpload;
        }

        public static void SetProcessTransacSharepoint(int Tipo)
        {
            ProcessTransacSharepoint = Tipo;
        }
        public static int GetProcessTransacSharepoint()
        {
            return ProcessTransacSharepoint;
        }
        public static void SetValidateExecute(int Estado)
        {
            EstadoEjecucion = Estado;
        }
        public static int GetValidateExecute()
        {
            return EstadoEjecucion;
        }
        public static void SetNameFileUpload()
        {
            FechaActual = DateTime.Now.ToString("dd/MM/yyyy");
            if (DateTime.Now.Hour > 6 && DateTime.Now.Hour < 19)
            {
                NameFile = DateTime.Now.ToString("yyyy") + "." + DateTime.Now.ToString("MM") + "." + DateTime.Now.ToString("dd") + " D_" + DateTime.Now.ToString("hhmmtt").Replace(".", "").Replace(" ", "").ToUpper() + ".xlsx";
                Turno = "D";
            }
            else
            {
                NameFile = DateTime.Now.ToString("yyyy") + "." + DateTime.Now.ToString("MM") + "." + DateTime.Now.ToString("dd") + " N_" + DateTime.Now.ToString("hhmmtt").Replace(".", "").Replace(" ", "").ToUpper() + ".xlsx";
                Turno = "N";
            }

        }
        public static string GetNameFileUpload()
        {
            return NameFile;
        }
        public static string GetTurnoActual()
        {
            return Turno;
        }
        public static string GetFechaActual()
        {
            return FechaActual;
        }
        public static string SetNameFolderUpload()
        {
            if (DateTime.Now.Hour > 6 && DateTime.Now.Hour < 19)
                NameFolder = DateTime.Now.ToString("yyyy") + "." + DateTime.Now.ToString("MM") + "." + DateTime.Now.ToString("dd") + " D";
            else
                NameFolder = DateTime.Now.ToString("yyyy") + "." + DateTime.Now.ToString("MM") + "." + DateTime.Now.ToString("dd") + " N";

            return NameFolder;
        }
        public static string GetNameFolderUpload()
        {
            return NameFolder;
        }
    }
}
