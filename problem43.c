
void generatePandigitals(int depth, 
	int * availableDigits, 
	char * numberString,
	void callback(char*))
{
	if (depth == 10) {
		callback(numberString);
	} else {
		int step = 1;
		if (3 == depth) { step = 2; } // Ensure even in position 3
		if (5 == depth) { step = 5; } // Ensure multiple of 5 in pos 5

		int i;
		for (i = (0 == depth) ? 1 : 0; i < 10; i += step) {
			if (!availableDigits[i]) continue;
			availableDigits[i] = 0;
			numberString[depth] = '0' + i;
			generatePandigitals(depth + 1,
				availableDigits, numberString, callback);
			availableDigits[i] = 1;
		}
	}
}

void checkAndPrint(char * string) {
	int divisors[] = {1,2,3,5,7,11,13,17};
	int divisorCount = 8;
	char stringCopy[11];

	strncpy(stringCopy, string, 11);

	int i;
	int failed = 0;
	for (i = divisorCount - 1; i > 0 && !failed; i--) {
		int n = strtol(stringCopy + i, 0, 10);
		if (n % divisors[i] != 0) {
			failed = 1;
		}
		stringCopy[i+2] = '\0';
	}

	if (!failed) {
		printf("%s\n", string);
	}
}

void printIt(char * string) {
	printf("%s\n", string);
}

int main() {
	int availableDigits[10];
	char numberString[11];
	numberString[10] = '\0';

	int i;
	for (i = 0; i < 10; i++) {
		availableDigits[i] = 1;
	};

	generatePandigitals(0, availableDigits, numberString, checkAndPrint);
}
