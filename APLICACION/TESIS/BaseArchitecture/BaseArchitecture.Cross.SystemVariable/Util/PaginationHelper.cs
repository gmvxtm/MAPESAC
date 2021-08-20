using BaseArchitecture.Cross.SystemVariable.Model;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Linq.Expressions;

namespace BaseArchitecture.Cross.SystemVariable.Util
{
    public static class Extension
    {
        public enum TypeOrder
        {
            Asc,
            Desc
        }

        public static int NumberOfPage(this int totalRows, int rowsByPage)
        {
            var numberPage = 1;
            var shadowPage = totalRows % rowsByPage;
            if (totalRows > rowsByPage) numberPage = totalRows / rowsByPage;
            var shadow = numberPage * rowsByPage + shadowPage;
            if (Convert.ToInt32(shadowPage) > 0 && shadow == totalRows) numberPage += 1;
            return numberPage;
        }

        public static IEnumerable<T> PaginationCollection<T>(this IEnumerable<T> collectionPage, int page,
            int rowsByPage)
        {
            var index = 0;
            var upperLimit = page * rowsByPage - 1;
            var lowerLimit = upperLimit - (rowsByPage - 1);
            foreach (var el in collectionPage)
            {
                if (index >= lowerLimit && index <= upperLimit) yield return el;
                index += 1;
            }
        }

        public static IEnumerable<T> DynamicFilter<T>(this IEnumerable<T> filterCollection,
            IEnumerable<FilterColumn> filter)
        {
            if (filter == null) return filterCollection;
            var collections = filterCollection as T[] ?? filterCollection.ToArray();
            var filterColumns = filter as FilterColumn[] ?? filter.ToArray();
            return (from collection in collections
                let isEquals =
                    !(from fil in filterColumns.Where(x => x.NameColumn?.Trim() != string.Empty && x.NameColumn != null)
                        let valueColumn = collection == null
                            ? fil.ValueColumn
                            : GetValue(fil.NameColumn.Trim(), collection)
                        where !valueColumn.ToUpper().Contains(fil.ValueColumn.ToUpper())
                        select fil).Any()
                where isEquals
                select collection).ToList();
        }

        private static string GetValue<T>(string key, T type)
        {
            var p = Expression.Parameter(typeof(T), "a");
            var body = Expression.PropertyOrField(p, key);
            var prop = typeof(T).GetProperty(key);

            if (prop is null) return "";
            var ty = prop.PropertyType.Name;
            switch (ty)
            {
                case "String":
                    var funString = Expression.Lambda<Func<T, string>>(body, p).Compile();
                    return funString(type);
                case "Decimal":
                    var funcDecimal = Expression.Lambda<Func<T, decimal>>(body, p).Compile();
                    return funcDecimal(type).ToString(CultureInfo.InvariantCulture);
                case "Int32":
                    var funcInt = Expression.Lambda<Func<T, int>>(body, p).Compile();
                    return funcInt(type).ToString();
                case "DateTime":
                    var funcDate = Expression.Lambda<Func<T, DateTime>>(body, p).Compile();
                    return funcDate(type).ToString(CultureInfo.InvariantCulture);
                case "Double":
                    var funcDouble = Expression.Lambda<Func<T, double>>(body, p).Compile();
                    return funcDouble(type).ToString(CultureInfo.InvariantCulture);
                case "Single":
                    var funcFloat = Expression.Lambda<Func<T, float>>(body, p).Compile();
                    return funcFloat(type).ToString(CultureInfo.InvariantCulture);
            }

            return "";
        }

