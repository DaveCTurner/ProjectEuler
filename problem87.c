#include <stdio.h>

#define UPPER_BOUND (50*1000*1000)

#define MAX_PRIME (10000)
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

	char * expressible = malloc(UPPER_BOUND);
	if (expressible == 0) {
		fprintf(stderr, "Cannot allocate array");
		return 1;
	}

	int p = 2;
	int squareCount = 0;
	int cubeCount = 0;
	int fourthPowerCount = 0;
	while (p*p < UPPER_BOUND) {
		squareCount += 1;
		if (p*p*p < UPPER_BOUND) {
			cubeCount += 1;
			if (p*p*p*p < UPPER_BOUND) {
				fourthPowerCount += 1;
			}
		}
		do { p++; } while (isComposite[p]);
	}

	int * squares = malloc(squareCount * sizeof(int));
	if (squares == 0) {
		fprintf(stderr, "Cannot allocate squares array");
		return 1;
	}

	int * cubes = malloc(cubeCount * sizeof(int));
	if (cubes == 0) {
		fprintf(stderr, "Cannot allocate cubes array");
		return 1;
	}

	int * fourthPowers = malloc(fourthPowerCount * sizeof(int));
	if (fourthPowers == 0) {
		fprintf(stderr, "Cannot allocate fourth powers array");
		return 1;
	}

	p = 2;
	squareCount = 0;
	cubeCount = 0;
	fourthPowerCount = 0;
	while (((double)p)*p < UPPER_BOUND) {
		squares[squareCount] = p*p;
		squareCount += 1;
		if (((double)p)*p*p < UPPER_BOUND) {
			cubes[cubeCount] = p*p*p;
			cubeCount += 1;
			if (((double)p)*p*((double)p)*p < UPPER_BOUND) {
				fourthPowers[fourthPowerCount] = p*p*p*p;
				fourthPowerCount += 1;
			}
		}
		do { p++; } while (isComposite[p]);
	}

	memset(expressible, 0, UPPER_BOUND);
	int expressibleCount = 0;
	int currentSquare, currentCube, currentFourthPower;
	for (currentSquare = 0; currentSquare < squareCount; currentSquare++) {
		for (currentCube = 0; currentCube < cubeCount; currentCube++) {
			for (currentFourthPower = 0;
					currentFourthPower < fourthPowerCount;
					currentFourthPower++) {
				int n = squares[currentSquare] + cubes[currentCube]
					+ fourthPowers[currentFourthPower];
				if (n < UPPER_BOUND && (0 == expressible[n])) {
					expressible[n] = 1;
					expressibleCount += 1;
				}
			}
		}
	}

	printf("%d\n", expressibleCount);
}
