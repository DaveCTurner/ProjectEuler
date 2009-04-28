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

int isAPermutationOf(int n1, int n2) {
	int digits[10];
	int i;
	for (i = 0; i < 10; i++) {
		digits[i] = 0;
	}

	while (n1) {
		digits[n1%10] += 1;
		n1 /= 10;
	}

	while (n2) {
		digits[n2%10] -= 1;
		n2 /= 10;
	}

	for (i = 0; i < 10; i++) {
		if (digits[i]) {
			return 0;
		}
	}
	return 1;
}

int main() {
	fillPrimes();

	int i;
	for (i = 0; i < NUMBER_OF_PRIMES; i++) {
		int p1 = primes[i];
		if (p1 < 1000) {
			continue;
		}
		if (p1 > 9999) {
			break;
		}

		int j;
		for (j = i+1; j < NUMBER_OF_PRIMES; j++) {
			int p2 = primes[j];
			int p3 = p2 - p1 + p2;
			if (p3 > 9999) {
				break;
			}

			if (!isPrime(p3) ||
					!isAPermutationOf(p1, p2) ||
					!isAPermutationOf(p1, p3)) {
				continue;
			}

			printf("%d %d %d\n", p1, p2, p3);
		}
	}
}
