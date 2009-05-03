#include <stdio.h>
#include <math.h>

int primes[]      = {0, 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41,
	43, 47, 53, 59, 61, 67, 71, 73};
int primePowers[] = {0, 0, 0, 0,  0,  0,  0,  0,  0,   0,  0,  0,  0,
	 0,  0,  0,  0,  0,  0,  0};

/* Enumerates numbers with small prime factors, recursively.
The definition of 'small' is 'contained in the primes[] array' which 
has a 0 terminator.
The last 'small' prime is always a factor of the given numbers -
call multiple times with different collections of primes to cover all
cases. */

/* Returns 1 if improved, 0 otherwise */
int enumerateNumbersWithSmallPrimeFactors(int * bestSoFar, int depth,
	int accumulator) {

	if (0 == primes[depth]) {
		int totient = 1;
		int i = 0;
		while (primes[i]) {
			if (primePowers[i]) {
				totient *= primes[i] - 1;
				int j;
				for (j = 1; j < primePowers[i]; j++) {
					totient *= primes[i];
				}
			}
			i += 1;
		}

		if ((unsigned long long)totient * 94744LL 
				< (unsigned long long)(accumulator-1) * 15499LL) {
			printf("%d =", accumulator);

			i = 0;
			int firstPrime = 1;
			while (primes[i]) {
				if (primePowers[i]) {
					if (firstPrime) {
						firstPrime = 0;
					} else {
						printf (" *");
					}

					printf (" %d", primes[i]);
					if (1 < primePowers[i]) {
						printf ("^%d", primePowers[i]);
					}
				}
				i += 1;
			}
			if (firstPrime) {
				printf(" 1");
			}
			printf ("  phi = %d", totient);
			printf ("  GOOD");
			(*bestSoFar) = accumulator;
			printf ("\n");
			return 1;
		}
		
		return 0;
	}

	int maxPower = floor((log((*bestSoFar)/accumulator))
		/ log(primes[depth]));

	int minPower = 0;
	if (0 == primes[depth+1]) {
		minPower = 1;
		accumulator *= primes[depth];
	}
	
	int rv = 0;

	for (primePowers[depth] = minPower;
			primePowers[depth] <= maxPower; 
			primePowers[depth]++) {
		rv |= enumerateNumbersWithSmallPrimeFactors(bestSoFar, depth+1,
			accumulator);
		accumulator *= primes[depth];
	}
	
	return rv;
}

int main() {
	int bestSoFar = 0x7fffffff;
	int improved = 0;
	int maxPrimeIndex;
	for (maxPrimeIndex = 0; maxPrimeIndex <= 20; maxPrimeIndex += 1) {
		primes[maxPrimeIndex] = primes[maxPrimeIndex+1];
		primes[maxPrimeIndex+1] = 0;
	
		printf("Checking primes up to %d\n", primes[maxPrimeIndex]);
		improved |= enumerateNumbersWithSmallPrimeFactors(&bestSoFar, 0, 1);
	}

	if (improved) {
		printf ("%d\n", bestSoFar);
	}

	/* R(d) = proportion of fractions over d that cannot
	be cancelled.

	I.e. R(d) = phi(d) / (d-1).
	
	Want to find smallest d such that R(d) < 15499/94744

	i.e. phi(d) / (d-1) < 15499/94744
	i.e. 94744 * phi(d) < 15499 * (d-1) 
	
	       If d = 2 * 3 * 5 * 7 * 11 * 13 * 17 * 19 * 23
	then phi(d) = 1 * 2 * 4 * 6 * 10 * 12 * 16 * 18 * 22

	so d / phi(d) =             7 *      13 * 17 * 19 * 23
	              /         4 * 2 *  2 * 12 * 16 * 18 * 2
	
	 = 676039 / 110592 =~= 94744 / 15499
	
	*/

}
