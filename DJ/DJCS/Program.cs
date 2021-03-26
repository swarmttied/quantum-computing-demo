using System;

namespace DJCS
{
    class Program
    {
        static void Main()
        {
            // Just for convenience, we use bool {false=0, true=1}
            // Using "b" for bit
            var oracles = new Func<bool, bool>[] {
                                            // Const
                                           _ => false,
                                           _ => true,
                                           // Balanced
                                           b0 => b0,
                                           b0 => !b0 };

            foreach (var oracle in oracles)
            {
                // NOTE: 2 queries needed
                var first = oracle(false);
                var second = oracle(true);

                Console.Write(first == second ? '0' : '1');
            }

            Console.WriteLine();

            var twoBitOracles = new Func<bool,bool,bool>[] {
                                            (_,__) => false, // I(b0) or do nothing
                                            (_,__) => true,  // X(b0)
                                            // Balanced
                                            (b1,b2) =>  b1,                  // CNOT(b1,b0)
                                            (b1,b2) => !b1,                  // CNOT(b1,b0), X(b0)
                                            (b1,b2) => {
                                                            b2=b1; 
                                                            return b2;
                                                        } ,       // CNOT(b2,b0)
                                            (b1,b2) => {
                                                            b2=b1; 
                                                            return !b2;
                                                        },   // CNOT(b2,b0) X(b0)
                                          
                                        
                                            
            };


            foreach (var oracle in twoBitOracles) 
            {
               
               Console.Write(oracle(false,false)? "1":"0");
               Console.Write(oracle(false,true)?"1":"0");
               Console.Write(oracle(true,true)?"1":"0");
               Console.Write(oracle(true,false)?"1":"0");   
               Console.WriteLine();           
            }
        }            
    }
}
