#include <stdio.h>

#define NUMBER_OF_PRIMES 20000

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

int main() {
	fillPrimes();

	int aMax, bMax, nMax;
	aMax = bMax = nMax = 0;

	int i;
	for (i = 0; i < NUMBER_OF_PRIMES; i++) {
		int b = primes[i];
		if (b >= 1000) {
			break;
		}
		
		int a;
		for (a = -999; a < 1000; a += 2) {
			int n = 0;
			while (isPrime(n*(a+n)+b)) {
				n += 1;
			}
			if (n >= nMax) {
				nMax = n;
				aMax = a;
				bMax = b;
				printf("New record: a=%d b=%d n=%d code=%d\n", a, b, n, a*b);
			}
		}
	}
}
