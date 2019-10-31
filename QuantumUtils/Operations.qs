namespace QuantumUtils
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
	open Microsoft.Quantum.Convert;
	open Microsoft.Quantum.Arrays;
	open Microsoft.Quantum.Arithmetic;

	operation MeasureAll(qubits: Qubit[]) : Result[] {
		let n = Length(qubits);
		mutable results = new Result[n];
		for (i in 0..n-1) {
			set results w/= i <- M(qubits[i]);
		}
		return results;
	}
		
	operation HadamardAll(qubits: Qubit[]) : Unit {
		body(...) {
			let n = Length(qubits);
			for (i in 0..n-1)
			{
				H(qubits[i]);
			}
		}
		adjoint auto;
	}

	operation XAll(qubits: Qubit[]) : Unit {
		body(...) {
			let n = Length(qubits);
			for (i in 0..n-1)
			{
				X(qubits[i]);
			}
		}
		adjoint auto;
	}

	operation SetValue(value: Int, qubits: Qubit[]) : Unit
	is Adj + Ctl {
		let binary = IntAsBoolArray(value, Length(qubits));
		SetBool(Reversed(binary), qubits);
	}

	operation Set(bits: Int[], qubits: Qubit[]) : Unit
	is Adj + Ctl {
		for (i in 0..Length(bits)-1)
		{
			if (bits[i] == 1)
			{
				X(qubits[i]);
			}
		}
	}

	operation SetBool(bits: Bool[], qubits: Qubit[]) : Unit
	is Adj + Ctl {
		for (i in 0..Length(bits)-1)
		{
			if (bits[i])
			{
				X(qubits[i]);
			}
		}
	}

	operation PhaseShift(qubits: Qubit[]) : Unit {
		let n = Length(qubits);
		XAll(qubits);
		Controlled Z(qubits[0..n-2], qubits[n-1]);
		XAll(qubits);
	}

	operation SetPartitionedArray(qubits: Qubit[], values: Int[], bitCount: Int) : Qubit[][] {
		let n = Length(values);
		if (Length(qubits) != bitCount*n) {
			fail "Cannot partition qubit array";
		}

		mutable elements = new Qubit[][n];
		for (i in 0..n-1) {
			set elements w/= i <- qubits[bitCount*i..bitCount*i+bitCount-1];
			SetValue(values[i], elements[i]);
		}

		return elements;
	}

	operation MeasureIntegerArray(qubits: Qubit[][]) : Int[] {
		let n = Length(qubits);
		mutable values = new Int[n];
		for(i in IndexRange(qubits)) {
			let littleEndian = LittleEndian(Reversed(qubits[i]));
			set values w/= i <- MeasureInteger(littleEndian);		
		}
		return values;
	}

	function BinaryEqual(a: Int[], b: Int[]) : Bool {
		let n = Length(a);
		for (i in 0..n-1) {
			if (a[i] != b[i]) {
				return false;
			}
		}
		return true;
	}

	function PartitionArray(qubits: Qubit[], qubitsPerElement: Int) : Qubit[][] {
		let elementCount = Length(qubits)/qubitsPerElement;
		mutable elements = new Qubit[][elementCount];
		for (i in 0..elementCount-1) {
			set elements w/= i <- qubits[qubitsPerElement*i..qubitsPerElement*i+qubitsPerElement-1];
		}
		return elements;
	}
}
