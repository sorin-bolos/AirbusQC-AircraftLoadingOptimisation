namespace Quantum.LessOrEqualThan
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    
	 operation LessThanOrEqual(a: Int[], b: Int[]) : Result {
		if (Length(a) != Length(b)) {
			fail "Mismatch in the number of bits";
		}

		using (qubits = Qubit[7])
        {
			Set(a, qubits[0..2]);
			Set(b, qubits[3..5]);

			LessThanOrEqual3Bit(qubits[0..2], qubits[3..5], qubits[6]);
			
			let result = M(qubits[6]);
			
			ResetAll(qubits);
			
			return result;
		}
    }

	operation Set(bits: Int[], qubits: Qubit[]) : Unit {
		for (i in 0..Length(bits)-1)
		{
			if (bits[i] == 1)
			{
				X(qubits[i]);
			}
		}
	}

    operation LessThanOrEqual3Bit(a: Qubit[], b: Qubit[], result: Qubit) : Unit {
		X(b[0]);
		Controlled X([a[0], b[0]], result);
		X(b[0]);

		X(a[0]);
		X(b[0]);
		X(b[1]);
		Controlled X([a[0], a[1], b[0], b[1]], result);
		X(a[0]);
		X(b[0]);
		X(b[1]);

		X(a[0]);
		X(a[1]);
		X(b[0]);
		X(b[1]);
		X(b[2]);
		Controlled X([a[0], a[1], a[2], b[0], b[1], b[2]], result);
		X(a[0]);
		X(a[1]);
		X(b[0]);
		X(b[1]);
		X(b[2]);

		X(b[1]);
		Controlled X([a[0], a[1], b[0], b[1]], result);
		X(b[1]);

		X(b[2]);
		Controlled X([a[0], a[1], a[2], b[0], b[1], b[2]], result);
		X(b[2]);

		X(a[0]);
		X(b[0]);
		X(b[2]);
		Controlled X([a[0], a[1], a[2], b[0], b[1], b[2]], result);
		X(a[0]);
		X(b[0]);
		X(b[2]);

		X(a[1]);
		X(b[1]);
		X(b[2]);
		Controlled X([a[0], a[1], a[2], b[0], b[1], b[2]], result);
		X(a[1]);
		X(b[1]);
		X(b[2]);

		X(result);
    }
}
