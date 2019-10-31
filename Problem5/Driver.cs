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
                    //var x = Binary.ToBase10(bits.Skip(9).Take(3).ToArray());
                    //var compare = Binary.ToBase10(bits.Skip(12).Take(1).ToArray());
                    //var result = bits.Skip(13).Take(5).ToArray();

                    results.Add(string.Join("",part1) + string.Join("", part2));

                    //AddResult(string.Join("", bits));

                    //results.Add(//string.Join("", ancillas) 
                    //            "_" + volume 
                    //            + "_" + x 
                    //            + "_" + compare
                    //    + "_" + string.Join("", result));
                    //Console.WriteLine(string.Join("", result));
                }
            }

            Console.WriteLine(results);
            Console.WriteLine("Finished.");
            Console.ReadLine();
        }
    }
}