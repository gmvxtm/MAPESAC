using System;

namespace BaseArchitecture.Cross.SystemVariable.Util
{
    public class General
    {
        protected General()
        {
        }

        public static DateTime ConvertStringToDate(string stringDate)
        {
            var year = Convert.ToInt32(stringDate.Substring(0, 4));
            var month = Convert.ToInt32(stringDate.Substring(4, 2));
            var day = Convert.ToInt32(stringDate.Substring(6, 2));
            return new DateTime(year, month, day);
        }

        public static bool ValidatedTimeExpire(DateTime dateEnd)
        {
            var timeSecondsNow =
                Convert.ToInt32((DateTime.Now.ToUniversalTime() - new DateTime(1970, 1, 1)).TotalSeconds);
            var timeSecondsDevice =
                Convert.ToInt32((dateEnd.ToUniversalTime() - new DateTime(1970, 1, 1)).TotalSeconds);
            return timeSecondsNow > timeSecondsDevice;
        }

        public static bool ValidatedTimeExpire(int timeSecondsEnd)
        {
            var timeSecondsNow =
                Convert.ToInt32((DateTime.Now.ToUniversalTime() - new DateTime(1970, 1, 1)).TotalSeconds);
            return timeSecondsNow > timeSecondsEnd;
        }
    }
}