int main() {
	int n;
	int factorials[10];
	factorials[0] = 1;
	for (n = 1; n < 10; n++) {
		factorials[n] = n*factorials[n-1];
	}

	for (n = 3; n < 1e8; n++) {
		int acc = 0;
		int workingN = n;
		while (workingN) {
			int digit = workingN % 10;
			workingN /= 10;
			acc += factorials[digit];
		}
		if (acc == n) {
			printf("%d\n", n);
		}	
	}
}
