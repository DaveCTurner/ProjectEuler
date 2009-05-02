#include <stdio.h>

/* The 80,000th prime is > 1 million */

#define NUMBER_OF_PRIMES 800000

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
		//fprintf(stderr, "Cannot test %d for primality: too large\n", n);
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

// 9C3 possibilities for common difference
// (not 10C3 since assuming no overflow)
#define COMMON_DIFFERENCE_COUNT 84
int commonDifferences[COMMON_DIFFERENCE_COUNT];

void fillCommonDifferences() {
	int power1, power2, power3;
	int i = 0;
	for (power1 = 100; power1 < 1000000000; power1 *= 10) {
		for (power2 = 10; power2 < power1; power2 *= 10) {
			for (power3 = 1; power3 < power2; power3 *= 10) {
				commonDifferences[i++] = power1 + power2 + power3;
			}
		}
	}
	if (COMMON_DIFFERENCE_COUNT != i) {
		printf("Found %d common differences, expected %d\n", i,
			COMMON_DIFFERENCE_COUNT);
	}
}

int matchingDigits(int p, int cd) {
	int dig = -1;
	while (cd) {
		if (cd % 10) {
			if (-1 == dig) {
				dig = p % 10;
				if (dig > 2) {
					return -1;
				}
			} else {
				if (p % 10 != dig) {
					return -1;
				}
			}
		}
		cd /= 10;
		p /= 10;
	}
	return dig;
}

int main() {
	fillPrimes();
	fillCommonDifferences();

	if ( !(isPrime(2090021)
		&& isPrime(2191121)
		&& isPrime(2292221)
		&& isPrime(2494421)
		&& isPrime(2595521)
		&& isPrime(2696621)
		&& isPrime(2898821)
		&& isPrime(2999921)) )  {

		printf("Argh - 2090021 isn't good\n");
	
	} else {
		printf("2090021 is good, but not right\n");
	}

	int p;
	for (p = 0; p < NUMBER_OF_PRIMES; p++) {
		if (primes[p] > 2090021) {
			break;
		}
		int cd;
		for (cd = 0; cd < COMMON_DIFFERENCE_COUNT; cd++) {
			int dig = matchingDigits(primes[p], commonDifferences[cd]);
			if (-1 == dig) {
				continue;
			}

			int k;
			int compositesCount = 0;
			for (k = 1; k <= 9 && compositesCount <= (3-dig); k++) {
				if (!isPrime(primes[p] + k * commonDifferences[cd])) {
					compositesCount += 1;
				}
			}
			if (compositesCount <= (3-dig)) {
				printf("%d %d\n", primes[p], commonDifferences[cd]);
			//	cd = COMMON_DIFFERENCE_COUNT;
			//	p = NUMBER_OF_PRIMES;
			}
		}
	}
}
