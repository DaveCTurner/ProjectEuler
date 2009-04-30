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

void tryReplaceDigits(char * buffer, int bufferSize, int digit) {
	char 
}

int main() {
	fillPrimes();
	int truncatablePrimesTotal = 0;
	char primeBuffer[13];
	
	int i;
	for (i = 0; i < NUMBER_OF_PRIMES; i++) {
		int n = primes[i];
		snprintf(primeBuffer, 13, "%d", n);
		tryReplaceDigits(primeBuffer, 13, 0);
		tryReplaceDigits(primeBuffer, 13, 1);
		tryReplaceDigits(primeBuffer, 13, 2);
		tryReplaceDigits(primeBuffer, 13, 3);
	}
}
