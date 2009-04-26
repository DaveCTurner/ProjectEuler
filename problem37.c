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

int isPrime(int n) {
	if (n > primes[NUMBER_OF_PRIMES-1]) {
		fprintf(stderr, "Cannot test %d for primality: too large\n", n);
		return 0;
	}
	if (n < 2) {
		return 0;
	}

	/* printf("Testing %d\n", n); */

	int left = 0;
	int right = NUMBER_OF_PRIMES;
	while (right != left) {
		int mid = (right+left)/2;
		/* printf("Range [%d, %d] : %d\n", left, right, mid); */
		if (primes[mid] < n) {
			left = mid + 1;
		} else if (primes[mid] > n) {
			right = mid;
		} else {
			return 1;
		}
	}
	return 0;
}

int digits(int n) {
	if (n > 999999999) return 10;
	if (n > 99999999)  return 9;
	if (n > 9999999)   return 8;
	if (n > 999999)    return 7;
	if (n > 99999)     return 6;
	if (n > 9999)      return 5;
	if (n > 999)       return 4;
	if (n > 99)        return 3;
	if (n > 9)         return 2;
	if (n > 0)         return 1;
	return 0;
}

int largestPowerOfTen(int n) {
	if (n > 999999999) return 1000000000;
	if (n > 99999999)  return 100000000;
	if (n > 9999999)   return 10000000;
	if (n > 999999)    return 1000000;
	if (n > 99999)     return 100000;
	if (n > 9999)      return 10000;
	if (n > 999)       return 1000;
	if (n > 99)        return 100;
	if (n > 9)         return 10;
	if (n > 0)         return 1;
	return 0;
}

int truncateRight(int n) {
	return n / 10;
}

int truncateLeft(int n) {
	return n % largestPowerOfTen(n);
}

int main() {
	fillPrimes();
	int truncatablePrimesTotal = 0;
	
	int i;
	for (i = 0; i < NUMBER_OF_PRIMES; i++) {
		int n = primes[i];
		if (n < 10) continue;
		do {
			n = truncateRight(n);
		} while (n && isPrime(n));
		if (0 == n) {
			n = primes[i];
			do {
				n = truncateLeft(n);
			} while (n && isPrime(n));
			if (0 == n) {
				printf("%d\n", primes[i]);
				truncatablePrimesTotal += primes[i];
			}
		}	
	}

	printf("Total: %d\n", truncatablePrimesTotal);
}
