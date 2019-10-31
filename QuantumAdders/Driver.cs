using System;
using System.Linq;
using ClassicUtils;
using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.Simulation.Simulators;

namespace QuantumAdders
{
    class Driver
    {
        private const int TestCount = 100;
        private const int NumberOfBits = 3;

        static void Main(string[] args)
        {
            int a = 5;
            int b = 3;

            var results = new Results();
            var binaryA = new QArray<long>(a.ToBase2(NumberOfBits));
            var binaryB = new QArray<long>(b.ToBase2(NumberOfBits));


            Console.Write($"a={a} b={b} ");
            Console.WriteLine($"binaryA={binaryA} binaryB={binaryB}");

            for (int i = 0; i < TestCount; i++)
            {
                using (var qsim = new QuantumSimulator())
                {
                    var result = PerformAdd.Run(qsim, binaryA, binaryB).Result.Cast<int>().ToArray();

                    //results.Add(string.Join("",result));
                    results.Add(result.ToBase10().ToString());
                }
            }

            Console.Write(results);
            Console.WriteLine("Finished.");
            Console.ReadLine();
        }
    }
}