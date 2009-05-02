#include <stdio.h>
#include <math.h>

#define MAX_PRIME (1000*1000 + 1)
char * isComposite;

int fillComposites() {
	isComposite = malloc(MAX_PRIME);
	if (0 == isComposite) {
		printf("Allocation failure\n");
		return 1;
	}
	memset(isComposite, 0, MAX_PRIME);

	int sqrt_max_prime = (int)sqrt((double)MAX_PRIME) + 2;
	
	isComposite[0] = 1;
	isComposite[1] = 1;
	int i;
	for (i = 4; i < MAX_PRIME; i+=2) {
		isComposite[i] = 1;
	}
	for (i = 3; i < sqrt_max_prime; i+=2) {
		if (isComposite[i]) {
			continue;
		}

		int j;
		for (j = i * i; j < MAX_PRIME; j += i) {
			isComposite[j] = 1;
		}
	}
	return 0;
}

int isPrime(int n) {
	if (0 <= n && n < MAX_PRIME) {
		return (0 == isComposite[n]);
	}

	fprintf(stderr, "%d out of range\n", n);
	return 0;
}

int eulerTotient(int n) {
	if (!isComposite[n]) return (n-1);

	int tot = n;
	int p = 2;
	while (p*p <= n) {
		if (0 == (n % p)) {
			tot = tot / p * (p-1);
			do {
				n /= p;
			} while (0 == (n % p));
		}
		do { p++; } while (isComposite[p]);
	}
	if (n > 1) {
		tot = tot / n * (n-1);
	}
	return tot;
}

int main() {
	if (fillComposites()) {
		return 1;
	}

	unsigned long long int fractionCount = 0;
	int n;
	for (n = 2; n < MAX_PRIME; n++) {
		fractionCount += eulerTotient(n);
	}
	printf("%llu\n", fractionCount);
}
