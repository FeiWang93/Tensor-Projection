using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.Simulation.Simulators;
using System;
using System.Linq;

namespace Tensor
{
    public static class Project
    {
        public static int DnToD1(int[] sizes, int[] subscripts)
        {
            using var qsim = new QuantumSimulator();
            return Convert.ToInt32(Quantum.D1.Run(qsim, new QArray<long>(sizes.Select(Convert.ToInt64).ToArray()), new QArray<long>(subscripts.Select(Convert.ToInt64).ToArray())).Result);
        }

        public static int[] D1ToDn(int[] sizes, int indices)
        {
            using var qsim = new QuantumSimulator();
            return Quantum.Dn.Run(qsim, new QArray<long>(sizes.Select(Convert.ToInt64).ToArray()), indices).Result.Select(Convert.ToInt32).ToArray();
        }
    }
}
