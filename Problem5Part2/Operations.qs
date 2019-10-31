namespace Quantum.Problem5Part2
{
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Arithmetic;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
	open Microsoft.Quantum.Diagnostics;
	open Microsoft.Quantum.Environment;
	open Microsoft.Quantum.Convert;
	open Microsoft.Quantum.Arrays;
	open QuantumUtils;
	open ComparersWithInt;
	open Quantum.QuantumComparers;
	open ValueAdders;
    
    operation Problem5Part2(weights: Int[], volumes: Int[][],
	                        l: Int[],
							nuberOfBitsForWeghts: Int,
							minGCenter: Int,
							maxGCenter: Int) : Result[] {
		let n = Length(weights);
		let m = Length(l);
		let o = nuberOfBitsForWeghts;
		if (Length(volumes) != n) {
			fail "Volumes and weights are inconsistent.";
		}

		let qubitCount = n * m;
        using (qubits = Qubit[qubitCount]) {
		//using (arrangeRepresentation = Qubit()) {
		using (greaterThanMin = Qubit()) {
		using (lessThanMax = Qubit()) {
			
			let bags = CreateBags(qubits, n, m);
			HadamardAll(qubits);
			Message("Maximum superposition set");
			//Set([0,0], qubits[0..1]);
			//Set([0,0], qubits[2..3]);
			//Set([0,0], qubits[4..5]);
			//Set([0,1], qubits[6..7]);
			//Set([0,1], qubits[8..9]);

			//Message("Checking fit...");
			//Oracle(bags, volumes, n, m, o, arrangeRepresentation);
			//Message("Fit checked");

			using (weightSumQubits = Qubit[o + 3]) {
			//using (weightedSumQubits = Qubit[o + 3]) {
				
				//Message("Computing weighted sum...");
				//WeightedSum(bags, weights, 32, weightedSumQubits);
				//Message("Weighted sum computed");

				Message("Computing sum of weights...");
				ControlledSum(bags, weights, weightSumQubits);
				Message("sum of weights computed");

				let le = LittleEndian(Reversed(weightSumQubits));
				
				Message("Computing minimum...");
				MultiplyByModularInteger(minGCenter, 32, le);
				Message("Minimum comuted");

				//Message("Comparing weighted sum to minimum...");
				//Greater(weightedSumQubits, weightSumQubits, greaterThanMin);
				//Message("Compare finished");
				Message("Reversing min computation...");
				Adjoint MultiplyByModularInteger(minGCenter, 31, le);
				Message("Min computation reversed");
				
				Message("Computing max...");
				MultiplyByModularInteger(maxGCenter, 31, le);
				Message("Max computed...");
				//Message("Comparing weighted sum to max...");
				//Smaller(weightedSumQubits, weightSumQubits, lessThanMax);
				//Message("Compare finished");
				Message("Reversing max computation...");
				Adjoint MultiplyByModularInteger(maxGCenter, 31, le);
				Message("Max computation reversed");

				
				Message("Measuring...");
				let results = MeasureAll(qubits 
										//+ [arrangeRepresentation] 
										+ weightSumQubits 
										//+ weightedSumQubits
										//+ [greaterThanMin] + [lessThanMax]
										);

				ResetAll(weightSumQubits);
				//ResetAll(weightedSumQubits);
				ResetAll(qubits);
				//Reset(arrangeRepresentation);
				return results;
			}
			//}
		}
		}
		//}
		}
    }

	operation Oracle(bags: Qubit[][], volumes: Int[][], n: Int, m: Int, o: Int, oracleResult: Qubit) : Unit {
		using (errorCounters = Qubit[o]){
			GetErrorCount(bags, volumes, errorCounters);
			EqualToInt(errorCounters, [0, 0, 0], oracleResult);
			Adjoint GetErrorCount(bags, volumes, errorCounters);
		}
	}

	operation GetErrorCount(bags: Qubit[][], volumes: Int[][], errorCounters: Qubit[]) : Unit
	is Adj {
		let n = Length(bags);
		let m = Length(bags[0]);
		using (notEqualResult = Qubit()) {
			for (i in 0..n-1) {
				let zero = new Int[m];
				NotEqualToInt(bags[i], zero, notEqualResult);
						
				if (BinaryEqual(volumes[i], [0, 1, 0])) {
					Controlled IncrementErrorsIfEqualites([notEqualResult], (bags[i], bags[0..i-1] + bags[i+1..n-1], errorCounters, [0,0,0]));
				}

				if (BinaryEqual(volumes[i], [1, 0, 0])) {
					Controlled IncrementErrorsIfEqualites([notEqualResult], (bags[i], bags[0..i-1] + bags[i+1..n-1], errorCounters, [0,0,0]));
					Increment(bags[i]);
					Controlled IncrementErrorsIfEqualites([notEqualResult], (bags[i], bags[0..i-1] + bags[i+1..n-1], errorCounters, [0,0,0]));
					Adjoint Increment(bags[i]);
				}

				if (BinaryEqual(volumes[i], [0, 0, 1])) {
					Controlled IncrementErrorsIfEqualites([notEqualResult], (bags[i], bags[0..i-1] + bags[i+1..n-1], errorCounters, [0,0,1]));
				}

				Adjoint NotEqualToInt(bags[i], zero, notEqualResult);
			}
		}
	}

	operation IncrementErrorsIfEqualites(toCompare: Qubit[], compareWith: Qubit[][],
										   errorCounters: Qubit[], noOfEqualitiesAllowed: Int[]) : Unit
	is Adj + Ctl {
		let o = Length(errorCounters);
		using (equalityCounters = Qubit[o]) {
			CountBitStringsThatAreEqual(toCompare, compareWith, equalityCounters);

			using (notEqualResult = Qubit()) {
				GreaterThanInt(equalityCounters, noOfEqualitiesAllowed, notEqualResult);
				Controlled Increment([notEqualResult], errorCounters);
				Adjoint GreaterThanInt(equalityCounters, noOfEqualitiesAllowed, notEqualResult);
			}

			Adjoint CountBitStringsThatAreEqual(toCompare, compareWith, equalityCounters);
		}
	}

	operation CountBitStringsThatAreEqual(toCompare: Qubit[], compareWith: Qubit[][], noOfEquals: Qubit[]) : Unit 
	is Adj + Ctl {
		let n = Length(compareWith);
		for (i in 0..n-1) {
			using (equalityResult = Qubit()) {
				Equal(toCompare, compareWith[i], equalityResult);
				Controlled Increment([equalityResult], noOfEquals);
				Adjoint Equal(toCompare, compareWith[i], equalityResult);
			}
		}
	}

	function CreateBags(qubits: Qubit[], numberOfBags: Int, qubitPerBag: Int) : Qubit[][] {
		mutable bags = new Qubit[][numberOfBags];
		for (i in 0..numberOfBags-1) {
			set bags w/= i <- qubits[qubitPerBag*i..qubitPerBag*i+qubitPerBag-1];
		}
		return bags;
	}

	operation ControlledSum(controlQubits: Qubit[][], values: Int[], target: Qubit[]) : Unit
	is Adj + Ctl {
		
		let n = Length(target);
		let littleEndian = LittleEndian(target[n-1..-1..0]);
		ApplyPhaseLEOperationOnLECA(AddValuesToPhase(controlQubits, values, _), littleEndian);
	}

	operation AddValuesToPhase(controlQubitStrings: Qubit[][], values: Int[], target: PhaseLittleEndian) : Unit
	is Adj + Ctl {
		let n = Length(controlQubitStrings);
		if (n != Length(values)) {
			fail "controlQubits and values must have the same number of elements";
		}
		using (compareResult = Qubit()) {
			for (i in 0..n-1) {
				NotEqualToInt(controlQubitStrings[i], new Int[Length(controlQubitStrings[i])], compareResult);
				Controlled IncrementPhaseByInteger([compareResult], (values[i], target));
				Adjoint NotEqualToInt(controlQubitStrings[i], new Int[Length(controlQubitStrings[i])], compareResult);
			}
		}
	}
}
