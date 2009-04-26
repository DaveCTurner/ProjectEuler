int coprime(int a, int b) {
	if (0 == a) return (1 == b ? 1 : 0);
	while (a <= b) { b -= a; }
	return coprime(b, a);
}


int main() {
	int x, y;
	int perimeterCounts[1001];

	for (x = 3; x <= 100; x += 2) {
		for (y = 1; y < x; y += 2) {
			if (!coprime(x, y)) continue;

			int c = (x*x + y*y)/2;
			int b = (x*x - y*y)/2;
			int a = x*y;
			int p = a + b + c;

			if (p > 1000) break;

			int k = 1;
			while (k*p <= 1000) {
				printf("%d %d %d %d\n", k*p, k*c, k*a, k*b);
				perimeterCounts[k*p] += 1;
				k += 1;
			}
		}
	}
}
