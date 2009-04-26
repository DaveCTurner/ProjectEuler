#include <stdio.h>

int sequenceLength(long long n) {
	int length = 1;
	while (n > 1) {
		length += 1;
		if (n & 1) {
			if (n > ((1LL<<60)/3)) {
				printf("Integer overflow at n = %d\n", n);
				return 0;
			}
			n = 3*n+1;
		} else {
			n >>= 1;
		}
	}
	return length;
}

#define NUMBER 1000000

int main() {
	int n;
	int max = 0;
	int maxN = 0;

	printf("%d\n", sizeof(long long));

	for (n = 1; n < NUMBER; n++) {
		int length = sequenceLength(n);
		if (length > max) {
			max = length;
			maxN = n;
		}
	}
	printf("%d has length %d\n", maxN, max); 
}
