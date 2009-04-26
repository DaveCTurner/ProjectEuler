int checkNumber(int n, int * digits) {
	while (n) {
		int digit = n % 10;
		n /= 10;
		if (digits[digit]) {
			return 0;
		} else {
			digits[digit] = 1;
		}
	}
	return 1;
}

int checkPandigital(int number, int products) {
	int digits[10];
	int i;

	for (i = 0; i < 10; i++) {
		digits[i] = 0;
	}

	for (i = 1; i <= products; i++) {
		if (!checkNumber(number * i, digits)) {
			return 0;
		}
	}

	if (digits[0]) {
		return 0;
	}

	for (i = 1; i < 10; i++) {
		if (0 == digits[i]) {
			return 0;
		}
	}
	return 1;
}

int main() {
	int a, b;
	for (a = 1; a < 50000; a++) {
		for (b = 2; b < 9 && a*b < 100000; b++) {
			if (checkPandigital(a, b)) {
				int i;
				for (i = 1; i <= b; i++) {
					printf("%d", a*i);
				}
				printf(" %d %d\n", a, b);
			}
		}
	}
}
