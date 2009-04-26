int checkPandigital(int multiplicand, int multiplier) {
	int product = multiplicand * multiplier;
	int digits[10];
	int i;
	for (i = 0; i < 10; i++) {
		digits[i] = 0;
	}
	if (checkNumber(multiplier, digits)
		&& checkNumber(multiplicand, digits)
		&& checkNumber(product, digits)) {

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
	return 0;
}

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

int main() {
	int a, b;
	for (a = 1; a < 10000; a++) {
		for (b = 999/a; a*b < 10000; b++) {
			if (checkPandigital(a, b)) {
				printf("%d\n", a*b);
			}
		}
	}
}
