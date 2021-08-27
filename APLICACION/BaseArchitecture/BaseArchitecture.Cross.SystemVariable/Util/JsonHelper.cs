using System.Collections.Generic;
using Newtonsoft.Json;

namespace BaseArchitecture.Cross.SystemVariable.Util
{
    public class JsonHelper<T>
    {
        protected JsonHelper()
        {
        }

        public static string GetJsonTransform(List<T> listAnonymous)
        {
            return JsonConvert.SerializeObject(listAnonymous);
        }
    }
}