#include <stdio.h>
#include <math.h>

#define MAX_PRIME (10*1000*1000)
char * isComposite;

int fillComposites() {
	isComposite = malloc(MAX_PRIME);
	if (0 == isComposite) {
		printf("Allocation failure\n");
		return 1;
	}
	memset(isComposite, 0, MAX_PRIME);
	isComposite[0] = 1;
	isComposite[1] = 1;
	int i;
	for (i = 2; i < MAX_PRIME; i++) {
		if (isComposite[i]) {
			continue;
		}

		int j;
		for (j = 2 * i; j < MAX_PRIME; j += i) {
			isComposite[j] = 1;
		}
	}
	return 0;
}

int isPrime(int n) {
	if (0 <= n && n < MAX_PRIME) {
		return (0 == isComposite[n]);
	}

	fprintf(stderr, "%d out of range\n", n);
	return 0;
}

int eulerTotient(int n) {
	int tot = n;
	int p = 2;
	while (p*p <= n) {
		if (0 == (n % p)) {
			tot = tot / p * (p-1);
			do {
				n /= p;
			} while (0 == (n % p));
		}
		do { p++; } while (isComposite[p]);
	}
	if (n > 1) {
		tot = tot / n * (n-1);
	}
	return tot;
}

int isPermutation(int m, int n) {
	int digits[10];
	memset(digits, 0, 10 * sizeof(int));

	while (m) {
		digits[m % 10] += 1;
		m /= 10;
	}
	while (n) {
		digits[n % 10] -= 1;
		n /= 10;
	}
	
	int d;
	for (d = 0; d < 10; d++) {
		if (digits[d] != 0) {
			return 0;
		}
	}
	return 1;
}

int main() {
	if (fillComposites()) {
		return 1;
	}

	/* This is a brute-force solution. It would be more elegant to notice that
	once we have a small ratio (the first one found is 1.000938)
	this places a lower bound on the prime factors of the number.

	1.000938 means that prime factors must all be > 1067
	since 1067/1066 > 1.000938.

	which means that there must be at most 2 prime factors since 1067^3 > 10^7.

	and it can't be prime because then phi(p) = p-1 and there is no p
	such that p-1 is a permutation of p.
	*/

	// Calculate cube root of MAX_PRIME as if minPrime^3 > MAX_PRIME
	// then the answer must be the product of 2 prime factors.
	double minPrimeBoundary = exp((log(MAX_PRIME))/3) - 1;

	int n;
	double bestRatio = 2.0;
	double minPrime = bestRatio / (bestRatio - 1);
	for (n = 2; n < MAX_PRIME; n++) {
		if (!isComposite[n]) { continue; }

		int t = eulerTotient(n);
		if (bestRatio * t <= n) { continue; }

		if (isPermutation(n, t)) {
			bestRatio = (1.0 * n) / t;
			minPrime = bestRatio / (bestRatio - 1);
			if (minPrime > minPrimeBoundary) {
				break;
			}
			printf("%d %d %f %d\n", n, t, bestRatio, (int)minPrime);
		}
	}

	if (n != MAX_PRIME) {
		// Bailed out - ratio got good enough that
		// we know it's just two primes.
		printf("bailed out at %d\n", n);
		int p1 = minPrime - 1;
		while (p1 * p1 <= MAX_PRIME) {
			while (p1 < minPrime - 1) { p1++; }
			do { p1 ++; } while (isComposite[p1]);

			int p2 = p1;
			while (p1 * p2 <= MAX_PRIME) {
				int n = p1 * p2;
				int t = (p1 - 1) * (p2 - 1);

				double ratio = (1.0 * n) / t;
				if (ratio < bestRatio && isPermutation(n, t)) { 
					bestRatio = ratio;
					minPrime = bestRatio / (bestRatio - 1);
					printf("%d %d %f %d\n", n, t, bestRatio, (int)minPrime);
				}
			
				do { p2 ++; } while (isComposite[p2]);
			}
		}
	}
}
