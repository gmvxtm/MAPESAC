namespace BaseArchitecture.Application.TransferObject.Response.Access
{
    public class ProcessResponse
    {
        public ProcessResponse(string processId, string processName, string processOnlyRead)
        {
            ProcessId = processId;
            ProcessName = processName;
            ProcessOnlyRead = processOnlyRead;
        }

        public string ProcessId { get; set; }
        public string ProcessName { get; set; }
        public string ProcessOnlyRead { get; set; }
    }
}