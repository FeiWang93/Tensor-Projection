namespace Tensor.Quantum
{
    //// PM> Install-Package Microsoft.Quantum.Development.Kit // Provides support for developing quantum algorithms in the Q# programming language.
    //// PM> Install-Package Microsoft.Quantum.Standard // Microsoft's Quantum standard libraries.

    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Arrays;

    /// # Summary
    /// Projecting the multidimensional tensor index position to unidimensional vector index position, the types of input parameters are two integer arrays of the same size.
    /// # Input
    /// ## sizes
    /// Integer array composed of multidimensional tensor size; each element represents the corresponding size.
    /// ## subscripts
    /// Integer array composed of multidimensional tensor index subscript, one-to-one corresponding to the members in [sizes]!
    /// # Output
    /// Return unidimensional vector index position. This position is coded according to the parameters of [sizes] prior traverse from right to left. It needs to reverse the order of [sizes], when prior traverse from left to right.
    /// # Example
    /// C# ：using (var qsim = new QuantumSimulator());
    /// C# ：var subscript = Quantum.D1.Run(qsim, new QArray<long>(2, 3, 4), new QArray<long>(1, 2, 3).Result;
    operation D1(sizes : Int[], subscripts : Int[]) : Int {
        mutable totalBackCutterLength = 0;
        for i in 0 .. Length(sizes) - 1 {
            set totalBackCutterLength += Multiplier((sizes[i] - subscripts[i] - 1), Aggregator(Multiplier, 1, sizes[i + 1 ...]));
        }              
        return Aggregator(Multiplier, 1, sizes) - totalBackCutterLength - 1;
    }

    /// # Summary
    /// Projecting the unidimensional vector index position to multidimensional tensor index position, the types of input parameters are one integer and one integer array respectively. 
    /// # Input
    /// ## sizes
    /// Integer array composed of multidimensional tensor size; each element represents the corresponding size.
    /// ## indices
    /// Unidimensional vector index position (Integer). This position is coded according to the parameters of [sizes] prior travers from right to left. It needs to reverse the order of [size], when prior traverse from left to right!
    /// # Output
    /// Return array composed of multidimensional tensor index subscript, one-to-one corresponding to the members in [size].
    /// # Example
    /// C# ：using (var qsim = new QuantumSimulator());
    /// C# ：var subscripts = Dn.Run(qsim, new QArray<long>(new long[] { 2, 3, 4 }), 6).Result;
    operation Dn(sizes : Int[], indices : Int) : Int[] {
        let dimensions = Length(sizes);
        mutable resultArray = new Int[dimensions];
        for i in 0 .. dimensions - 1 {
            mutable cutterLength = 0;
            for j in i .. -1 .. 1 {
                set cutterLength += Multiplier(resultArray[j - 1], Aggregator(Multiplier, 1, sizes[j ...]));
		    }
            let iPosition = indices + 1 - cutterLength;
            let iLength = Aggregator(Multiplier, 1, sizes[i + 1 ...]);
            set resultArray w/= i <- iPosition / iLength + (iPosition % iLength == 0 ? 0 | 1) - 1;
        }
        return resultArray;
    }

    /// # Summary
    /// Multiplier
    /// # Input
    /// ## a
    /// The first integer number (>=0)
    /// ## b
    /// The second integer number (>=0)
    /// # Output
    /// Integer output (>=0)
    operation Multiplier(a : Int, b : Int): Int {        
        //// The parameter n is the qubit to store the max of a and b. It can be calculated according to the maximum binary digit between a and b. 
        //// If a<=15 and b<=15, 4 can be assigned to n; if a<=31 and b<=31, 5 can be assigned to n; the other values can be analogized from this. Currently, standby would occur when simulating 8 qubits!
        //let n = 4; 
        //using ((aqs, bqs, resultqs) = (Qubit[n], Qubit[n], Qubit[2 * n])) { // Allocate qubit array.
        //    // ApplyXorInPlace is Applies the Pauli X Qubit gate operations to qubits in a little-endian register based on 1 bits in an integer.
        //    ApplyXorInPlace(a, LittleEndian(aqs));
        //    ApplyXorInPlace(b, LittleEndian(bqs));
        //    // ApplyXorInPlace(0, LittleEndian(resultqs)); // When it gets allocated a qubit is always in the Zero state.
        //    // Multiply integer aqs by integer bqs and store the result in resultqs, which must be zero initially.
        //    Microsoft.Quantum.Arithmetic.MultiplyI(LittleEndian(aqs),LittleEndian(bqs),LittleEndian(resultqs));
        //    mutable resultMeasured = MeasureInteger(LittleEndian(resultqs)); // Measure the qubit array value, getting classical data back that can be used in classical logic. The state of Qubit after a measurement "collapses" into one of the classical states.
        //    // Given an array of qubits, measure them and ensure they are in the |0⟩ state such that they can be safely released.
        //    ResetAll(aqs + bqs + resultqs);
        //    return resultMeasured;
        //}
        return a * b;
    } 
   
    /// # Summary
    /// Aggregation Operator
    /// # Input
    /// ## aggregator
    /// Iterative function (It needs this function to have two input parameters and return the same operating output.)
    /// ## initialValue
    /// Initialization value
    /// ## inputArray
    /// Iterated array
    /// # Output
    /// Calculated output
    operation Aggregator<'T>(aggregator : (('T, 'T) => 'T), initialValue : 'T, inputArray : 'T[]) : 'T {
        mutable currentValue = initialValue;
        for (idx, element) in Enumerated(inputArray){
            set currentValue = aggregator(currentValue, element);
        }
        return currentValue;
    }
}