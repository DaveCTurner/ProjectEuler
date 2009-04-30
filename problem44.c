#include <stdio.h>

#define NUMBER_OF_PENTS 3000000

unsigned long long int * pents;

void fillPents() {
	pents = (unsigned long long int*)
			malloc(NUMBER_OF_PENTS * sizeof(unsigned long long int));
	if (0 == pents) {
		return;
	}

	int n;
	for (n = 0; n < NUMBER_OF_PENTS; n++) {
		pents[n] = (n+1LL)*(3LL*n+2LL)/2LL;
	}
}

int isPentagonal(unsigned long long int n, int * startPoint, int * error) {
	if (0 == pents) {
		*error = 1;
		fprintf(stderr, "Cannot test %llu for pentagonality: no pents\n", n);
		return 0;
	}
	if (n > pents[NUMBER_OF_PENTS-1]) {
		*error = 2;
		fprintf(stderr, "Cannot test %llu for pentagonality: too large\n", n);
		return 0;
	}
	if (n < 1) {
		return 0;
	}

	/* printf("Testing %d\n", n); */

	int left = 0;
	int right = NUMBER_OF_PENTS;

	if (0 != *startPoint) {
		left = right = *startPoint;
		if (pents[left] > n) {
			left -= 1;
			while (left > 0 && pents[left] > n) {
				left = 2 * left - right;
			}
			if (left < 0) {
				left = 0;
			}
		}

		if (pents[right] <= n) {
			right += 1;
			while (right < NUMBER_OF_PENTS && pents[right] <= n) {
				right = 2 * right - left;
			}
			if (right > NUMBER_OF_PENTS) {
				right = NUMBER_OF_PENTS;
			}
		}
	}

	while (right != left) {
		int mid = (right+left)/2;
		/* printf("Range [%d, %d] : %d\n", left, right, mid); */
		if (pents[mid] < n) {
			left = mid + 1;
		} else if (pents[mid] > n) {
			right = mid;
		} else {
			*startPoint = mid;
			return 1;
		}
	}
	*startPoint = 0;
	return 0;
}

int main() {
	fillPents();

	unsigned long long int minDifference = 0;
	
	int i;
	int jMin = -1;
	for (i = 0; i < NUMBER_OF_PENTS && jMin != 0; i++) {
		unsigned long long int a = pents[i];
		int j;
		int diffTestStartPoint = 0;
		int sumTestStartPoint = 0;
		for (j = (jMin != -1 ? i - jMin : 0); j < i; j++) {
			unsigned long long int b = pents[j];
			if (minDifference && b < a - minDifference) {
				jMin = i - j;
				continue;
			}
			int diffError, sumError;
			diffError = sumError = 0;
			if (isPentagonal(a-b, &diffTestStartPoint, &diffError)
				 && isPentagonal(a+b, &sumTestStartPoint, &sumError)) {
				printf("%llu %llu %llu %d %d\n", a-b, a, b, i, j);
				minDifference = a-b;
			}
			if (diffError) {
				printf("Diff error %d at %d %d\n", diffError, i, j);
			}
			if (sumError) {
				printf("Sum error %d at %d %d\n", sumError, i, j);
			}
		}
	}
}
