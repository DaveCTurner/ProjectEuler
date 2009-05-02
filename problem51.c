#include <stdio.h>

#define MAX_PRIME (1*1000*1000)
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

int main() {
	if (fillComposites()) {
		return 1;
	}

	int n;
	char nString[20];
	for (n = 10000; n < MAX_PRIME; n++) {
		if (!isPrime(n)) {
			continue;
		}
		snprintf(nString, 20, "%d", n);

		// Know that it must be a multiple of 3 digits being
		// replaced, because if not then more than 2 of the 
		// resulting numbers will be divisible by 3.
		//
		// Therefore assume it's exactly 3 (it won't be 6 unless
		// the number is quite a bit bigger) and see what happens...
		char *p1;
		for (p1 = nString; *p1; p1 += 1) {
			if (*p1 > '2') {
				continue;
			}
			char *p2;
			for (p2 = nString; p2 < p1; p2 += 1) {
				if ((*p1) != (*p2)) {
					continue;
				}
				char *p3;
				for (p3 = nString; p3 < p2; p3 += 1) {
					if ((*p1) != (*p3)) {
						continue;
					}
					int primeCount = 0;
					char c;
					for (c = '0'; c <= '9'; c++) {
						*p1 = *p2 = *p3 = c;
						if (isPrime(strtol(nString, 0, 0))) {
							primeCount += 1;
						}
					}
					if (primeCount >= 8) {
						*p1 = *p2 = *p3 = '*';
						printf("%d : %s\n", n, nString);
					}
				}
			}
		}
	}
}
