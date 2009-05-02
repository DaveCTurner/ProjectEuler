int factorials[10] = { 1, 1, 2, 6, 24, 120, 720, 5040, 40320, 362880 };

int factorialDigitSum(int n) {
	int digitSum = 0;
	while (n) {
		digitSum += factorials[n % 10];
		n /= 10;
	}
	return digitSum;
}

int chainLength(int n) {
	int length = 1;

	do {
		int fds = factorialDigitSum(n);
		if (n == fds) {
			return length;
		}
		n = fds;
		length += 1;
		if (n == 169 || n == 363601 || n == 1454) {
			return length + 2;
		}
		if (n == 871 || n == 45361 || n == 872 || n == 45362) {
			return length + 1;
		}
	} while (1);
}

int main() {
	int i;
	int sixtyCount = 0;
	for (i = 0; i < 1000000; i++) {
		if (chainLength(i) == 60) {
			sixtyCount += 1;
		}
	}
	printf("%d\n", sixtyCount);
}
