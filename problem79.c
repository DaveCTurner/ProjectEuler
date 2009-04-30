#include <stdio.h>

char* inputs[50];

int readInput() {
	FILE * inputFile = fopen("problem79-input.txt", "r");
	if (0 == inputFile) {
		return -1;
	}
	
	int i = 0;
	size_t bufferSize = 0;
	char * bufferPtr = 0;
	while (i < 50 && getline(&bufferPtr, &bufferSize, inputFile) != -1) {
		inputs[i++] = bufferPtr;
		bufferPtr[3] = '\0';
		bufferPtr = 0;
		bufferSize = 0;
	}
	return i;
	fclose(inputFile);
}

void freeThings(int lineCount) {
	int i;
	for (i = 0; i < lineCount; i++) {
		free(inputs[i]);
	}
}

int tryBuffer(char * buffer, int lineCount) {
	int i;
	char* p;
	char* q;
	for (i = 0; i < lineCount; i++) {
		p = buffer;
		q = inputs[i];
		while (*p) {
			if (*p == *q) {
				q += 1;
			}
			p += 1;
		}
		if (*q) {
			return 0;
		}
	}
	return 1;
}

#define MAXLENGTH 10

int main() {
	int lineCount = readInput();
	if (lineCount < 0) {
		return 1;
	}

	char buffer[MAXLENGTH + 1];
	int currentLength;
	for (currentLength = 6; currentLength <= MAXLENGTH; currentLength += 1) {
		buffer[currentLength] = '\0';
		int currentPosition;
		for (currentPosition = 0; currentPosition < currentLength;
				currentPosition += 1) {
			buffer[currentPosition] = '0';
		}

		do {
			/* Try current config */
			if (tryBuffer(buffer, lineCount)) {
				currentLength = MAXLENGTH + 1;
				printf("%s\n", buffer);
				break;
			}

			/* Increment buffer */
			currentPosition = currentLength - 1;
			while ('9' == buffer[currentPosition] && 0 <= currentPosition) {
				buffer[currentPosition] = '0';
				currentPosition -= 1;
			}
			if (0 <= currentPosition) {
				if ('3' == buffer[currentPosition]) {
					/* No 4 or 5 */
					buffer[currentPosition] = '6';
				} else {
					buffer[currentPosition] += 1;
				}
			} else {
				break;
			}
		} while (1);
	}

	freeThings(lineCount);
}
