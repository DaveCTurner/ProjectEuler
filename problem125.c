#include <stdio.h>

int is_palindromic(int n) {
	char str[11];
	int l = snprintf(str, 11, "%d", n);
	int i;
	for (i = 0; i < (l+1)/2; i++) {
		if (str[i] != str[l-i-1]) {
			return 0;
		}
	}
	return 1;
}

int reflect(int n, int length) {
	char str[21];
	int l = snprintf(str, 11, "%d", n);
	if (length > 2 * l) { length = 2 * l; }
	while (l) {
		str[length-l] = str[l-1];
		l -= 1;
	}
	str[length] = '\0';
	return strtol(str, NULL, 10);
}

#define PALINDROME_COUNT (2*(10000-1))
int palindromes[PALINDROME_COUNT];

int compare_ints (const void *a, const void *b) {
	const int *ia = (const int *) a;
	const int *ib = (const int *) b;
	return (*ia > *ib) - (*ia < *ib);
}

void generate_palindromes() {
	int i = 1;
	for (; i < 10; i++) {
		palindromes[2*i-2] = reflect(i, 1);
		palindromes[2*i-1] = reflect(i, 2);
	}
	for (; i < 100; i++) {
		palindromes[2*i-2] = reflect(i, 3);
		palindromes[2*i-1] = reflect(i, 4);
	}
	for (; i < 1000; i++) {
		palindromes[2*i-2] = reflect(i, 5);
		palindromes[2*i-1] = reflect(i, 6);
	}
	for (; i < 10000; i++) {
		palindromes[2*i-2] = reflect(i, 7);
		palindromes[2*i-1] = reflect(i, 8);
	}
	qsort((void*)palindromes, 2*(10000-1), sizeof(int), compare_ints);
}

void check_palindromes() {
	generate_palindromes();
	int palindrome_index = 0;
	int i;
	for (i=1; i < 1000000; i++) {
		if (i == palindromes[palindrome_index]) {
			if (is_palindromic(i)) {
				printf("OK  : %d is palindromic\n", i);
			} else {
				printf("FAIL: %d is palindromic but is_palindromic() false\n",
				i);
			}
			palindrome_index += 1;
		} else {
			if (is_palindromic(i)) {
				printf("FAIL: %d is not palindromic but is_palindromic() true\n", i);
			} else {
				printf("OK  : %d is not palindromic\n", i);
			}
		}
	}
}

int main() {
	long long int tot = 0;
	int x;
	for (x = 1; x <= 32000; x++) {
		int sum = x*x;
		int y;
		for (y = x+1; y <= 32000; y++) {
			sum += y*y;
			if (sum >= 100000000) { break; }
			if (sum < 0) { printf("Overflow at [%d,%d]\n", x, y); break; }
			if (is_palindromic(sum)) {
				tot += sum;
				printf("[%d,%d]-> %d (%lld)\n", x, y, sum, tot);
				if (tot < 0) { printf("Tot overflow\n"); }
			}
		}
	}
	printf("%lld\n", tot);

	// 554455 = [9,118] = [331,335]
	// 9343439 = [102,307] = [657,677]
	// Could filter for duplicates, but simpler to do it by hand!

	printf("%lld\n", tot - 554455 - 9343439);
}


