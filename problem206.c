int test(int i) {
	unsigned long long int isq = ((unsigned long long int)i) * i;
	char isqBuf[40];
	int digitCount = snprintf(isqBuf, 40, "%llu", isq);

	char digit = '1';
	int found = 1;
	char * p = isqBuf;
	while (digit <= '9' && found) {
		if (*p != digit) {
			found = 0;
		}
		p += 2;
		digit += 1;
	}
	if (found) {
		printf("%u0^2 = %llu00\n", i, isq);
	}
	return found;
}

int main() {
	unsigned int i;
	int offset[24] = {43, 53, 83, 167, 197, 207, 293, 303, 333,
		417, 447, 457, 543, 553, 583, 667, 697, 707, 793, 803, 833,
		917, 947, 957 }; // From perl version
	for (i = 100000000; i < 140000000; i += 1000) {
		int j;
		for (j = 0; j < 24; j++) {
			test(i + offset[j]);
		}
	}
}
