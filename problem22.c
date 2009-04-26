#include <stdio.h>

int main() {
	char file[60000];

	size_t fileRead = fread(file, 1, 60000, stdin);

	int nameIndex = 1;
	int nameScoreTotal = 0;
	int filePos;
	for (filePos = 0; filePos < fileRead; filePos += 1) {
		if (file[filePos] == ' ') {
			nameIndex += 1;
		} else {
			nameScoreTotal += nameIndex * (file[filePos] & 31);
		}
	}

	printf("%d\n", nameScoreTotal);
}
