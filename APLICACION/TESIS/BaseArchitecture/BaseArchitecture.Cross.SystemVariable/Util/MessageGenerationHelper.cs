using System.Collections.Generic;
using System.IO;
using System.Linq;
using BaseArchitecture.Cross.SystemVariable.Model;

namespace BaseArchitecture.Cross.SystemVariable.Util
{
    public class MessageGenerationHelper
    {
        public enum TypeMessage
        {
            Mail,
            Phone
        }

        public string GetMessageFilePath(string pathTemplate, IEnumerable<TagMessageModel> listTagMessageModel)
        {
            string messageFilePath;
            using (var reader = new StreamReader(pathTemplate))
            {
                messageFilePath = reader.ReadToEnd();
                messageFilePath = listTagMessageModel.Aggregate(messageFilePath,
                    (current, model) => current.Replace($"{{{model.Tag}}}", model.Value));
            }

            return messageFilePath;
        }

        public string GetMessage(string message, IEnumerable<TagMessageModel> listTagMessageModel)
        {
            return listTagMessageModel.Aggregate(message,
                (current, model) => current.Replace($"{{{model.Tag}}}", model.Value));
        }
    }
}