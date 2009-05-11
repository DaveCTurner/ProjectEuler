#include <stdio.h>
#include <math.h>

#define MAX_PRIME (1*1000*1000)
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

/* (p-1)^n + (p+1)^n = 2np mod p^2 where n odd (and = 2 if n even) */
void search() {
	unsigned long long int n = 1LL;
	int currentPrime = 2;
	while (1) {
		unsigned long long modulus = (1LL*currentPrime) * currentPrime;

		if (((2LL*n*currentPrime)%modulus)
				> (1LL*1000*1000)*10000LL) {
			printf("%llu %d %llu %llu\n", n, currentPrime,
				2LL*n*currentPrime,
				(2LL*n*currentPrime)%(1LL*currentPrime*currentPrime));
			break;
		}

		do { currentPrime ++; } while (isComposite[currentPrime]);
		n += 1LL;
		do { currentPrime ++; } while (isComposite[currentPrime]);
		n += 1LL;
	}
}

int main() {
	if (fillComposites()) {
		return 1;
	}
	search();
}

