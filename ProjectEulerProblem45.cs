using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ProjectEuler
{
    abstract class NumberSequence : IEnumerable<uint>
    {
        public abstract IEnumerator<uint> GetEnumerator();

        System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() {
            return GetEnumerator();
        }
    }

    static class NumberSequenceOperations
    {
        public static IEnumerable<uint> IntersectWith
            (this IEnumerable<uint> sequence1, IEnumerable<uint> sequence2) {
            IEnumerator<uint> enumerator1 = sequence1.GetEnumerator();
            IEnumerator<uint> enumerator2 = sequence2.GetEnumerator();
            if (!enumerator1.MoveNext()) { yield break; }
            if (!enumerator2.MoveNext()) { yield break; }
            do {
                if (enumerator1.Current == enumerator2.Current) {
                    yield return enumerator1.Current;
                }
                if (enumerator1.Current < enumerator2.Current) {
                    if (!enumerator1.MoveNext()) { yield break; }
                } else {
                    if (!enumerator2.MoveNext()) { yield break; }
                }
            } while (true);
        }
    }

    abstract class ClosedFormNumberSequence : NumberSequence
    {
        protected abstract uint CalculateNthTerm(uint n);

        public override IEnumerator<uint> GetEnumerator() {
            uint n = 0;
            while (true) {
                n += 1;
                yield return CalculateNthTerm(n);
            }
        }
    }

    class HexagonalNumbers : ClosedFormNumberSequence
    {
        protected override uint CalculateNthTerm(uint n) {
            return n * (2 * n - 1);
        }
    }

    class PentagonalNumbers : ClosedFormNumberSequence
    {
        protected override uint CalculateNthTerm(uint n) {
            return n * (3 * n - 1) / 2;
        }
    }

    class TriangularNumbers : ClosedFormNumberSequence
    {
        protected override uint CalculateNthTerm(uint n) {
            return n * (n + 1) / 2;
        }
    }

    class ProjectEulerProblem45
    {
        static void Main(string[] args) {
            foreach (uint i in
                    new TriangularNumbers()
                    .IntersectWith(new HexagonalNumbers()
                    .IntersectWith(new PentagonalNumbers()))
                    .Where(n => n > 40755)
                    .Take(1)) {
                Console.WriteLine(i);
            }
        }
    }
}
