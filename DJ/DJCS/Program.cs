using System;

namespace DJCS
{
    class Program
    {
        static void Main()
        {
            Func<char, char>[] oracles = new Func<char, char>[] {
                                           _ => '0',
                                           _ => '1',
                                           o => o,
                                           o => o == '0' ? '1': '0'};

            foreach (var oracle in oracles)
            {
                // NOTE: 2 queries needed
                var first = oracle('0');
                var second = oracle('1');

                Console.Write(first == second ? '0' : '1');
            }
        }
    }
}
