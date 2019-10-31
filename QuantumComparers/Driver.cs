using System;
using System.Linq;
using ClassicUtils;
using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.Simulation.Simulators;

namespace Quantum.QuantumComparers
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
                    var binaryA = new QArray<long>(a.ToBase2(NumberOfBits));
                    var binaryB = new QArray<long>(b.ToBase2(NumberOfBits));


                    Console.Write($"a={a} b={b} binaryA={binaryA} binaryB={binaryB} ");

                    for (int i = 0; i < TestCount; i++)
                    {
                        using (var qsim = new QuantumSimulator())
                        {
                            var result = CompareQubitStrings.Run(qsim, binaryA, binaryB).Result;

                            var s = "";
                            s = result == Result.Zero ? " a >= b" : "a < b ";
//                            if (result.Item2 == Result.Zero)
//                            {
//                                s = "equal";
//                            }
//                            else
//                            {
//                                s = result.Item1 == Result.One ? "greater" : "less";
//                            }
                            results.Add(s);
                        }
                    }

                    Console.WriteLine(results);
                    Console.WriteLine();
                }
            }
            Console.WriteLine("Finished.");
            Console.ReadLine();
        }
    }
}