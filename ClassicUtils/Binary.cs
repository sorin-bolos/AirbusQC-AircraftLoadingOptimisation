using System;
using System.Collections.Generic;
using System.Linq;

namespace ClassicUtils
{
    public static class Binary
    {
        public static long[] ToBase2(this int number)
        {
            var result = new List<long>();
            while (number > 0)
            {
                result.Add(number % 2);
                number = number / 2;
            }

            result.Reverse();
            return result.ToArray();
        }

        public static int ToBase10(this int[] bits)
        {
            var result = 0;
            for (int i = 0; i < bits.Length; i++)
            {
                result += (int)Math.Pow(2, (bits.Length - 1 - i)) * bits[i];
            }
            return result;
        }

        public static int[] ToBase10(this int[] bits, int numberOfBits)
        {
            int[] nodes = new int[bits.Length / numberOfBits];

            int skip = 0;
            int take = numberOfBits;
            while (skip * numberOfBits < bits.Length)
            {
                var nodeTag = bits.Skip(skip * numberOfBits).Take(numberOfBits).ToArray();
                var node = ToBase10(nodeTag);
                nodes[skip] = node;

                skip++;
            }

            return nodes;
        }

        public static long[] ToBase2(this int number, int numberOfBits)
        {
            var result = new long[numberOfBits];
            int index = numberOfBits-1;
            while (number > 0)
            {
                result[index] = number % 2;
                number = number / 2;
                index--;
            }

            return result;
        }
    }
}
