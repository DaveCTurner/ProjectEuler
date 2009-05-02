#include <stdio.h>

#define MAX_PRIME (10*1000*1000)
char * isComposite;

int fillComposites() {
	isComposite = malloc(MAX_PRIME);
	if (0 == isComposite) {
		printf("Allocation failure\n");
		return 1;
	}
	memset(isComposite, 0, MAX_PRIME);
	isComposite[0] = 1;
	isComposite[1] = 1;
	int i;
	for (i = 2; i < MAX_PRIME; i++) {
		if (isComposite[i]) {
			continue;
		}

		int j;
		for (j = 2 * i; j < MAX_PRIME; j += i) {
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

	int digits[10];
	int n;
	double bestRatio = 1000.0;
	for (n = MAX_PRIME - 1; n >= 2; n--) {
		if (!isComposite[n]) { continue; }
	
		int t = eulerTotient(n);
		if (bestRatio * t <= n) { continue; }

		memset(digits, 0, 10 * sizeof(int));
		int nCopy = n;
		int tCopy = t;
		while (nCopy) {
			digits[nCopy % 10] += 1;
			nCopy /= 10;
		}
		while (tCopy) {
			digits[tCopy % 10] -= 1;
			tCopy /= 10;
		}
		
		int d;
		int isPermutation = 1;
		for (d = 0; d < 10 && isPermutation; d++) {
			if (digits[d] != 0) {
				isPermutation = 0;
			}
		}
		if (isPermutation) {
			bestRatio = (1.0 * n) / t;
			printf("%d %d %f\n", n, t, bestRatio);
		}
	}
}
