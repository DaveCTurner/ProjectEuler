int main() {
	char string[10];

	int nextPosition = 1;
	int currentPosition = -1;
	
	int i;
	for (i = 0; i < 1000000; i++) {
		snprintf(string, 10, "%d", i);

		int j = 0;
		while (string[j]) {
			currentPosition += 1;
			if (currentPosition == nextPosition) {
				printf("%c(%d) ", string[j], i);
				nextPosition *= 10;
			}
			j += 1;
		}
	}
}
