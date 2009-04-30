int main() {
	int count = 0;
	int n;
	for (n = 1; n <= 100; n += 1) {
		int nChooseR = 1;
		int r;

		for (r = 0; 2*r <= n && nChooseR <= 1000000; r += 1) {
			nChooseR = (nChooseR * (n-r)) / (r+1);
		}
		if (nChooseR > 1000000) {
			count += n - 2 * r + 1;
			printf("n = %d, r = %d to %d, count += %d\n", n,
				r, n - r, n - 2 * r + 1); 
		}
	}
	printf("count = %d\n", count);
}
