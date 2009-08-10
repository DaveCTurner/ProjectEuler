#include <stdio.h>

struct node { struct node * next; unsigned long long int n; };

int main() {
	unsigned long long int pascal_row[53];
	unsigned int row_index;

	pascal_row[0] = 1;
	row_index = 1;

	int i;

	struct node root[2500];
	root->next = 0;
	root->n = 1;
	int allocated_count = 1;

	for (; row_index <= 51; row_index++) {
//		for (i = 0; i < row_index; i++) {
//			printf("%llu ", pascal_row[i]);
//		}
//		printf("\n");

		struct node * predecessor = root;
		struct node * prepredecessor = 0;
		for (i = 1; i < (row_index+1)/2; i++) {
//			printf("Considering %llu\n", pascal_row[i]);
			while ((0 != predecessor) && (predecessor->n < pascal_row[i])) {
				prepredecessor = predecessor;
				predecessor = predecessor->next;
			}
			if ((0 == predecessor) || (predecessor->n > pascal_row[i])) {
//				if (0 == predecessor) {
//					printf("Adding %llu at end\n", pascal_row[i]);
//				} else {
//					printf("Adding %llu after %llu\n", pascal_row[i],
//						prepredecessor->n);
//				}
				struct node * new_node = root + (allocated_count++);
				//printf("Allocated %d\n", allocated_count);
				new_node->next = prepredecessor->next;
				new_node->n = pascal_row[i];
				prepredecessor->next = predecessor = new_node;
			}
		}

		pascal_row[row_index] = 1;
		for (i = row_index-1; i > 0; i--) {
			pascal_row[i] = pascal_row[i] + pascal_row[i-1];
		}
	}

	unsigned long long int total = 0;
	struct node * current = root;
	while (current) {
		unsigned long long int n = current->n;
		current = current->next;

		if (0 == (n % 4)) { continue; }
		if (0 == (n % 9)) { continue; }
		if (0 == (n % 25)) { continue; }
		if (0 == (n % 49)) { continue; }
		if (0 == (n % 121)) { continue; }
		if (0 == (n % 169)) { continue; }
		if (0 == (n % (17*17))) { continue; }
		if (0 == (n % (19*19))) { continue; }
		if (0 == (n % (23*23))) { continue; }
		printf("%llu\n", n);
		total += n;
	}

	printf("%llu\n", total);
}
