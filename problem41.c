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

int digitCount(int n) {
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

int main() {
	fillPrimes();

	int digits[10];
	int p;
	for (p = 0; p < NUMBER_OF_PRIMES; p++) {
		int i;
		for (i = 0; i < 10; i++) {
			digits[i] = 0;
		}

		int isPandigital = 1;
		int n = primes[p];
		while (isPandigital && n) {
			int lastDigit = n % 10;
			if (digits[lastDigit]) {
				isPandigital = 0;
			} else {
				digits[lastDigit] = 1;
			}
			n = (n-lastDigit)/10;
		}

		for (i = digitCount(primes[p]); isPandigital && i > 0; i--) {
			if (!digits[i]) {
				isPandigital = 0;
			}
		}

		if (isPandigital) {
			printf("%d\n", primes[p]);
		}
	}
}
