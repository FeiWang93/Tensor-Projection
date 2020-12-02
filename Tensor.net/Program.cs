using System;

namespace Tensor
{
    class Program
    {
        static void Main(string[] args)
        {
            var D1_Index = Project.DnToD1(new int[] { 2, 3, 4 }, new int[] { 1, 1, 2 });
            Console.WriteLine($"DnToD1: [1, 1, 2] --> {D1_Index}"); // 18

            var Dn_Array = Project.D1ToDn(new int[] { 2, 3, 4 }, 18);
            Console.WriteLine($"D1ToDn: 18 --> [{string.Join(", ", Dn_Array)}]"); // 1,1,2

            Console.ReadKey();
        }
    }
}
