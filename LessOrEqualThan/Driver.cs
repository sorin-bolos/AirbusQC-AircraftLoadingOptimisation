using System;
using System.Linq;
using ClassicUtils;
using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.Simulation.Simulators;

namespace Quantum.LessOrEqualThan
{
    class Driver
    {
        private const int TestCount = 100;
        private const int NumberOfBits = 3;

        static void Main(string[] args)
        {
            //var a = new Random().Next(0, 7);
            //var b = new Random().Next(0, 7);
            for (int a = 0; a < 8; a++)
            {
                for (int b = 0; b < 8; b++)
                {
                    var results = new Results();
                    var binaryA = new QArray<long>(Binary.ToBase2(a, NumberOfBits).Select(n => (long)n));
                    var binaryB = new QArray<long>(Binary.ToBase2(b, NumberOfBits).Select(n => (long)n));


                    Console.WriteLine($"a={a} b={b}");
                    Console.WriteLine($"binaryA={binaryA} binaryB={binaryB}");

                    for (int i = 0; i < TestCount; i++)
                    {
                        using (var qsim = new QuantumSimulator())
                        {
                            var result = (int)LessThanOrEqual.Run(qsim, binaryA, binaryB).Result;

                            results.Add(result.ToString());
                        }
                    }

                    Console.WriteLine(results);
                }
            }
            Console.WriteLine("Finished.");
            Console.ReadLine();
        }
    }
}