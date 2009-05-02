int main() {
	int n;
	char buf[20];
	int bouncyCount = 0;

	for (n = 100; n < 1000000000; n++) {
		snprintf(buf, 20, "%d", n);
		char * p;

		p = buf + 1;
		int increasing = 1;
		while (p[0]) {
			if (p[0] < p[-1]) {
				increasing = 0;
				break;
			}
			p += 1;
		}

		p = buf + 1;
		int decreasing = 1;
		while (p[0]) {
			if (p[0] > p[-1]) {
				decreasing = 0;
				break;
			}
			p += 1;
		}

		if (!(increasing || decreasing)) {
			bouncyCount += 1;
		}
		
		if (bouncyCount * 100 >= n * 99) {
			printf("%d %d %f\n", n, bouncyCount, 
				bouncyCount * 1.0 / n);
			break;
		}
	}

}
