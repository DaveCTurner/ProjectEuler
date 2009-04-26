#include <stdio.h>

#define NUMBER 2000000

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
	
	int total = 0;
	for (p = 0; p < primeCount; p++) {
		if (total > 1<<30) {
			printf("%d+", total);
			total = 0;
		}
		total += primes[p];
	}
	printf("%d\n", total);
}
