#include <stdio.h>

#define MAX_PRIME (1000)
char * isComposite;

int fillComposites() {
	isComposite = malloc(MAX_PRIME);
	if (0 == isComposite) {
		printf("Allocation failure\n");
		return 1;
	}

	int iMax = (int)ceil(sqrt((double)MAX_PRIME));
	
	memset(isComposite, 0, MAX_PRIME);
	isComposite[0] = 1;
	isComposite[1] = 1;
	int i;
	for (i = 2; i <= iMax; i++) {
		if (isComposite[i]) {
			continue;
		}

		int j;
		for (j = i * i; j < MAX_PRIME; j += i) {
			isComposite[j] = 1;
		}
	}
	return 0;
}

int hcf(int a, int b) {
	while (a) {
		b = b % a;
		int t = a; a = b; b = t;
	}
	return b;
}

int countSolutions(int n) {
/*
 * Count solutions to 1/x + 1/y = 1/n. Such solutions are in bijection with
 * the set of pairs of coprime factors of n:
 *
 * if (x',y') are coprime factors of n then writing h = n(x'+y')/(x'y')
 * implies that 1/(hx') + 1/(hy') = 1/n; conversely if (x,y) are a solution
 * then writing h = hcf(x,y) implies that (x/h, y/h) are coprime factors of n,
 * and these operations are mutual inverses.
 *
 * Furthermore x'<=y' iff x<=y, so considering solutions as unordered pairs is
 * the same as considering unordered pairs of coprime factors of n.
 *
 * This works recursively. First, if n = 1 then there is one solution, namely
 * 1/2+1/2. If n > 1 then 1/2n+1/2n is a solution, and all other solutions
 * have distinct x and y and hence distinct x' and y'.
 */
 	if (1 == n) {
		return 1;
	}

	/*
	 * Suppose that k>0 is the power of the prime p in n. Let n' = n/(p^k).
	 * If (w,z) are coprime factors of n' then each
	 * (w p^l, z) and (w, z p^l) are coprime factors of n for 0 <= l <= k.
	 * (Don't count the solution (w p^0, z) = (w, z p^0) = (w, z) twice)
	 *
	 * Therefore there are (2*k+1)*count(n') solutions.
	 */
	int currentPrime = 0;
	while (isComposite[currentPrime] || (n % currentPrime)) {
		currentPrime += 1;
		if (currentPrime > MAX_PRIME) {
			currentPrime = n;
			break;
		}
	}

	int k = 0;
	while (0 == (n % currentPrime)) {
		n /= currentPrime;
		k += 1;
	}
 
 	return (2 * k + 1) * countSolutions(n);
}

/*
 * This means that countSolutions(n) is the product of (2*k_i+1) where
 * k_i is the power of p_i in n.
 *
 * Since we're looking for the smallest n such that countSolutions(n) > X,
 * makes sense to look for products of odd numbers exceeding X.
 *
 * Since 3^17 > 1000000 >= X, won't need more than 17 odd numbers.
 */

#define X 1000

int bestSoFar = 0;

int enumerateDescendingPrimePowers(int primeCount, int * primes,
		int * powers, int depth,
		int countAccumulator,
		int primeAccumulator) {
	
	if (depth >= primeCount) {
		if ((countAccumulator-1)/2 + 1 > X) {
			if (0 == bestSoFar || bestSoFar > primeAccumulator) {
				bestSoFar = primeAccumulator;
				printf("%d\n", primeAccumulator);
			}
#ifdef DEBUG
			int i;
			int n = 1;
			int first = 1;
			for (i = 0; i < primeCount; i++) {
				if (powers[i]) {
					if (first) {
						first = 0;
					} else {
						printf(" * ");
					}
					printf("%d^%d", primes[i], powers[i]);

					int j;
					for (j = 0; j < powers[i]; j++) {
						n *= primes[i];
					}
				}
			}
			printf(" = %d (acc = %d = ", n, accumulator);
			first = 1;
			for (i = 0; i < primeCount; i++) {
				if (powers[i]) {
					if (first) {
						first = 0;
					} else {
						printf(" * ");
					}
					printf("%d", 2 * powers[i] + 1);
				}
			}
			printf(")\n");
#endif
		}
		return 0;
	}
	
	int i;
	powers[depth] = -1;
	do {
		powers[depth] += 1;
		if (depth != 0 && powers[depth] > powers[depth-1]) {
			/* Not descending */
			break;
		}
		if (bestSoFar != 0 && primeAccumulator >= bestSoFar) {
			/* Already done better */
			break;
		}
		enumerateDescendingPrimePowers(primeCount, primes, powers,
			depth + 1, countAccumulator * (2 * powers[depth] + 1),
			primeAccumulator);

		primeAccumulator *= primes[depth];
	} while (countAccumulator * (2 * powers[depth] + 1) <= X);
}

int main() {
	fillComposites();

	int smallPrimes[17];
	
	int i;
	int currentPrime = 0;
	for (i = 0; i < 17; i++) {
		do { currentPrime++; } while (isComposite[currentPrime]);
		smallPrimes[i] = currentPrime;
		printf("%d ", currentPrime);
	}
	printf("\n");
	

	/* Powers of the first 17 primes in n */
	int primePowers[17];
	memset(primePowers, 0, 17 * sizeof(int));
	
	/*
	 * Prime powers should be descending, otherwise reordering them will yield
	 * a lower n with the same countSolutions() value.
	 */
	enumerateDescendingPrimePowers(17, smallPrimes, primePowers, 0, 1, 1);
	 
}
