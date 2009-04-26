#define DIGITS 10

void print(char * a) {
	int i;
	for (i = DIGITS - 1; i >= 0; i--) {
		printf("%d ", a[i]);
	}
	printf("\n");
}

void copyFromInt(char * a, int b) {
	int i = 0;
	while (i < DIGITS) {
		a[i] = b % 10;
		i += 1;
		b /= 10;
	}
}

/* Increase the contents of a by b */
void accumulate(char * a, char * b) {
	int i;
	for (i = 0; i < DIGITS; i++) {
		int x = a[i] + b[i];
		a[i] = x % 10;
		if (i < DIGITS - 1) {
			a[i+1] += x / 10;
		}
	}
}

/* Increase a by a factor of b and shift right */
void multiply1(char * a, int b, int shift) {
	int i;
	int carry = 0;
	for (i = 0; i < DIGITS - shift; i++) {
		int x = a[i] * b + carry;
		a[i] = x % 10;
		carry = x / 10;
	}
	if (shift >= 1) {
		for (i = DIGITS - 1; i >= shift; i--) {
			a[i] = a[i-shift];
			a[i-shift] = 0;
		}
	}
}

void multiply(char * a, char * b) {
	char c[DIGITS], d[DIGITS];
	copyFromInt(c, 0);

	int i;
	for (i = 0; i < DIGITS; i++) {
		int j;
		for (j = 0; j < DIGITS; j++) {
			d[j] = a[j];
		}
		multiply1(d, b[j], 0);
		print(d);
		accumulate(c, d);
	}
	int j;
	for (j = 0; j < DIGITS; j++) {
		a[j] = c[j];
	}
}

int main() {
	char a[DIGITS], b[DIGITS];

	copyFromInt(a, 42351);
	copyFromInt(b, 19283729);

	print(a);
	print(b);
	multiply(a, b);
	print(a);
}