        public static IEnumerable<T> OrderByField<T>(this IEnumerable<T> collectionOrder, string nameColumn,
            TypeOrder tp)
        {
            var ot = typeof(T);
            if (nameColumn.Trim() == "") throw new ArgumentNullException($"El nombre del campos esta vacio");
            var key = Expression.Parameter(ot, "Key");
            var func = Expression.PropertyOrField(key, nameColumn);

            var proInfo = typeof(T).GetProperty(nameColumn.Trim());
            if (proInfo is null) return collectionOrder.AsQueryable();
            var ty = proInfo.PropertyType.Name;
            switch (tp)
            {
                case TypeOrder.Asc:
                    switch (ty)
                    {
                        case "String":
                            var funString = Expression.Lambda<Func<T, string>>(func, key).Compile();
                            return collectionOrder.AsQueryable().AsEnumerable().OrderBy(funString);
                        case "Decimal":
                            var funcDecimal = Expression.Lambda<Func<T, decimal>>(func, key).Compile();
                            return collectionOrder.AsQueryable().AsEnumerable().OrderBy(funcDecimal);
                        case "Int32":
                            var funcInt = Expression.Lambda<Func<T, int>>(func, key).Compile();
                            return collectionOrder.AsQueryable().AsEnumerable().OrderBy(funcInt);
                        case "DateTime":
                            var funcDate = Expression.Lambda<Func<T, DateTime>>(func, key).Compile();
                            return collectionOrder.AsQueryable().AsEnumerable().OrderBy(funcDate);
                        case "Double":
                            var funcDouble = Expression.Lambda<Func<T, double>>(func, key).Compile();
                            return collectionOrder.AsQueryable().AsEnumerable().OrderBy(funcDouble);
                        case "Single":
                            var funcFloat = Expression.Lambda<Func<T, float>>(func, key).Compile();
                            return collectionOrder.AsQueryable().AsEnumerable().OrderBy(funcFloat);
                    }

                    break;
                case TypeOrder.Desc:
                    switch (ty)
                    {
                        case "String":
                            var funString = Expression.Lambda<Func<T, string>>(func, key).Compile();
                            return collectionOrder.AsQueryable().AsEnumerable().OrderByDescending(funString);
                        case "Decimal":
                            var funcDecimal = Expression.Lambda<Func<T, decimal>>(func, key).Compile();
                            return collectionOrder.AsQueryable().AsEnumerable().OrderByDescending(funcDecimal);
                        case "Int32":
                            var funcInt = Expression.Lambda<Func<T, int>>(func, key).Compile();
                            return collectionOrder.AsQueryable().AsEnumerable().OrderByDescending(funcInt);
                        case "DateTime":
                            var funcDate = Expression.Lambda<Func<T, DateTime>>(func, key).Compile();
                            return collectionOrder.AsQueryable().AsEnumerable().OrderByDescending(funcDate);
                        case "Double":
                            var funcDouble = Expression.Lambda<Func<T, double>>(func, key).Compile();
                            return collectionOrder.AsQueryable().AsEnumerable().OrderByDescending(funcDouble);
                        case "Single":
                            var funcFloat = Expression.Lambda<Func<T, float>>(func, key).Compile();
                            return collectionOrder.AsQueryable().AsEnumerable().OrderByDescending(funcFloat);
                    }

                    break;
                default:
                    throw new ArgumentOutOfRangeException(nameof(tp), tp, null);
            }

            return collectionOrder.AsQueryable();
        }
    }

    public class Page<T>

    {
        private readonly int _currentPage;
        private readonly int _rowsByPage;

        private Page(int currentPage, int rowsByPage, IEnumerable<T> collectionData)
        {
            Collection = collectionData ?? new List<T>();
            _currentPage = currentPage == 0 ? 1 : currentPage;
            _rowsByPage = currentPage == 0 ? Collection.Count() : rowsByPage;
            GetTotalPage();
        }

        public Page(IEnumerable<FilterColumn> filter, string field, Extension.TypeOrder typeOrder)
        {
            Collection = Collection.DynamicFilter(filter);
            Collection = Collection.OrderByField(field, typeOrder);
            Pagination();
        }

        public int QuantityRows { get; set; }
        public int TotalPages { get; set; }
        public IEnumerable<T> Collection { get; set; }

        public static Page<T> CreateInstance(int currentPage, int rowsByPage, IEnumerable<T> collectionData)
        {
            return new Page<T>(currentPage, rowsByPage, collectionData);
        }

        private void GetTotalPage()
        {
            var enumerable = Collection as T[] ?? Collection.ToArray();
            QuantityRows = enumerable.Length;
            var count = enumerable.Count();
            var any = enumerable.Any();
            var countPage = any ? count : 1;
            TotalPages = _currentPage == 0 ? 1 : countPage.NumberOfPage(_rowsByPage);
        }

        public Page<T> Filter(IEnumerable<FilterColumn> filter)
        {
            var enumerable = Collection as T[] ?? Collection.ToArray();
            Collection = enumerable.DynamicFilter(filter);
            GetTotalPage();
            return this;
        }

        public Page<T> Order(string field, Extension.TypeOrder typeOrder)
        {
            var enumerable = Collection as T[] ?? Collection.ToArray();
            Collection = enumerable.OrderByField(field, typeOrder);
            return this;
        }

        public Page<T> Pagination()
        {
            Collection = Collection.PaginationCollection(_currentPage, _rowsByPage);
            return this;
        }
    }
}