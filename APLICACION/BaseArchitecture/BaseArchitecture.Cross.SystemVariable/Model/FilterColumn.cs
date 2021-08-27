using System;

namespace BaseArchitecture.Cross.SystemVariable.Model
{
    [Serializable]
    public class FilterColumn
    {
        private string _valueColumn;
        public string NameColumn { get; set; }

        public string ValueColumn
        {
            get => _valueColumn;
            set => _valueColumn = value.Replace(Environment.NewLine, "");
        }
    }
}