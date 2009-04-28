#include <stdio.h>

/* The 80,000th prime is > 1 million */

#define NUMBER_OF_PRIMES 80000

int primes[NUMBER_OF_PRIMES];

void fillPrimes() {
	primes[0] = 2;
	primes[1] = 3;
	int primeCount = 2;
	int n, p;
	int isPrime;
	for (n = 5; primeCount < NUMBER_OF_PRIMES; n+=2) {
		isPrime = 1;
		for (p = 0; primes[p]*primes[p] <= n && isPrime && p < primeCount; p++) {
			if (n % primes[p] == 0) {
				isPrime = 0;
			}
		}
		if (isPrime) {
			primes[primeCount++] = n;
		}
	}
}

int countPrimeFactors(int n) {
	int factorCount = 0;
	int p;
	for (p = 0; n > 1 && p < NUMBER_OF_PRIMES; p++) {
		if (n % primes[p] == 0) {
			factorCount += 1;
			do {
				n /= primes[p];
			} while (n % primes[p] == 0);
		}
	}
	return factorCount;
}

int main() {
	fillPrimes();

	int n = 1;
	int inARow = 0;

	do {
		if (countPrimeFactors(n) == 4) {
			inARow += 1;
		} else {
			inARow = 0;
		}
		if (inARow == 4) {
			printf("%d\n", n - 3);
			return 0;
		}
		n += 1;
	} while (1);
}
