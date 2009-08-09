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

int count_divisors(int n) {
	int divisors = 1;
	int current_prime = 2;

	while (n > 1) {
		if (n < current_prime * current_prime) { return divisors * 2; }

		int power = 0;
		while (0 == (n % current_prime)) {
			power += 1;
			n /= current_prime;
		}
		if (power > 0) {
			divisors *= power + 1;
		}

		do { current_prime ++; } while (isComposite[current_prime]);
	}
	return divisors;
}

int main() {
	if (fillComposites()) {
		return 1;
	}
	int last_n_divisors = 2;
	int count = 0;
	int n;
	for (n = 3; n <= 10000000; n++) {
		int current_n_divisors = count_divisors(n);
		//printf("%d has %d divisors\n", n, current_n_divisors);
		if (current_n_divisors == last_n_divisors) {
//			printf("%d and %d both have %d divisors\n", n-1, n,
//				current_n_divisors);
			count += 1;
		}
		last_n_divisors = current_n_divisors;
	}
	printf("%d\n", count);
}

