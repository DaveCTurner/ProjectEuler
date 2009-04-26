int main() {
	int n;
	int powers[10];
	for (n = 0; n < 10; n++) {
		powers[n] = n*n*n*n*n;
	}

	for (n = 2; n < 1e8; n++) {
		int acc = 0;
		int workingN = n;
		while (workingN) {
			int digit = workingN % 10;
			workingN /= 10;
			acc += powers[digit];
		}
		if (acc == n) {
			printf("%d\n", n);
		}	
	}
}
