namespace ComparersWithInt
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
	open QuantumUtils;

	operation LessThan(a: Int[], b: Int[]) : Result {
		return Compare(LessThanInt, a, b);
    }

	operation LessOrEqualThan(a: Int[], b: Int[]) : Result {
		return Compare(LessOrEqualThanInt, a, b);
    }

	operation GreaterOrEqualThan(a: Int[], b: Int[]) : Result {
		return Compare(GreaterOrEqualThanInt, a, b);
    }

	operation GreaterThan(a: Int[], b: Int[]) : Result {
		return Compare(GreaterThanInt, a, b);
    }

	operation Compare(compareOperation: ((Qubit[],Int[], Qubit) => Unit), a: Int[], b: Int[]) : Result {
		if (Length(a) != Length(b)) {
			fail "Mismatch in the number of bits";
		}

		using (qubits = Qubit[6])
        {
			Set(a, qubits[0..4]);

			compareOperation(qubits[0..4], b, qubits[5]);
			
			let result = M(qubits[5]);
			
			ResetAll(qubits);
			
			return result;
		}
    }
    
    operation GreaterOrEqualThanInt(qubits: Qubit[], bits: Int[], result: Qubit) : Unit {
		body(...) {
			let n = Length(bits);
			mutable i = 0;
			while (i<n and bits[i] == 1) {
				set i = i+1;
			}

			if (i < n) {
				Controlled X(qubits[0..i], result);
			
				X(qubits[i]);
				if (i < n-1) {
					Controlled GreaterOrEqualThanInt(qubits[0..i], (qubits[i+1..n-1], bits[i+1..n-1], result));
				} else {
					Controlled X(qubits[0..i], result);
				}
				X(qubits[i]);
			} else {
				Controlled X(qubits[0..i-1], result);
			}
		}
		adjoint (...) {
			GreaterOrEqualThanInt(qubits, bits, result);
		}
		controlled auto;
		//adjoint auto;
	}

	operation GreaterThanInt(qubits: Qubit[], bits: Int[], result: Qubit) : Unit {
		body(...) {
			let n = Length(bits);
			mutable i = 0;
			while (i<n and bits[i] == 1) {
				set i = i+1;
			}

			if (i < n) {
				Controlled X(qubits[0..i], result);
			
				X(qubits[i]);
				if (i < n-1) {
					Controlled GreaterThanInt(qubits[0..i], (qubits[i+1..n-1], bits[i+1..n-1], result));
				}
				X(qubits[i]);
			}
		}adjoint (...) {
			GreaterThanInt(qubits, bits, result);
		}
		controlled auto;
		//adjoint auto;
	}

	operation LessOrEqualThanInt(qubits: Qubit[], bits: Int[], result: Qubit) : Unit {
		body(...) {
			GreaterThanInt(qubits, bits, result);
			X(result);
		}
		controlled auto;
		adjoint auto;
	}

	operation LessThanInt(qubits: Qubit[], bits: Int[], result: Qubit) : Unit {
		body(...) {
			GreaterOrEqualThanInt(qubits, bits, result);
			X(result);
		}
		controlled auto;
		adjoint auto;
	}

	operation EqualToInt(qubits: Qubit[], bits: Int[], result: Qubit) : Unit {
		body(...) {
			let n = Length(bits);
			for (i in 0..n-1) {
				if (bits[i] == 0) {
					X(qubits[i]);
				}
			}
			Controlled X(qubits, result);
			for (i in 0..n-1) {
				if (bits[i] == 0) {
					X(qubits[i]);
				}
			}
		}
		controlled auto;
		adjoint auto;
	}

	operation NotEqualToInt(qubits: Qubit[], bits: Int[], result: Qubit) : Unit {
		body(...) {
			EqualToInt(qubits, bits, result);
			X(result);
		}
		controlled auto;
		adjoint auto;
	}
}
