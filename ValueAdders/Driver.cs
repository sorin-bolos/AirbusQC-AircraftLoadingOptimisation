using System;
using System.Linq;
using ClassicUtils;
using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.Simulation.Simulators;

namespace ValueAdders
{
    class Driver
    {
        private const int TestCount = 1;

        static void Main(string[] args)
        {
            WeightedSum();
        }

        static void ControlledSum()
        {
            var results = new Results();
            var terms = new QArray<long>(new long[] { 5, 7, 2 });

            foreach (var term in terms)
            {
                Console.Write($"{term} ");
            }
            Console.Write($" = ");

            for (int i = 0; i < TestCount; i++)
            {
                using (var qsim = new QuantumSimulator())
                {
                    var result = Sum.Run(qsim, terms).Result.Cast<int>().ToArray();

                    results.Add(result.ToBase10().ToString());
                }
            }

            Console.Write(results);
            Console.WriteLine("Finished.");
            Console.ReadLine();
        }

        static void WeightedSum()
        {
            var results = new Results();
            var terms = new QArray<long>(new long[] { 5, 7, 2 });
            var weights = new QArray<long>(new long[] { 0, 1, 2 });

            var n = terms.Count;

            for (int i = 0; i < terms.Count; i++)
            {
                Console.Write($"{weights[i]}*{terms[i]}");
                Console.Write(i == terms.Count - 1 ? $" = " : $" + ");
            }
            

            for (int i = 0; i < TestCount; i++)
            {
                using (var qsim = new QuantumSimulator())
                {
                    var result = ComputeWeightedSum.Run(qsim, terms, weights).Result;

                   results.Add(result.ToString());
                }
            }

            Console.Write(results);
            Console.WriteLine("Finished.");
            Console.ReadLine();
        }
    }
}