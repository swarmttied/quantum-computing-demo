namespace Quantum.DJQS {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Convert as Convert;
    open Microsoft.Quantum.Measurement; 
    open Microsoft.Quantum.Arrays;
    
    @EntryPoint()
    operation DJMain() : Result[] {
     
        mutable res  = [Zero,Zero,Zero,Zero];
        let oracles = [Const0, Const1, Balanced0, Balanced1];
        
        for i in 0 .. Length(oracles)-1 {            
            set res w/= i <- Deutch(oracles[i]);          
        }               

        return res;
    }

    operation Deutch(oracle: ((Qubit[]) => Unit)) : Result {
        use qubits = Qubit[2] {
           
            X(qubits[1]);

            H(qubits[0]);
            H(qubits[1]);

            oracle(qubits);

            H(qubits[0]);

            let res = M(qubits[0]);

            ResetAll(qubits);

            return res;
        }   
    }

    operation Const0(qubits: Qubit[]) : Unit {
        ApplyToEach(I, qubits); // You may omit
    }

	operation Const1(qubits: Qubit[]) : Unit {       
        I(qubits[0]);  // You may omit
        X(qubits[1]);      
    }

    operation Balanced0(qubits: Qubit[]) : Unit {
        CNOT(qubits[0], qubits[1]);
    }

    operation Balanced1(qubits: Qubit[]) : Unit {
        CNOT(qubits[0], qubits[1]);
        X(qubits[1]);
    }
}

