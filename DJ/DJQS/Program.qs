namespace Quantum.DJQS {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Convert as Convert;
    open Microsoft.Quantum.Measurement; 
    open Microsoft.Quantum.Arrays;    

    @EntryPoint()
    operation DJMain() : Result[] {
               
        // 1-qubit oracles        
        let oracles1Qubit = [Const0, Const1, Balanced0, Balanced1, Const0, Const1, Balanced0, Balanced1];
        
        // WARNING!! 
        // IonQ.qpu target does NOT allow re-use of qubits even after calling reset.
        // The number of oracles x qubits per oracle should be less than the qubits.
        // For example, if there is 11 qubits available, you can only run 3 3-qubit oracles
        let oracles2Qubit = [
                             Const0
                            ,Const1
                            , Balanced_2Qubit0
                            , Balanced_2Qubit1
                            , Balanced_2Qubit2
                            , Balanced_2Qubit3
                            , Balanced_2Qubit4                            
                            , Balanced_2Qubit5
                           ];

        // 1-qubit p (2 qubits including ancilla)
        //let oracles = oracles1Qubit;
        //let qbitCount = 1;

        // 2-Qubit params (3 qubits including ancilla)
        let oracles = oracles2Qubit;
        let qbitCount = 2;

        mutable results = ConstantArray(Length(oracles),Zero);
        
        for i in 0 .. Length(oracles)-1 {            
            set results w/= i <- DeutschJozsa(qbitCount,oracles[i]);          
        }               

        return results;
    }
       

    operation DeutschJozsa(bits: Int, oracle: ((Qubit[]) => Unit)) : Result {
        use qubits = Qubit[bits + 1] {
                    
            X(qubits[bits]);

            ApplyToEach(H,qubits);
           
            oracle(qubits);

            ApplyToEach(H,qubits);          

            mutable result = Zero;   

            // Hardcoded logic for 1-qubit oracles
            if (bits == 1){
                set result = M(qubits[0]);
            }
        
            // Hardcoded logicfor 2-qubit oracles     
            if  bits == 2 {       
                ApplyToEach(X, [qubits[0], qubits[1]]);
                CCNOT(qubits[0], qubits[1], qubits[2]);  
                set result = M(qubits[bits]);
            }      

            set result = M(qubits[bits]);

            ResetAll(qubits);

            return result;
        }   
    }

    /////////////////////////////////////////////
    //These 2 are universal oracles. It can be used
    // by any n-qubit oracles
    operation Const0(qubits: Qubit[]) : Unit {
        // This is universal and can be used by any
        // n-qubit oracle. It's equal to doing nothing.
        ApplyToEach(I, qubits); 
    }

	operation Const1(qubits: Qubit[]) : Unit {      
        let indexOfAncilla = Length(qubits)-1;
        X(qubits[indexOfAncilla]);    
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

