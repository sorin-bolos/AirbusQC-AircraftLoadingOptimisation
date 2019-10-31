namespace Quantum.Problem5
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
	open ComparersWithInt;
	open QuantumUtils;

	   
    operation HelloQ () : Result[] {
		mutable result = new Result[21];
        using (qubits = Qubit[21])
        {
			AllSolutions(qubits);
			AllSolutions2(qubits);

			//X(qubits[18]);
		    //H(qubits[18]);

			//AmplitudeAmplification(qubits);
			
			for (i in 0..20)
			{
				set result w/= i <- M(qubits[i]);
			}

			ResetAll(qubits);
		}
		return result;
    }

	operation AmplitudeAmplification(qubits: Qubit[]) : Unit {
		Oracle(qubits);

		(Adjoint AllSolutions)(qubits);

		PhaseShift(qubits);

		AllSolutions(qubits);
	}

	operation Oracle(qubits: Qubit[]) : Unit {
			Controlled AddInt([qubits[13]],(qubits[4..8] , 2));
			Controlled AddInt([qubits[14]],(qubits[4..8] , 4));
			Controlled AddInt([qubits[15]],(qubits[4..8] , 3));
			Controlled AddInt([qubits[16]],(qubits[4..8] , 3));
			Controlled AddInt([qubits[17]],(qubits[4..8] , 3));

			let min = [0,0,1,1,1];
			GreaterThanInt(qubits[4..8], min, qubits[18]);

			Controlled Adjoint AddInt([qubits[13]],(qubits[4..8] , 2));
			Controlled Adjoint AddInt([qubits[14]],(qubits[4..8] , 4));
			Controlled Adjoint AddInt([qubits[15]],(qubits[4..8] , 3));
			Controlled Adjoint AddInt([qubits[16]],(qubits[4..8] , 3));
			Controlled Adjoint AddInt([qubits[17]],(qubits[4..8] , 3));
	}

	operation AddInt(qubits: Qubit[], x: Int) : Unit {
		body(...) {
			for (i in 1..x) {
				Increment(qubits);
			}
		}
		controlled auto;
		adjoint auto;
		controlled adjoint auto;
	}

	operation PhaseShift(qubits: Qubit[]) : Unit {
		X(qubits[0]);
		X(qubits[1]);
		X(qubits[2]);
		X(qubits[3]);
		X(qubits[13]);
		X(qubits[14]);
		X(qubits[15]);
		X(qubits[16]);
		X(qubits[17]);

		Controlled Z([qubits[0], qubits[1], qubits[2], qubits[3], qubits[13], qubits[14], qubits[15], qubits[16]], qubits[17]);

		X(qubits[0]);
		X(qubits[1]);
		X(qubits[2]);
		X(qubits[3]);
		X(qubits[13]);
		X(qubits[14]);
		X(qubits[15]);
		X(qubits[16]);
		X(qubits[17]);
	}

	operation AllSolutions(qubits: Qubit[]) : Unit {
		body(...) {
			let volumes = [1, 4, 2, 2, 2];
			let weights = [2, 4, 3, 3, 3];
			let maxVolume = [0, 0, 1, 1, 0];
			let maxWeight = [1, 0, 0, 0, 0];
			
			FullShuffle(qubits[0..3]);

			ComputeSum(0, [qubits[13], qubits[0], qubits[1], qubits[2], qubits[3]], volumes, qubits[4..8]);
			LessOrEqualThanInt(qubits[4..8], maxVolume, qubits[12]);
			Adjoint ComputeSum(0, [qubits[13], qubits[0], qubits[1], qubits[2], qubits[3]], volumes, qubits[4..8]);
			ComputeSum(0, [qubits[13], qubits[0], qubits[1], qubits[2], qubits[3]], weights, qubits[4..8]);
			LessOrEqualThanInt(qubits[4..8], maxWeight, qubits[11]);
			  Controlled X([qubits[11], qubits[12]], qubits[13]);
			Adjoint LessOrEqualThanInt(qubits[4..8], maxWeight, qubits[11]);
			Adjoint ComputeSum(0, [qubits[13], qubits[0], qubits[1], qubits[2], qubits[3]], weights, qubits[4..8]);
			ComputeSum(0, [qubits[13], qubits[0], qubits[1], qubits[2], qubits[3]], volumes, qubits[4..8]);
			Adjoint LessOrEqualThanInt(qubits[4..8], maxVolume, qubits[12]);
			Adjoint ComputeSum(0, [qubits[13], qubits[0], qubits[1], qubits[2], qubits[3]], volumes, qubits[4..8]);
			
			
			ComputeSum(1, [qubits[13], qubits[14], qubits[1], qubits[2], qubits[3]], volumes, qubits[4..8]);
			LessOrEqualThanInt(qubits[4..8], maxVolume, qubits[12]);
			Adjoint ComputeSum(1, [qubits[13], qubits[14], qubits[1], qubits[2], qubits[3]], volumes, qubits[4..8]);
			ComputeSum(1, [qubits[13], qubits[14], qubits[1], qubits[2], qubits[3]], weights, qubits[4..8]);
			LessOrEqualThanInt(qubits[4..8], maxWeight, qubits[11]);
			  Controlled X([qubits[11], qubits[12]], qubits[14]);
			Adjoint LessOrEqualThanInt(qubits[4..8], maxWeight, qubits[11]);
			Adjoint ComputeSum(1, [qubits[13], qubits[14], qubits[1], qubits[2], qubits[3]], weights, qubits[4..8]);
			ComputeSum(1, [qubits[13], qubits[14], qubits[1], qubits[2], qubits[3]], volumes, qubits[4..8]);
			Adjoint LessOrEqualThanInt(qubits[4..8], maxVolume, qubits[12]);
			Adjoint ComputeSum(1, [qubits[13], qubits[14], qubits[1], qubits[2], qubits[3]], volumes, qubits[4..8]);
			
			ComputeSum(2, [qubits[13], qubits[14], qubits[15], qubits[2], qubits[3]], volumes, qubits[4..8]);
			LessOrEqualThanInt(qubits[4..8], maxVolume, qubits[12]);
			Adjoint ComputeSum(2, [qubits[13], qubits[14], qubits[15], qubits[2], qubits[3]], volumes, qubits[4..8]);
			ComputeSum(2, [qubits[13], qubits[14], qubits[15], qubits[2], qubits[3]], weights, qubits[4..8]);
			LessOrEqualThanInt(qubits[4..8], maxWeight, qubits[11]);
			  Controlled X([qubits[11], qubits[12]], qubits[15]);
			Adjoint LessOrEqualThanInt(qubits[4..8], maxWeight, qubits[11]);
			Adjoint ComputeSum(2, [qubits[13], qubits[14], qubits[15], qubits[2], qubits[3]], weights, qubits[4..8]);
			ComputeSum(2, [qubits[13], qubits[14], qubits[15], qubits[2], qubits[3]], volumes, qubits[4..8]);
			Adjoint LessOrEqualThanInt(qubits[4..8], maxVolume, qubits[12]);
			Adjoint ComputeSum(2, [qubits[13], qubits[14], qubits[15], qubits[2], qubits[3]], volumes, qubits[4..8]);

			ComputeSum(3, [qubits[13], qubits[14], qubits[15], qubits[16], qubits[3]], volumes, qubits[4..8]);
			LessOrEqualThanInt(qubits[4..8], maxVolume, qubits[12]);
			Adjoint ComputeSum(3, [qubits[13], qubits[14], qubits[15], qubits[16], qubits[3]], volumes, qubits[4..8]);
			ComputeSum(3, [qubits[13], qubits[14], qubits[15], qubits[16], qubits[3]], weights, qubits[4..8]);
			LessOrEqualThanInt(qubits[4..8], maxWeight, qubits[11]);
			  Controlled X([qubits[11], qubits[12]], qubits[16]);
			Adjoint LessOrEqualThanInt(qubits[4..8], maxWeight, qubits[11]);
			Adjoint ComputeSum(3, [qubits[13], qubits[14], qubits[15], qubits[16], qubits[3]], weights, qubits[4..8]);
			ComputeSum(3, [qubits[13], qubits[14], qubits[15], qubits[16], qubits[3]], volumes, qubits[4..8]);
			Adjoint LessOrEqualThanInt(qubits[4..8], maxVolume, qubits[12]);
			Adjoint ComputeSum(3, [qubits[13], qubits[14], qubits[15], qubits[16], qubits[3]], volumes, qubits[4..8]);

			ComputeSum(4, [qubits[13], qubits[14], qubits[15], qubits[16], qubits[17]], volumes, qubits[4..8]);
			LessOrEqualThanInt(qubits[4..8], maxVolume, qubits[12]);
			Adjoint ComputeSum(4, [qubits[13], qubits[14], qubits[15], qubits[16], qubits[17]], volumes, qubits[4..8]);
			ComputeSum(4, [qubits[13], qubits[14], qubits[15], qubits[16], qubits[17]], weights, qubits[4..8]);
			LessOrEqualThanInt(qubits[4..8], maxWeight, qubits[11]);
			  Controlled X([qubits[11], qubits[12]], qubits[17]);
			Adjoint LessOrEqualThanInt(qubits[4..8], maxWeight, qubits[11]);
			Adjoint ComputeSum(4, [qubits[13], qubits[14], qubits[15], qubits[16], qubits[17]], weights, qubits[4..8]);
			ComputeSum(4, [qubits[13], qubits[14], qubits[15], qubits[16], qubits[17]], volumes, qubits[4..8]);
			Adjoint LessOrEqualThanInt(qubits[4..8], maxVolume, qubits[12]);
			Adjoint ComputeSum(4, [qubits[13], qubits[14], qubits[15], qubits[16], qubits[17]], volumes, qubits[4..8]);
		}
		adjoint auto;
	}

	operation AllSolutions2(qubits: Qubit[]) : Unit {
		body(...) {
			let volumes = [1, 4, 2, 2, 2];
			let weights = [2, 4, 3, 3, 3];
			let maxVolume = [0, 0, 1, 1, 0];
			let maxWeight = [1, 0, 0, 0, 0];

			ComputeSum(0, [qubits[9], qubits[14], qubits[15], qubits[16], qubits[17]], volumes, qubits[4..8]);
			LessOrEqualThanInt(qubits[4..8], maxVolume, qubits[12]);
			Adjoint ComputeSum(0, [qubits[9], qubits[14], qubits[15], qubits[16], qubits[17]], volumes, qubits[4..8]);
			ComputeSum(0, [qubits[9], qubits[14], qubits[15], qubits[16], qubits[17]], weights, qubits[4..8]);
			LessOrEqualThanInt(qubits[4..8], maxWeight, qubits[11]);
			  Controlled X([qubits[11], qubits[12]], qubits[9]);
			Adjoint LessOrEqualThanInt(qubits[4..8], maxWeight, qubits[11]);
			Adjoint ComputeSum(0, [qubits[9], qubits[14], qubits[15], qubits[16], qubits[17]], weights, qubits[4..8]);
			ComputeSum(0, [qubits[9], qubits[14], qubits[15], qubits[16], qubits[17]], volumes, qubits[4..8]);
			Adjoint LessOrEqualThanInt(qubits[4..8], maxVolume, qubits[12]);
			Adjoint ComputeSum(0, [qubits[9], qubits[14], qubits[15], qubits[16], qubits[17]], volumes, qubits[4..8]);
			
			
			ComputeSum(1, [qubits[9], qubits[10], qubits[15], qubits[16], qubits[17]], volumes, qubits[4..8]);
			LessOrEqualThanInt(qubits[4..8], maxVolume, qubits[12]);
			Adjoint ComputeSum(1, [qubits[9], qubits[10], qubits[15], qubits[16], qubits[17]], volumes, qubits[4..8]);
			ComputeSum(1, [qubits[9], qubits[10], qubits[15], qubits[16], qubits[17]], weights, qubits[4..8]);
			LessOrEqualThanInt(qubits[4..8], maxWeight, qubits[11]);
			  Controlled X([qubits[11], qubits[12]], qubits[10]);
			Adjoint LessOrEqualThanInt(qubits[4..8], maxWeight, qubits[11]);
			Adjoint ComputeSum(1, [qubits[9], qubits[10], qubits[15], qubits[16], qubits[17]], weights, qubits[4..8]);
			ComputeSum(1, [qubits[9], qubits[10], qubits[15], qubits[16], qubits[17]], volumes, qubits[4..8]);
			Adjoint LessOrEqualThanInt(qubits[4..8], maxVolume, qubits[12]);
			Adjoint ComputeSum(1, [qubits[9], qubits[10], qubits[15], qubits[16], qubits[17]], volumes, qubits[4..8]);
			
			ComputeSum(2, [qubits[9], qubits[10], qubits[18], qubits[16], qubits[17]], volumes, qubits[4..8]);
			LessOrEqualThanInt(qubits[4..8], maxVolume, qubits[12]);
			Adjoint ComputeSum(2, [qubits[9], qubits[10], qubits[18], qubits[16], qubits[17]], volumes, qubits[4..8]);
			ComputeSum(2, [qubits[9], qubits[10], qubits[18], qubits[16], qubits[17]], weights, qubits[4..8]);
			LessOrEqualThanInt(qubits[4..8], maxWeight, qubits[11]);
			  Controlled X([qubits[11], qubits[12]], qubits[18]);
			Adjoint LessOrEqualThanInt(qubits[4..8], maxWeight, qubits[11]);
			Adjoint ComputeSum(2, [qubits[9], qubits[10], qubits[18], qubits[16], qubits[17]], weights, qubits[4..8]);
			ComputeSum(2, [qubits[9], qubits[10], qubits[18], qubits[16], qubits[17]], volumes, qubits[4..8]);
			Adjoint LessOrEqualThanInt(qubits[4..8], maxVolume, qubits[12]);
			Adjoint ComputeSum(2, [qubits[9], qubits[10], qubits[18], qubits[16], qubits[17]], volumes, qubits[4..8]);

			ComputeSum(3, [qubits[9], qubits[10], qubits[18], qubits[19], qubits[17]], volumes, qubits[4..8]);
			LessOrEqualThanInt(qubits[4..8], maxVolume, qubits[12]);
			Adjoint ComputeSum(3, [qubits[9], qubits[10], qubits[18], qubits[19], qubits[17]], volumes, qubits[4..8]);
			ComputeSum(3, [qubits[9], qubits[10], qubits[18], qubits[19], qubits[17]], weights, qubits[4..8]);
			LessOrEqualThanInt(qubits[4..8], maxWeight, qubits[11]);
			  Controlled X([qubits[11], qubits[12]], qubits[19]);
			Adjoint LessOrEqualThanInt(qubits[4..8], maxWeight, qubits[11]);
			Adjoint ComputeSum(3, [qubits[9], qubits[10], qubits[18], qubits[19], qubits[17]], weights, qubits[4..8]);
			ComputeSum(3, [qubits[9], qubits[10], qubits[18], qubits[19], qubits[17]], volumes, qubits[4..8]);
			Adjoint LessOrEqualThanInt(qubits[4..8], maxVolume, qubits[12]);
			Adjoint ComputeSum(3, [qubits[9], qubits[10], qubits[18], qubits[19], qubits[17]], volumes, qubits[4..8]);

			ComputeSum(4, [qubits[9], qubits[10], qubits[18], qubits[19], qubits[20]], volumes, qubits[4..8]);
			LessOrEqualThanInt(qubits[4..8], maxVolume, qubits[12]);
			Adjoint ComputeSum(4, [qubits[9], qubits[10], qubits[18], qubits[19], qubits[20]], volumes, qubits[4..8]);
			ComputeSum(4, [qubits[9], qubits[10], qubits[18], qubits[19], qubits[20]], weights, qubits[4..8]);
			LessOrEqualThanInt(qubits[4..8], maxWeight, qubits[11]);
			  Controlled X([qubits[11], qubits[12]], qubits[20]);
			Adjoint LessOrEqualThanInt(qubits[4..8], maxWeight, qubits[11]);
			Adjoint ComputeSum(4, [qubits[9], qubits[10], qubits[18], qubits[19], qubits[20]], weights, qubits[4..8]);
			ComputeSum(4, [qubits[9], qubits[10], qubits[18], qubits[19], qubits[20]], volumes, qubits[4..8]);
			Adjoint LessOrEqualThanInt(qubits[4..8], maxVolume, qubits[12]);
			Adjoint ComputeSum(4, [qubits[9], qubits[10], qubits[18], qubits[19], qubits[20]], volumes, qubits[4..8]);
		}
		adjoint auto;
	}

	operation FullShuffle(qubits: Qubit[]) : Unit {
		body(...) {
			let n = Length(qubits);
			for (i in 0..n-1)
			{
				H(qubits[i]);
			}
		}
		adjoint auto;
	}

	operation Increment(qubits: Qubit[]) : Unit {
		body (...) {
			Controlled X(qubits[1..4], qubits[0]);
			Controlled X(qubits[2..4], qubits[1]);
			Controlled X(qubits[3..4], qubits[2]);
			CNOT(qubits[4], qubits[3]);
			X(qubits[4]);
		}
		controlled auto;
		adjoint auto;
		adjoint controlled auto;
	}

	operation ComputeSum(targetIndex: Int, controlQubits: Qubit[], values: Int[], results: Qubit[]) : Unit {
		body (...) {
		let n = Length(values);
			for (i in 0..n-1)
			{
				if (i == targetIndex) {
					AddInt(results, values[i]);
				} else {
					Controlled AddInt([controlQubits[i]], (results, values[i]));
				}
			}
		}
		adjoint auto;
		controlled auto; 
		adjoint controlled auto;
	}
}
