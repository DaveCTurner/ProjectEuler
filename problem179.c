#include <stdio.h>
#include <math.h>

int main() {
	int * largest_prime_divisors;
	if (0 == (largest_prime_divisors
			= (int *) malloc(10000001 * sizeof(int)))) {
		return 1;
	}
	memset(largest_prime_divisors, 0, 10000001 * sizeof(int));

	int n;
	largest_prime_divisors[1] = 1;
	for (n = 2; n <= 3200; n++) {
		if (largest_prime_divisors[n]) { continue; }
		printf("%d\n", n);
		int d = 2 * n;
		while (d <= 10000000) {
			largest_prime_divisors[d] = n;
			d += n;
		}
	}
	
	int * divisors_count;
	if (0 == (divisors_count = (int *) malloc(10000001 * sizeof(int)))) {
		return 1;
	}

	divisors_count[1] = 1;

	for (n = 2; n <= 10000000; n++) {
		if (0 == (n % 1000000)) { printf("%d\n", n); }

		int current_prime = largest_prime_divisors[n];
		if (0 == current_prime) {
			// is prime
			divisors_count[n] = 2;
			//printf("%d is prime\n", n);
		} else {
			int power = 0;
			int next_n = n;
			while (0 == (next_n % current_prime)) {
				power += 1;
				next_n /= current_prime;
			}
			divisors_count[n] = divisors_count[next_n] * (1 + power);
			//printf("%d has %d divisors\n", n, divisors_count[n]);
		}
	}
	
	int count = 0;
	for (n = 2; n < 10000000; n++) {
		if (divisors_count[n] == divisors_count[n+1]) {
/*			printf("%d and %d both have %d divisors\n", n, n+1,
				divisors_count[n]); */
			count += 1;
		}
	}
	printf("%d\n", count);
}

