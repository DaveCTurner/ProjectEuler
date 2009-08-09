#include <stdio.h>

#define MAX_LENGTH 1500000

int length_count[MAX_LENGTH+1];

int hcf (int a, int b) {
	while (a > 0) {
		while (a <= b) {
			b -= a;
		}
		int t = a; a = b; b = t;
	}
	return b;
}

int main() {
	int i;
	for (i = 0; i <= MAX_LENGTH; i++) {
		length_count[i] = 0;
	}

	/*
	 *  Use this result: a Pythagorean triple is a set (a, b, c) such that a^2
	 *  + b^2 = c^2. A primitive triple is one where a, b, and c are coprime.
	 *  This means that they are mutually coprime, because a^2 + b^2 = c^2. It
	 *  also means that a < c and b < c. Considering their parity, precisely
	 *  one of a, b and c is even. So far, this is symmetric in a and b; to
	 *  break the symmetry if c is odd (so either a or b is even) then let b
	 *  be the even one, and if c is even (so both a and b are odd) then let a
	 *  be the smaller one.
	 *
	 *  Since a is odd, and a^2 = c^2 - b^2 = (c-b)(c+b), it follows that c-b
	 *  and c+b must both be square (else they share factors and hence a, b, c
	 *  share factors). Writing c+b=x^2 and c-b=y^2 means that c = (x^2+y^2)/2
	 *  and b = (x^2-y^2)/2 and a = xy. Therefore x and y must both be odd,
	 *  since a is odd, and y < x since 0 < b.
	 *
	 *  Thus to enumerate all primitive Pythagorean triples, enumerate all odd
	 *  x and y < x, calculate a, b, and c as above, ensure that they are all
	 *  pairwise coprime and that a < b if b is odd. To enumerate all triples,
	 *  simple enumerate the multiples of each primitive one.
	 */

	int x, y;
	for (x = 1; x <= MAX_LENGTH; x += 2) {
		if (x * x > 2 * MAX_LENGTH) { break; }
		for (y = x - 2; y > 0; y -= 2) {
			if (y * y > 2 * MAX_LENGTH) { break; }
			if (x * y > MAX_LENGTH) { break; }
			
			int c = (x*x + y*y)/2;
			int b = c - y*y;
			int a = x*y;

			if (1 != hcf(a, b)) { continue; }
			if (1 != hcf(b, c)) { continue; }
			if (1 != hcf(a, c)) { continue; }
			if ((1 == (b % 2)) && b <= a) { continue; }

			int p_primitive = a+b+c;

			int p;
			for (p = p_primitive; p <= MAX_LENGTH; p += p_primitive) {
				if (length_count[p] > 1000000) { continue; }
				length_count[p] += 1;
			}
		}
	}

	int total = 0;
	for (i = 1; i <= MAX_LENGTH; i++) {
//		printf("Length = %7d, count = %d\n", i, length_count[i]);
		if (1 == length_count[i]) {
			total += 1;
		}
	}

	printf("%d\n", total);

	return 0;
}
