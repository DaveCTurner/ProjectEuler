#include <stdio.h>

char digitSquares[10];

int rf(int n, char * arrivesAt89) {
	if (arrivesAt89[n]) {
		return arrivesAt89[n];
	}
	char buf[13];
	snprintf(buf, 13, "%d", n);
	int acc = 0;
	char *p = buf;
	while (*p) {
		acc += digitSquares[*p - '0'];
		p += 1;
	}
	return (arrivesAt89[n] = rf(acc, arrivesAt89));
}

int main() {
	char * arrivesAt89 = (char*)malloc(10000000); 
	// 0 = unknown, 1 = finishes at 1, 2 = finishes at 89.

	if (0 == arrivesAt89) {
		fprintf(stderr, "Allocation error\n");
		return 1;
	}
	memset(arrivesAt89, 0, 10000000);
	arrivesAt89[1] = 1;
	arrivesAt89[89] = 2;
	
	int i;
	for (i = 0; i < 10; i++) {
		digitSquares[i] = i * i;
	}

	int count89 = 0;
	for (i = 1; i < 10000000; i++) {
		if (rf(i, arrivesAt89) == 2) {
			count89 += 1;
		}
	}
	printf("%d\n", count89);
}
