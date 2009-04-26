int main() {
	int a, b, c;
	for (a = 1; a < 10; a++) {
		for (b = 1; b < 10; b++) {
			if (a == b) continue;
			for (c = 0; c < 10; c++) {

				if ((a*10+c) * b == (c*10+b) * a) {
					printf("%d/%d = %d/%d\n",
						a*10+c, c*10+b, a, b);
				}
			}
		}
	}
}
