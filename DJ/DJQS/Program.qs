namespace Quantum.DJQS {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Convert as Convert;
    open Microsoft.Quantum.Measurement; 
    open Microsoft.Quantum.Arrays;    
    
    @EntryPoint()
    operation DJMain() : Result[] {
               
        // 1-qubit oracles        
        let oracles1Qubit = [Const0, Const1, Balanced0, Balanced1];
        
        // 2-qubit oracles      
        // CAUTION! This causes error in IonQ when submitting all items. 
        // From tests, the max number of items accepted is 3. BUG?
        let oracles2Qubit = [
                            //Const0
                            //, Const1
                              Balanced_2Qubit0
                            , Balanced_2Qubit1
                            , Balanced_2Qubit2];
                        //, Balanced_2Qubit3
                        //, Balanced_2Qubit4
                        //, Balanced_2Qubit5];

        // 1-qubit params
        //let oracles = oracles1Qubit;
        //let qbitCount = 1;

        // 2-Qubit params
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
            // Hardcoded logic to cater only for 2-qubit oracle       
            if  bits == 2 {    
                ApplyToEach(X, [qubits[0], qubits[1]]);
                CCNOT(qubits[0], qubits[1], qubits[2]);               
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
        // do nothing
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

