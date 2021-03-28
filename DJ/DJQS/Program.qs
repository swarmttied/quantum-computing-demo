namespace Quantum.DJQS {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Convert as Convert;
    open Microsoft.Quantum.Measurement; 
    open Microsoft.Quantum.Arrays;
    
    @EntryPoint()
    operation DJMain() : Result[] {
     
        // 1-qubit oracles
        mutable results  = [Zero,Zero,Zero,Zero];
        let oracles1 = [Const0, Const1, Balanced0, Balanced1];
        
        // 2-qubit oracles
        // mutable results  = [Zero,Zero,Zero,Zero,Zero,Zero,Zero,Zero];
        // let oracles2 = [Const0, Const1, Balanced_2Qubit0, Balanced_2Qubit1, Balanced_2Qubit2, 
        //                 Balanced_2Qubit3, Balanced_2Qubit4, Balanced_2Qubit5];
        
        for i in 0 .. Length(oracles1)-1 {            
            set results w/= i <- DeutchJozsa(1,oracles1[i]);    // 1-qit oracle

            // set results w/= i <- DeutchJozsa(2,oracles2[i]);   // 2-qubit oracles      
        }               

        return results;
    }

    operation DeutchJozsa(bits: Int, oracle: ((Qubit[]) => Unit)) : Result {
        use qubits = Qubit[bits + 1] {
                    
            X(qubits[bits]);

            ApplyToEach(H,qubits);
           
            oracle(qubits);

            for i in 0 .. bits-1 {
                H(qubits[i]);
            }            

            mutable result = Zero;   
            // Hardcoded logic to cater only for 2-qubit oracle       
            if  bits == 2 {                
                ApplyToEach(H, qubits);
                ApplyToEach(X, [qubits[0], qubits[1]]);
                CCNOT(qubits[0], qubits[1], qubits[2]);               
            }

            set result = M(qubits[bits-1]);

            ResetAll(qubits);

            return result;
        }   
    }

    /////////////////////////////////////////////
    // Const can be used by any n-qubit oracles
    operation Const0(qubits: Qubit[]) : Unit {
        // do nothing
    }

	operation Const1(qubits: Qubit[]) : Unit {      
        X(qubits[1]);      
    }

    //////////////////////////////////////////////////
    // 1-qbit balanced oracles
    operation Balanced0(qubits: Qubit[]) : Unit {
        CNOT(qubits[0], qubits[1]);
    }

    operation Balanced1(qubits: Qubit[]) : Unit {
        CNOT(qubits[0], qubits[1]);
        X(qubits[1]);
    }

    //////////////////////////////////////////////////////////
    // 2-qbit balanced oracles
    operation Balanced_2Qubit0(qubits: Qubit[]) : Unit {
        CNOT(qubits[0], qubits[2]);
    }

    operation Balanced_2Qubit1(qubits: Qubit[]) : Unit {
        CNOT(qubits[0], qubits[2]);
        X(qubits[2]);
    }

    operation Balanced_2Qubit2(qubits: Qubit[]) : Unit {
        CNOT(qubits[1], qubits[2]);        
    }

    operation Balanced_2Qubit3(qubits: Qubit[]) : Unit {
        CNOT(qubits[1], qubits[2]);  
        X(qubits[2]);
    }

    operation Balanced_2Qubit4(qubits: Qubit[]) : Unit {
        CNOT(qubits[0],qubits[2]);
        CNOT(qubits[1],qubits[2]);
    }

    operation Balanced_2Qubit5(qubits: Qubit[]) : Unit {
        CNOT(qubits[0],qubits[2]);
        CNOT(qubits[1],qubits[2]);
        X(qubits[2]);
    }



}

