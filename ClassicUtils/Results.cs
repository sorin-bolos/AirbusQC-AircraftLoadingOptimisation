using System;
using System.Collections.Generic;
using System.Text;

namespace ClassicUtils
{
    public class Results
    {
        private readonly Dictionary<string, double> results = new Dictionary<string, double>();

        public void Add(string result)
        {
            if (!results.ContainsKey(result))
            {
                results[result] = 1;
            }
            else
            {
                results[result]++;
            }
        }

        public override string ToString()
        {
            var sb = new StringBuilder();
            foreach (var result in results)
            {
                sb.AppendLine($"{result.Key}: {result.Value}");
            }
            sb.AppendLine($"Number of results: {results.Count}");
            
            return sb.ToString();
        }
    }
}
