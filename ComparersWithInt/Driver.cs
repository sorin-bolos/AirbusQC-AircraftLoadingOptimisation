using System;
using System.Linq;
using ClassicUtils;
using ComparersWithInt;
using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.Simulation.Simulators;

namespace Quantum.GreaterOrEqualThan
{
    class Driver
    {

        private const int TestCount = 100;
        private const int NumberOfBits = 5;

        static void Main(string[] args)
        {
            for (int a = 0; a < 32; a++)
            {
                for (int b = 0; b < 32; b++)
                {

            //int a = 31;
            //int b = 20;
                    var results = new Results();
                    var binaryA = new QArray<long>(a.ToBase2(NumberOfBits));
                    var binaryB = new QArray<long>(b.ToBase2(NumberOfBits));


                    Console.Write($"a={a} b={b} ");
                    //Console.WriteLine($"binaryA={binaryA} binaryB={binaryB}");

                    for (int i = 0; i < TestCount; i++)
                    {
                        using (var qsim = new QuantumSimulator())
                        {
                            var result = (int)LessOrEqualThan.Run(qsim, binaryA, binaryB).Result;

                            results.Add(result.ToString());
                        }
                    }

                    Console.Write(results);
                }
            }
            Console.WriteLine("Finished.");
            Console.ReadLine();
        }
    }
}