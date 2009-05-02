using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Diagnostics;

namespace ConsoleApplication1
{
    public class BigInteger : List<int> {
        public void Accumulate(IList<int> summand) {
            int carry = 0;
            for (int i = 0; i < this.Count || i < summand.Count || carry != 0; i++) {
                if (i < this.Count) {
                    if (i < summand.Count) {
                        this[i] += summand[i] + carry;
                    } else {
                        this[i] += carry;
                    }
                } else {
                    if (i < summand.Count) {
                        this.Add(summand[i] + carry);
                    } else {
                        this.Add(carry);
                    }
                }
                carry = 0;
                while (this[i] >= 10) {
                    this[i] -= 10;
                    carry += 1;
                }
            }
        }

        public override string ToString() {
            StringBuilder sb = new StringBuilder();
            for (int i = Count - 1; i >= 0; i--) {
                sb.Append(this[i]);
            }
            return sb.ToString();
        }
    }

    class Program
    {
        static void Main(string[] args) {
            Stopwatch sw = new Stopwatch();

            sw.Start();

            BigInteger n = new BigInteger { 3 };
            BigInteger d = new BigInteger { 2 };
            int longerNumeratorCount = 0;
            for (int i = 1; i <= 1000; i++) {
                if (n.Count > d.Count) {
                    longerNumeratorCount += 1;
                }
                //Debug.WriteLine(string.Format("{0} {1}/{2}", i, n, d));
                n.Accumulate(d);
                //Debug.WriteLine(string.Format("{0} {1}/{2}", i, n, d));
                BigInteger t = n;
                n = d;
                d = t;
                //Debug.WriteLine(string.Format("{0} {1}/{2}", i, n, d));
                n.Accumulate(d);
                //Debug.WriteLine(string.Format("{0} {1}/{2}", i, n, d));
            }
            Debug.WriteLine(longerNumeratorCount);

            sw.Stop();
            Debug.WriteLine(sw.Elapsed.TotalSeconds);
        }
    }
}
