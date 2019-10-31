namespace Quantum.QuantumComparers
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
	open QuantumUtils;

	operation CompareQubitStrings(a: Int[], b: Int[]) : Result {
		let n = Length(a);
		if (Length(b) != n) {
			fail "Mismatch in the number of bits";
		}

		using (quantumA = Qubit[n]) {
		using (quantumB = Qubit[n]) {
		using (quantumResult = Qubit()) {

			Set(a, quantumA);
			Set(b, quantumB);

			Smaller(quantumA, quantumB, quantumResult);
			
			let result = M(quantumResult);
			
			ResetAll(quantumA);
			ResetAll(quantumB);
			Reset(quantumResult);
			
			return result;
		}
		}
		}
    }

	operation Equal(a: Qubit[], b: Qubit[], result: Qubit) : Unit 
	is Adj + Ctl {
		body(...) {
			Different(a, b, result);
			X(result);
		}
		adjoint auto;
		controlled auto;
		adjoint controlled auto;
	}

	operation Greater(a: Qubit[], b: Qubit[], target: Qubit) : Unit 
	is Adj + Ctl {
		body(...) {
			using (different = Qubit()) {
			using (greater = Qubit()) {
				Compare(a, b, greater, different);
				CNOT(greater, target);
				Adjoint Compare(a, b, greater, different);
			}
			}
		}
		adjoint auto;
		controlled auto;
		adjoint controlled auto;
	}

	operation Smaller(a: Qubit[], b: Qubit[], target: Qubit) : Unit 
	is Adj + Ctl {
		body(...) {
			using (different = Qubit()) {
			using (greater = Qubit()) {
				Compare(a, b, greater, different);
				X(greater);
				CCNOT(different, greater, target);
				X(greater);
				Adjoint Compare(a, b, greater, different);
			}
			}
		}
		adjoint auto;
		controlled auto;
		adjoint controlled auto;
	}

    operation Compare(a: Qubit[], b: Qubit[], greater: Qubit, different: Qubit) : Unit 
	is Adj + Ctl {
		body(...) {
		let n = Length(a);
		X(different);
		using(ancillas = Qubit[n+1]) {
			for (i in 0..n-1) {
				Subtract(ancillas[i], a[n-1-i], b[n-1-i], ancillas[i+1]);
				X(b[n-1-i]);
			}
			CNOT(ancillas[n], greater);
			Controlled X(b, different);
			for (i in n-1..-1..0) {
				X(b[n-1-i]);
				Adjoint Subtract(ancillas[i], a[n-1-i], b[n-1-i], ancillas[i+1]);
			}
		}
		}
    }

	operation Different(a: Qubit[], b: Qubit[], different: Qubit) : Unit 
	is Adj + Ctl {
		let n = Length(a);
		X(different);
		using(ancillas = Qubit[n+1]) {
			for (i in 0..n-1) {
				Subtract(ancillas[i], a[n-1-i], b[n-1-i], ancillas[i+1]);
				X(b[n-1-i]);
			}
			Controlled X(b, different);
			for (i in n-1..-1..0) {
				X(b[n-1-i]);
				Adjoint Subtract(ancillas[i], a[n-1-i], b[n-1-i], ancillas[i+1]);
			}
		}
    }

	operation Subtract(carryIn: Qubit, a: Qubit, b: Qubit, carryOut: Qubit) : Unit 
	is Adj + Ctl {
		body (...) {
			CNOT(carryIn, b);
			Controlled X([carryIn, b], carryOut);
			CNOT(a, b);
			Controlled X([a, b], carryOut);
		}
		adjoint auto;
	}
}
