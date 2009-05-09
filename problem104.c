#include <stdio.h>

int isPandigital(int n) {
	char buffer[10];
	if (9 != snprintf(buffer, 10, "%d", n)) {
/*		fprintf(stderr, "%d not pandigital - wrong length\n", n); */
		return 0;
	}

	return initialSubstringIsPandigital(buffer);
}

int initialSubstringIsPandigital(char * buffer) {
	int digitFlags[10];
	memset(digitFlags, 0, 10 * sizeof(int));
	int i;
	for (i = 0; i < 9; i++) {
		if ('0' == buffer[i]) {
/*			fprintf(stderr, "%d not pandigital - contains '0'\n", n); */
			return 0;
		}
		if (digitFlags[buffer[i] - '0']) {
/*			fprintf(stderr, "%d not pandigital - contains multiple '%c'\n",
				n, buffer[i]); */
			return 0;
		}
		digitFlags[buffer[i] - '0'] = 1;
	}

	return 1;
}


int main() {
// The 'ends in a pandigital' is easy - just work mod 10^9.
// The 'starts with a pandigital' requires a bit of a hack - we keep track of
// the most significant digits in a unsigned long long int (64 bits) 
// (so about 19 digits of precision)
// and hope that we find the number before rounding errors start to bite the 
// 9th digit (which, fortunately, they don't).


	int aLSD, bLSD, cLSD, n;

	unsigned long long int aMSD, bMSD, cMSD;
	char buffer[30];

	aLSD = n = 1;
	aMSD = 1LL;
	bLSD = 0;
	bMSD = 0LL;
	while (1) {
		if (isPandigital(aLSD)) {
			snprintf(buffer, 30, "%llu", aMSD);
			if (initialSubstringIsPandigital(buffer)) {
				printf("%d %d %llu\n", n, aLSD, aMSD);
			}
		}

		n += 1;
		cLSD = (aLSD + bLSD) % 1000000000;
		bLSD = aLSD;
		aLSD = cLSD;

		cMSD = aMSD + bMSD;
		bMSD = aMSD;
		aMSD = cMSD;
		if (aMSD > (1LL << 62)) {
			aMSD /= 10LL;
			bMSD /= 10LL;
		}
	}
}
