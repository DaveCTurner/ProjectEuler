#include <stdio.h>
#include <math.h>

#define MAX 10000
#define PRIMES 50000000

int is_prime(int n, char * is_composite) {
	int p = 1;
	if (n < PRIMES) { return 1 - is_composite[n]; }
	while (p*p<=n) {
		do {p++;} while (is_composite[p]);
		if (0 == (n%p)) { return 0; }
	}
	return 1;
}

int main() {
	char * is_composite;

	if (0 == (is_composite = (char*)malloc(PRIMES))) {
		printf("malloc error");
		return 1;
	}
	memset(is_composite, 0, PRIMES);
	is_composite[0] = is_composite[1] = 1;
	int n;
	for (n = 2; n*n < PRIMES; n++) {
		if (is_composite[n]) { continue; }
		int d = n * n;
		while (d < PRIMES) {
			is_composite[d] = 1;
			d += n;
		}
	}

	/* If pq < 10^8 then at least one of p, q < 10^4. WLOG p <= q. */
	
	/* For each p : 2, 3, 5, ..., < 10^4, count the number of
	 * primes q such that pq < 10^8. */


	/* Set p to the largest prime */
	int p = (MAX-1); while (is_composite[p]) { p--; }
	int prime_count = 0;
	int i;
	int q_max = p;

	int semiprime_count = 0;

	do {
		/* Seek out maximum q for the current p, counting primes */
		while (q_max * p < MAX*MAX) {
			/* If q_max is prime then increment prime_count */
			if (is_prime(q_max, is_composite)) { prime_count += 1; }
			q_max += 1;
		}
		printf("{%d} x ([%d, %d) n primes) contains %d elements\n",
			p, p, q_max, prime_count);
		
		/* Therefore {p} x ([p, q_max) \cap primes) generate
		 * another collection of semiprimes, and there
		 * are prime_count of them */

		semiprime_count += prime_count;

		do { p--; } while (p > 1 && is_composite[p]);
		prime_count += 1; /* Have added one prime from the list */
	} while (p > 1);

	printf("%d\n", semiprime_count);
}
