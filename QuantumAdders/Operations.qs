namespace QuantumAdders
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
	open QuantumUtils;

	operation PerformAdd(a: Int[], b: Int[]) : Result[] {

		using (quantumA = Qubit[Length(a)]) {
		using (quantumB = Qubit[Length(b)]) {
		using (carryOut = Qubit()) {
			Set(a, quantumA);
			Set(b, quantumB);

			Add(quantumA, quantumB, carryOut);
						
			let result = MeasureAll([carryOut] + quantumB);
			
			ResetAll(quantumA);
			ResetAll(quantumB);
			Reset(carryOut);

			return result;
		}
		}
		}
    }

	operation Add(a: Qubit[], target: Qubit[], carryOut: Qubit) : Unit
	is Adj + Ctl {
		let n = Length(a);
		if (n != Length(target)) {
			fail "Inconsistent number of bits";
		}
		
		if (n <= 3) {
			AdderOn3BitsOrLess(a, target, carryOut);
		} else {
			AddOn4BitsPlus(a, target, carryOut);
		}
	}

	operation AddOn4BitsPlus(a: Qubit[], target: Qubit[], carryOut: Qubit) : Unit
	is Adj + Ctl {
		let n = Length(a);
		if (n != Length(target)) {
			fail "Inconsistent number of bits";
		}
		using(carryIn = Qubit()) {
			let A = a[n-1..-1..0];
			let B = target[n-1..-1..0];
			for (i in 1..n-1) {
				CNOT(A[i], B[i]);
			}

			CNOT(A[1], carryIn);

			Controlled X([A[0], B[0]], carryIn);
			CNOT(A[2], A[1]);

			Controlled X([carryIn, B[1]], A[1]);
			CNOT(A[3], A[2]);

			for (i in 2..n-3) {
				Controlled X([A[i-1], B[i]], A[i]);
				CNOT(A[i+2], A[i+1]);
			}

			Controlled X([A[n-3], B[n-2]], A[n-2]);
			CNOT(A[n-1], carryOut);

			Controlled X([A[n-2], B[n-1]], carryOut);
			for (i in 1..n-2) {
				X(B[i]);
			}

			CNOT(carryIn, B[1]);
			for (i in 2..n-1) {
				CNOT(A[i-1], B[i]);
			}

			Controlled X([A[n-3], B[n-2]], A[n-2]);
			for (i in n-3..-1..2) {
				Controlled X([A[i-1], B[i]], A[i]);
				CNOT(A[i+2], A[i+1]);
				X(B[i+1]);
			}

			Controlled X([carryIn, B[1]], A[1]);
			CNOT(A[3], A[2]);
			X(B[2]);

			Controlled X([A[0], B[0]], carryIn);
			CNOT(A[2], A[1]);
			X(B[1]);

			CNOT(A[1], carryIn);

			for (i in 0..n-1) {
				CNOT(A[i], B[i]);
			}
		}
	}

	operation AdderOn3BitsOrLess(a: Qubit[], target: Qubit[], carryOut: Qubit) : Unit 
	is Adj + Ctl {
		let n = Length(a);

		if (n != Length(target)) {
			fail "Inconsistent number of qbits";
		}
			   
		let reversedA = a[n-1..-1..0];
		let reversedB = target[n-1..-1..0];
		using (carryIn = Qubit()) {
			Majority(carryIn, reversedB[0], reversedA[0]);
			for (i in 0..n-2) {
				Majority(reversedA[i], reversedB[i+1], reversedA[i+1]);
			}

			CNOT(reversedA[n-1], carryOut);

			for (i in n-2..-1..0) {
				UnMajorityAndAdd2(reversedA[i], reversedB[i+1], reversedA[i+1]);
			}
			UnMajorityAndAdd2(carryIn, reversedB[0], reversedA[0]);
		}
	}

	operation Majority(c: Qubit, b: Qubit, a: Qubit) : Unit
	is Adj + Ctl {
		CNOT(a, c);
		CNOT(a, b);
		Controlled X([c, b], a);
	}

	operation UnMajorityAndAdd1(c: Qubit, b: Qubit, a: Qubit) : Unit
	is Adj + Ctl {
		Controlled X([c, b], a);
		CNOT(a, c);
		CNOT(c, b);
	}

	operation UnMajorityAndAdd2(c: Qubit, s: Qubit, a: Qubit) : Unit
	is Adj + Ctl {
		X(s);
		CNOT(c, s);
		Controlled X([c, s], a);
		X(s);
		CNOT(a, c);
		CNOT(a, s);
	}
}
