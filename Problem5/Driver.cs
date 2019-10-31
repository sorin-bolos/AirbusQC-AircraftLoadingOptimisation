using System;
using System.Linq;
using Microsoft.Quantum.Simulation.Simulators;
using ClassicUtils;

namespace Quantum.Problem5
{
    class Driver
    {
        private const int TestCount = 100;

        static void Main(string[] args)
        {
            Console.WriteLine("Aircraft Loading Optimization");
            Console.WriteLine("Container volumes: [1, 4, 2, 2, 2]");
            Console.WriteLine("Container weights: [2, 4, 3, 3, 3]");
            Console.WriteLine("Max volume: 6 ([0, 0, 1, 1, 0] in binary)");
            Console.WriteLine("Max weight: 10 ([0, 1, 0, 1, 0] in binary)");
            Console.WriteLine($"Running {TestCount} times");
            Console.WriteLine();

            var results = new Results();
            for (int i = 0; i < TestCount; i++)
            {
                using (var qsim = new QuantumSimulator())
                {
                    var bits = HelloQ.Run(qsim).Result.Cast<int>().ToArray();
                    var ancillas = bits.Take(4).ToArray();
                    var volume = Binary.ToBase10(bits.Skip(4).Take(5).ToArray());
                    var part1 = bits.Skip(9).Take(2).ToArray();
                    var part2 = bits.Skip(18).Take(3).ToArray();
                    var oracle = bits.Skip(21).First();

                    results.Add(string.Join("",part1) + string.Join("", part2));

                }
            }

            Console.WriteLine(results);
            Console.WriteLine("Finished.");
            Console.ReadLine();
        }
    }
}