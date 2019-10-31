using System;
using System.Diagnostics;
using System.Linq;
using ClassicUtils;
using QuantumUtils;
using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.Simulation.Simulators;

namespace Quantum.Problem5Part2
{
    class Driver
    {
        private const int TestCount = 1;

        static void Main(string[] args)
        {
            var l = 3;
            var weights = new long[] {2, 4, 3, 3, 3};
            var volumes = new[] {1, 4, 2, 2, 2};

            //var binaryWeights = weights.Select(v => v.ToBase2(3).ToQArray()).ToQArray();
            var binaryVolumes = volumes.Select(v => v.ToBase2(3).ToQArray()).ToQArray();
            var binaryL = l.ToBase2(2).ToQArray();

            var sw = new Stopwatch();
            sw.Start();

            var results = new Results();
            for (int i = 0; i < TestCount; i++)
            {
                using (var qsim = new QuantumSimulator())
                {
                    var bits = Problem5Part2.Run(qsim, weights.ToQArray(), binaryVolumes, binaryL, 3, 1, 2)
                                            .Result.Cast<int>().ToArray();
                    var result = bits.Take(10).ToArray().ToBase10(2);
                    //var fits = bits.Skip(10).First();//.ToBase10(3);
                    var weightsSum = bits.Skip(10).Take(6).ToArray().ToBase10(6);
                    //var weightedSum = bits.Skip(17).Take(6).ToArray().ToBase10(6);
                    //var greaterThanMin = bits.Skip(23).First();
                    //var smallerThanMax = bits.Skip(24).First();
                    results.Add(string.Join("", result)
                                   //+ "_" + string.Join("", fits)
                                   + "_" + string.Join("", weightsSum)
                                   //+ "_" + string.Join("", weightedSum)
                                   //+ "_" + string.Join("", greaterThanMin)
                                   //+ "_" + string.Join("", smallerThanMax)
                                   );
                }
            }

            Console.WriteLine(results);
            Console.WriteLine($"Elapsed: {sw.Elapsed}");
            Console.ReadLine();
        }
    }
}