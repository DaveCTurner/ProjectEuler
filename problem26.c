#define NUMBER 1000

int main() {
	int n;
	int remainders[NUMBER];
	int maxCycleLength = 0;
	int nMax;
	for (n = 2; n < NUMBER; n += 1) {
		int i;
		for (i = 0; i < NUMBER; i++) {
			remainders[i] = 0;
		}

		int remainderIndex = 0;
		int d = 1;
		while (remainders[d] == 0) {
			remainderIndex += 1;
			remainders[d] = remainderIndex;
			d = (d*10) % n;
		}
		int cycleLength = 1 + remainderIndex - remainders[d];
		if (maxCycleLength < cycleLength) {
			maxCycleLength = cycleLength;
			nMax = n;
		}
		printf("%d : %d\n", n, cycleLength);
	}
	printf("Max %d : %d\n", nMax, maxCycleLength);
}
