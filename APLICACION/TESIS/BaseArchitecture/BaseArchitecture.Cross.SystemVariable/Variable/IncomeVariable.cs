using System;

namespace BaseArchitecture.Cross.SystemVariable.Variable
{
    public class IncomeVariable
    {
        public IncomeVariable(string hostName, string hostIp)
        {
            UniqueIdentifier = Guid.NewGuid().ToString();
            UserHostName = hostName;
            UserHostAddress = hostIp;
        }

        public string UniqueIdentifier { get; }
        public string UserHostName { get; }
        public string UserHostAddress { get; }
    }
}