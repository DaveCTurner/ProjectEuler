#define SIZE 10 

void rf(int depth, int * fixed, int * stack) {
	if (depth == SIZE) {
		int i;
		for (i = 0; i < SIZE; i++) {
			printf("%d", stack[i]);
		}
		printf("\n");
	} else {
		int i;
		for (i = 0; i < SIZE; i++) {
			if (fixed[i]) continue;
			stack[depth] = i;
			fixed[i] = 1;
			rf(depth+1, fixed, stack);
			fixed[i] = 0;
		}
	}
}

int main() {
	int fixed[SIZE];
	int i;
	for (i = 0; i < SIZE; i++) fixed[i] = 0;

	int stack[SIZE];
	rf(0, fixed, stack);
}
