using System;
using System.Collections.Generic;

namespace BaseArchitecture.Cross.Mapper.Generic
{
    public class SingletonCollectionBase
    {
        protected static readonly Dictionary<Type, object> Instances = new Dictionary<Type, object>();

        protected SingletonCollectionBase()
        {
        }
    }

    public class LengthLimitedSingletonCollection<T> : SingletonCollectionBase where T : new()
    {
        protected const int MaxAllowedLength = 5;

        public static T GetInstance()
        {
            if (Instances.TryGetValue(typeof(T), out var instance)) return (T) instance;
            if (Instances.Count >= MaxAllowedLength) return default;
            instance = new T();
            Instances.Add(typeof(T), instance);
            return (T) instance;
        }
    }
}