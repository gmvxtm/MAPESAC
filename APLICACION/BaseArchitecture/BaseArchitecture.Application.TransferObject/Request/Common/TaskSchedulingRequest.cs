using System;
using BaseArchitecture.Cross.SystemVariable.Constant;

namespace BaseArchitecture.Application.TransferObject.Request.Common
{
    public class TaskSchedulingRequest
    {
        public TaskSchedulingRequest(Guid idPetition, string name, string codeProcess, string userRecordCreation)
        {
            IdTaskScheduling = Guid.NewGuid();
            IdPetition = idPetition;
            IdApplication = IncomeServiceProgrammed.IdApplication;
            CodeProcess = codeProcess;
            Name = name;
            StartProgramming = DateTime.Now;
            RecordStatus = RecordStatusBase.Active;
            RecordCreationDate = DateTime.Now;
            UserRecordCreation = userRecordCreation;
        }

        public TaskSchedulingRequest(Guid idPetition)
        {
            IdTaskScheduling = Guid.NewGuid();
            IdPetition = idPetition;
            IdApplication = IncomeServiceProgrammed.IdApplication;
            StartProgramming = DateTime.Now;
            RecordStatus = RecordStatusBase.Active;
            RecordCreationDate = DateTime.Now;
        }

        public Guid IdPetition { get; set; }
        public Guid IdTaskScheduling { get; set; }
        public string Name { get; set; }
        public string CodeProcess { get; set; }
        public string IdApplication { get; set; }
        public DateTime StartProgramming { get; set; }
        public DateTime? EndProgramming { get; set; }
        public string ExecutionTime { get; set; }
        public string RepeatEveryMinute { get; set; }
        public string RecordStatus { get; set; }
        public string UserRecordCreation { get; set; }
        public DateTime RecordCreationDate { get; set; }
    }
}