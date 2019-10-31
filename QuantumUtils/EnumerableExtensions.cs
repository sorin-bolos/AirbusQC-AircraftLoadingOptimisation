using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.Quantum.Simulation.Core;

namespace QuantumUtils
{
    public static class EnumerableExtensions
    {
        public static IQArray<T> ToQArray<T>(this IEnumerable<T> source)
        {
            return new QArray<T>(source);
        }
    }
}
