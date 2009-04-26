#include <stdio.h>

#define NUMBER 20000

int sumDivisors(int n, int * primes) {
	int divisorSum = 1;
	int p = 0;
	int nSave = n;
	while (n > 1) {
		int currentPrimePower = primes[p];
		while (n % primes[p] == 0) {
			currentPrimePower *= primes[p];
			n /= primes[p];
		}
		divisorSum *= (currentPrimePower - 1)/(primes[p] - 1);
		p += 1;
	}
	return divisorSum - nSave;
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

	int amicableSum = 0;
	for (n = 2; n < 10000; n++) {
		int divisorSum = sumDivisors(n, primes);
		if (divisorSum != n && n == sumDivisors(divisorSum, primes)) {
			printf("%d -> %d\n", n, divisorSum);
			amicableSum += n;
		}
	}
	printf("Total = %d\n", amicableSum);
}
