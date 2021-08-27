using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using OfficeOpenXml;
using OfficeOpenXml.Style;
using BaseArchitecture.Cross.SystemVariable.Constant;

namespace BaseArchitecture.Cross.SystemVariable.Util
{
    public static class ExcelExportHelper
    {
        public static DataTable ListToDataTable<T>(IEnumerable<T> data)
        {
            var properties = TypeDescriptor.GetProperties(typeof(T));
            var dataTable = new DataTable();

            for (var i = 0; i < properties.Count; i++)
            {
                var property = properties[i];
                dataTable.Columns.Add(property.Name,
                    Nullable.GetUnderlyingType(property.PropertyType) ?? property.PropertyType);
            }

            var values = new object[properties.Count];
            foreach (var item in data)
            {
                for (var i = 0; i < values.Length; i++) values[i] = properties[i].GetValue(item);

                dataTable.Rows.Add(values);
            }

            return dataTable;
        }

        public static byte[] ExportExcel(DataTable dataTable, string heading = "", bool showIfNot = false,
            params string[] columnsToTake)
        {
            byte[] result;
            using (var package = new ExcelPackage())
            {
                var workSheet = package.Workbook.Worksheets.Add($"{heading} Data");
                var startRowFrom = string.IsNullOrEmpty(heading) ? 1 : 3;

                workSheet.Cells["A" + startRowFrom].LoadFromDataTable(dataTable, true);

                var columnIndex = 1;
                foreach (DataColumn column in dataTable.Columns)
                {
                    var columnCells = workSheet.Cells[workSheet.Dimension.Start.Row, columnIndex,
                        workSheet.Dimension.End.Row, columnIndex];
                    var maxLength = columnCells.Max(cell => cell.Text.Count());
                    if (maxLength < 150) workSheet.Column(columnIndex).AutoFit();
                    if (string.Compare(column.DataType.Name, "Decimal", StringComparison.Ordinal) == 0)
                    {
                        columnCells.Style.Numberformat.Format = AppSettingValue.FormatType.DecimalFormat;
                        columnCells.Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;
                    }

                    if (string.Compare(column.DataType.Name, "DateTime", StringComparison.Ordinal) == 0)
                    {
                        columnCells.Style.Numberformat.Format = AppSettingValue.FormatType.DateFormat;
                        columnCells.Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;
                    }

                    columnIndex++;
                }

                using (var r = workSheet.Cells[startRowFrom, 1, startRowFrom, dataTable.Columns.Count])
                {
                    r.Style.Font.Color.SetColor(Color.White);
                    r.Style.Font.Bold = true;
                    r.Style.Fill.PatternType = ExcelFillStyle.Solid;
                    r.Style.Fill.BackgroundColor.SetColor(ColorTranslator.FromHtml("#5F8DAE"));
                }

                // format cells - add borders
                using (var r = workSheet.Cells[startRowFrom + 1, 1, startRowFrom + dataTable.Rows.Count,
                    dataTable.Columns.Count])
                {
                    r.Style.Border.Top.Style = ExcelBorderStyle.Thin;
                    r.Style.Border.Bottom.Style = ExcelBorderStyle.Thin;
                    r.Style.Border.Left.Style = ExcelBorderStyle.Thin;
                    r.Style.Border.Right.Style = ExcelBorderStyle.Thin;

                    r.Style.Border.Top.Color.SetColor(Color.Black);
                    r.Style.Border.Bottom.Color.SetColor(Color.Black);
                    r.Style.Border.Left.Color.SetColor(Color.Black);
                    r.Style.Border.Right.Color.SetColor(Color.Black);
                }

                // removed ignored columns
                for (var i = dataTable.Columns.Count - 1; i >= 0; i--)
                {
                    if (i == 0 && showIfNot) continue;
                    if (!columnsToTake.Contains(dataTable.Columns[i].ColumnName)) workSheet.DeleteColumn(i + 1);
                }

                if (!string.IsNullOrEmpty(heading))
                {
                    workSheet.Cells["A1"].Value = "Confirmación mensaje: ";
                    workSheet.Cells["A1"].Style.Font.Size = 12;

                    workSheet.Cells["B1"].Value = "NO";
                    workSheet.Cells["B1"].Style.Font.Size = 12;

                    workSheet.InsertColumn(1, 1);
                    workSheet.InsertRow(1, 1);
                    workSheet.Column(1).Width = 5;
                }

                result = package.GetAsByteArray();
            }

            return result;
        }

        public static byte[] ExportExcel<T>(List<T> data, string heading = "", bool showIfNot = false,
            params string[] columnsToTake)
        {
            return ExportExcel(ListToDataTable(data), heading, showIfNot, columnsToTake);
        }
    }
}