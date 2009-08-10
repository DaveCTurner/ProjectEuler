#include <stdio.h>
#include <limits.h>

unsigned int digit_sum(unsigned int n) {
	char n_str[11];
	snprintf(n_str, 11, "%u", n);
	char * p = n_str;
	unsigned int sum = 0;
	while (*p) { sum += (*p++)-('0'); };
	return sum;
}

int main() {
	unsigned int n;

	for (n = 10; n < UINT_MAX; n++) {
		//printf("     %u\n", n);
		unsigned int ds = digit_sum(n);
		if (ds <= 1) { continue; }
		unsigned int acc = 1;
		int pow = 0;
		do {
			acc *= ds;
			pow += 1;
			if (acc == n) { printf("%u = %u^%d\n", n, ds, pow); }
			if (acc >= n) { break; }
		} while (acc < UINT_MAX / ds);
	}
}
