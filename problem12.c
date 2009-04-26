#include <stdio.h>

#define NUMBER 2000000

int countDivisors(int n, int * primes) {
	int divisors = 1;
	int p = 0;
	while (n > 1) {
		int currentPrimePower = 0;
		while (n % primes[p] == 0) {
			currentPrimePower += 1;
			n /= primes[p];
		}
		if (currentPrimePower) {
			divisors *= (currentPrimePower + 1);
		}
		p += 1;
	}
	return divisors;
}

int main() {
	int primes[NUMBER];
	primes[0] = 2;
	primes[1] = 3;
	int primeCount = 2;
	int n, p;
	int isPrime;
	for (n = 5; n < NUMBER; n+=2) {
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

	int triangularNumber = 0;
	for (n = 1; ; n++) {
		triangularNumber += n;
		int divisors = countDivisors(triangularNumber, primes);
		if (divisors >= 500) {
			printf("%d has %d divisors\n", triangularNumber,
				countDivisors(triangularNumber, primes)); 
			break;
		}
	}
}
