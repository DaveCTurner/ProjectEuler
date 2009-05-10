#include <stdio.h>

#define MAX_PRIME (10000)
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

int countPrimePartitions(int n, int minPrime, char * indent, int depth) {
	if (n == 0) {
//		printf("%s spot on\n", indent);
		return 1;
	}
	if (n < minPrime) {
//		printf("%s %d impossible\n", indent, n);
		return 0;
	}

	indent[depth] = ' ';

	int nextPrime = minPrime;
	do { nextPrime++; } while (isComposite[nextPrime]);

	int count = 0;
	int k;
	for (k = 0; k * minPrime <= n; k++) {
//		printf("%s%4d:%4d*%4d+...\n", indent, n, k, minPrime);
		count += countPrimePartitions(n-k*minPrime, nextPrime,
			indent, depth+1);
	}

	indent[depth] = '\0';
	return count;
}

int main() {
	fillComposites();

	char indent[30];
	memset(indent, 0, 30);

	int n;
	for (n = 2; n < MAX_PRIME; n++) {
		int primePartitions = countPrimePartitions(n, 2, indent, 0);
		if (primePartitions > 5000) {
			printf("%d\n", n);
			return 0;
		}
	}
	return 1;
}
