int denominations[] = {200,100,50,20,10,5,2,1};

int count;

void rf(int depth, int remaining) {
	if (denominations[depth] == 1) {
		count += 1;
	} else {
		int i = 0;
		while (i * denominations[depth] <= remaining) {
			rf(depth+1, remaining - i*denominations[depth]);
			i += 1;
		}
	}
}

int main() {
	count = 0;
	rf(0,200);
	printf("%d\n", count);
}
