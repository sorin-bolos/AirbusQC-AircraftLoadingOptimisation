namespace ValueAdders
{
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
	open Microsoft.Quantum.Arithmetic;
	open Microsoft.Quantum.Convert;
	open Microsoft.Quantum.Arrays;
	open QuantumUtils;

	operation Sum(values: Int[]) : Result[] {
		let n = Length(values);
		
		using (controlQubits = Qubit[n]) {
		using (targetQubits = Qubit[5]) {
			
			for (i in 0..n-1) {
				H(controlQubits[i]);
			}

			ControlledSum(controlQubits, values, targetQubits);
			
			let result = MeasureAll(targetQubits);
			
			ResetAll(controlQubits);
			ResetAll(targetQubits);
			return result;
		}
		}
    }

	operation ComputeWeightedSum(values: Int[], weights: Int[]) : Int {
		let n = Length(values);
		if (n != Length(weights)) {
			fail "controlQubits and values must have the same number of elements";
		}

		let numberOfBits = 3;
		
		using (qubits = Qubit[n * numberOfBits]) {
		using (targetQubits = Qubit[5]) {
			
			let terms = SetPartitionedArray(qubits, values, numberOfBits);

			WeightedSum(terms, weights, 32, targetQubits);

			let result = MeasureInteger(LittleEndian(Reversed(targetQubits)));
			
			ResetAll(qubits);
			ResetAll(targetQubits);
			return result;
		}
		}
    }
    
    operation Increment(qubits: Qubit[]) : Unit 
	is Adj + Ctl {
		body (...) {
			let n = Length(qubits);
			for (i in 0..n-3) {
				Controlled X(qubits[i+1..n-1], qubits[i]);
			}
			CNOT(qubits[n-1], qubits[n-2]);
			X(qubits[n-1]);
		}
	}

	operation AddValue(a: Int, target: Qubit[]) : Unit
	is Adj + Ctl {
		let n = Length(target);
		let littleEndian = LittleEndian(target[n-1..-1..0]);
		IncrementByInteger(a, littleEndian);
	}

	operation ControlledSum(controlQubits: Qubit[], values: Int[], target: Qubit[]) : Unit
	is Adj + Ctl {
		
		let n = Length(target);
		let littleEndian = LittleEndian(target[n-1..-1..0]);
		ApplyPhaseLEOperationOnLECA(AddValuesToPhase(controlQubits, values, _), littleEndian);
	}

	operation AddValuesToPhase(controlQubits: Qubit[], values: Int[], target: PhaseLittleEndian) : Unit
	is Adj + Ctl {
		let n = Length(controlQubits);
		if (n != Length(values)) {
			fail "controlQubits and values must have the same number of elements";
		}

		for (i in 0..n-1) {
			Controlled IncrementPhaseByInteger([controlQubits[i]], (values[i], target));
		}
	}

	operation WeightedSum(terms: Qubit[][], weights: Int[], modulus: Int, target: Qubit[]) : Unit
	is Adj + Ctl {
		let littleEndian = LittleEndian(Reversed(target));
		ApplyPhaseLEOperationOnLECA(AddPhaseWeightedTerms(terms, weights, modulus, _), littleEndian);
	}

	operation AddPhaseWeightedTerms(terms: Qubit[][], weights: Int[], modulus: Int, target: PhaseLittleEndian) : Unit
	is Adj + Ctl {
		let n = Length(terms);
		if (n != Length(weights)) {
			fail "terms and weights must have the same number of elements";
		}

		for (i in 0..n-1) {
			let littleEndian = LittleEndian(Reversed(terms[i]));
			MultiplyAndAddPhaseByModularInteger(weights[i], modulus, littleEndian, target);
		}
	}
}
