/*
 *  sudoku.c
 *  $Id: sudoku.c 1727 2006-08-12 07:48:49Z dct25 $
 *
 *  Solves Sudoku puzzles
 *
 *  Copyright (C) 2005 David Turner <dcturner2000@yahoo.co.uk>
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 *
 *  The method this program employs to solve a Sudoku is described here. Each
 *  square on the board is represented with a bitfield, one bit for each
 *  possible number which could be entered there. As possibilities are
 *  eliminated, the bits are cleared until just one bit remains set in each
 *  square; the puzzle is then solved.
 *
 *  The simplest way to eliminate possibilities is to look at those squares
 *  whose contents are certain (only one possibility) and to use the fact that
 *  no two squares in the same row, column, or block can be the same. However
 *  this is rarely adequate to solve the problem.
 *
 *  This can be generalised to consider pairs of squares, each with the same
 *  two possibilities. For example, if a row contains two squares, each of
 *  which can only possibly contain a 1 or a 2, then no other square in the
 *  row can contain a 1 or a 2. So although it is not certain which will
 *  eventually contain a 1 and which will contain a 2, some other
 *  possibilities for that row can be eliminated.
 *
 *  These are the first two cases of the following technique. If there are n
 *  squares in a {row,column,block} which collectively must contain exactly n
 *  numbers then no other square in the {row,column,block} may contain those
 *  numbers. If they must contain >n numbers then no deduction can be made,
 *  and if they must contain <n numbers then there is no consistent way to
 *  solve the puzzle.
 *
 *  Iterating this technique over all rows, columns and blocks until it
 *  reaches a fixed point (which happens in finite time) usually makes a large
 *  amount of progress towards the solution. In some cases, however, it will
 *  not completely solve the problem, and in these cases, the program picks a
 *  square over whose contents there is still some doubt and checks each
 *  remaining possibility in turn, again iterating the above technique until
 *  it reaches a fixed point. This happens recursively so that if a guess
 *  turns out to be wrong the program backtracks and tries a different guess.
 *
 *  As it stands, this program will print out the first solution it finds and
 *  then exit. It is trivial to modify it to print out all possible solutions.
 *
 *  This method is the first method that sprang to mind when solving the
 *  puzzle by hand and is optimised mostly for clarity rather than speed.
 *  Nonetheless, it is sufficiently fast for most problems encountered in the
 *  wild (it solves the pathological case of a blank board in a matter of
 *  seconds)
 *
 *  One minor optimisation which is used is to check subsets of
 *  {rows,columns,blocks} in size order, and go back to 1 if any changes
 *  happen. This corresponds to what one would do if using a pen and paper.
 *
 *  Finally, note that internally this program starts counting from 0 not 1.
 *  It is only in the output stage that everything is incremented.
 */

/* At some point in the future, someone is going to produce a bigger Sudoku
 * with a 4x4 grid of 4x4 boards. This program will still cope, by changing 3
 * to 4 in the line below, although the input and output formats will need
 * changing. */
#define N 3
#define SIZE (N*N)
#define UNKNOWN ((1<<SIZE)-1) /* All bits set: no possibilities eliminiated */

#define _GNU_SOURCE 1
#include <stdlib.h>
#include <stdio.h>
#include <sys/time.h>

/* If puzzles get so big that an int can't be used as a bitfield then change
 * this. */
typedef int poss_t;

/* Structure to represent the remaining possibilities for the board. */
typedef struct {
	poss_t position[SIZE][SIZE];
	int small_changed; /* Whether the board has been changed since last iteration */
	int changed; /* Whether the board has been changed since last iteration */
	int impossible; /* Whether a contradiction has been found */
} board_t;

/* Wrapper struct for i,j coordinates */
typedef struct {
	int i, j;
} board_pos_t;

typedef struct {
	int total_guesses;
	int total_solutions;
	int max_subset_size;
} recursion_data_t;

int choose(n, r) {
	int a = 1;
	int i;

	if (2*r>n)
		r = n-r;
	for (i=0; i<r; i++)
		a *= (n-i);
	for (i=0; i<r; i++)
		a /= i+1;
	
	return a;
}

int subsets_of_size[SIZE];
poss_t *subsets[SIZE];

/* Check whether the number n is permitted by possibility poss */
int is_possible(poss_t poss, int n) {
	if (n<0 || n>SIZE)
		return 0;

	if (poss & (1<<n))
		return 1;
	else
		return 0;
}

/* Count possibilities */
int count_possibilities(poss_t poss) {
	int i, c=0;
	for (i=0; i<SIZE; i++) {
		if (is_possible(poss, i))
			c++;
	}
	return c;
}

/* For iterating through all possibilities, this gives the first one */
poss_t first_possibility() {
	return (poss_t)0;
}

/* For iterating through all possibilities, this checks if there are any more */
int more_possibilities(poss_t poss) {
	if (poss == UNKNOWN)
		return 0;
	else
		return 1;
}

/* For iterating through all possibilities, this gets the next one */
poss_t next_possibility(poss_t poss) {
	return (poss_t)((poss+1) & UNKNOWN);
}

void free_subsets() {
	int s;
	for (s=0; s<SIZE; s++) {
		free(subsets[s]);
	}
}

void make_subsets() {
	int s, r;
	poss_t current_poss;

	for(s=0; s<SIZE; s++) {
		r = choose(SIZE, s);
		subsets[s] = (poss_t*)malloc(r*sizeof(poss_t));
		if (subsets[s] == NULL) {
			fprintf(stderr, "malloc failure\n");
			exit(1);
		}

		subsets_of_size[s] = 0;
	}

	current_poss = first_possibility();
	while(1) {
		int c = count_possibilities(current_poss);
		if (c < SIZE) {
			subsets[c][subsets_of_size[c]] = current_poss;
			subsets_of_size[c] += 1;
		}
		
		if (more_possibilities(current_poss))
			current_poss = next_possibility(current_poss);
		else
			break;
	}
}

/* Represent the certainty that a square contains the number i */
poss_t num_to_possibility(int i) {
	return 1<<i;
}

/* Convert a character to a possibility (for reading the input file) */
poss_t char_to_possibility(char c) {
	switch (c) {
		case '1':
		case '2':
		case '3':
		case '4':
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			return num_to_possibility(c-'1');
	}

	return UNKNOWN;
}

/* Print out a solution. Will print nonsense if the board is not solved. */
void print_solved_board(board_t *board) {
	int i, j, k;
	for (j=0; j<SIZE; j++) {
		if (j%3 == 0 && j != 0)
			printf("\n");
		for (i=0; i<SIZE; i++) {
			if (i%3 == 0 && i != 0)
				printf("  ");
			for (k=0; k<SIZE; k++) {
				if (is_possible(board->position[i][j], k)) {
					printf("%d", k+1);
					break;
				}
			}
			if (i < SIZE-1)
				printf(" ");
		}
		printf("\n");
	}
}

/* Print out the internal representation of all possibilities for the board.
 * Mainly useful for debugging */
void print_board(board_t *board) {
	int i, j, k, l;
	for (j=0; j<SIZE; j++) {
		for (l=0; l<SIZE; l+=N) {
			for (i=0; i<SIZE; i++) {
				for (k=l; k<l+N; k++) {
					if (is_possible(board->position[i][j], k))
						printf("%d", k+1);
					else
						printf(".");
				}
				printf(" ");
				if (i%N==N-1)
					printf("  ");
			}
			printf("\n");
		}
		printf("\n");
		if (j%N==N-1)
			printf("\n");
	}
	printf("\n\n");

	for (j=0; j<SIZE; j+=1) {
		if (j%3 == 0)
			printf("\n");
		for (i=0; i<SIZE; i+=1) {
				if (i%3 == 0)
					printf("  ");
				if (count_possibilities(board->position[i][j]) != 1)
					printf(" . ");
				else {
					for (k=0; k<SIZE; k+=1) {
						if (is_possible(board->position[i][j], k)) {
							printf(" %d ", k+1);
						}
					}
				}
		}
		printf("\n");
	}
	printf("\n");

	for (k=0; k<SIZE; k+=1) {
		printf("%d\n", k+1);
		for (j=0; j<SIZE; j+=1) {
			if (j%3 == 0)
				printf("\n");
			for (i=0; i<SIZE; i+=1) {
					if (i%3 == 0)
						printf("  ");
					if (is_possible(board->position[i][j], k) &&
						count_possibilities(board->position[i][j]) != 1)

						printf("   ");
					else
						printf("XX ");
			}
			printf("\n");
		}
		printf("\n");
	}
}

/* Combine possibilities a and b */
poss_t poss_union(poss_t a, poss_t b) {
	return (a | b);
}

/* Calculates the coordinates of the given square in the given row */
board_pos_t row_position(int row, int square) {
	board_pos_t pos;
	pos.i = square;
	pos.j = row;
	return pos;
}

/* Calculates the coordinates of the given square in the given column */
board_pos_t col_position(int col, int square) {
	board_pos_t pos;
	pos.i = col;
	pos.j = square;
	return pos;
}

/* Calculates the coordinates of the given square in the given block */
board_pos_t block_position(int block, int square) {
	board_pos_t pos;
	pos.i = square%N + N*(block%N);
	pos.j = square/N + N*(block/N);
	return pos;
}

/* Remove possibilities b from the given position on the given board. If this
 * action actually changes the board then flag this. */
void remove_possibilities(board_t *board, board_pos_t position, 
	poss_t b) {

	poss_t a = board->position[position.i][position.j];
	board->position[position.i][position.j] = a&(~b)&UNKNOWN;
	if ((a^b) != (a|b))
		board->small_changed = board->changed = 1;
}

/* Check the given subset of squares of the given {row,column,block} to see if
 * it can be used to eliminate possibilities */
void check_subset(board_t *board, board_pos_t position(int, int), 
	poss_t subset, int k, int subset_size) {
	/* k is the number of the row, column, or block */

	int i;
	int possibility_count;
	poss_t subset_poss = first_possibility();
	
	for (i=0; i<SIZE; i++) {
		if (is_possible(subset, i)) {
			/* The given subset contains i */
			board_pos_t current_position = position(k, i);
			subset_poss = poss_union(subset_poss,
				board->position
					[current_position.i]
					[current_position.j]);
		}
	}

	possibility_count = count_possibilities(subset_poss);

	if (subset_size == possibility_count) {
		board->small_changed = 0;
		for (i=0; i<SIZE; i++) {
			if (!(is_possible(subset, i))) {
				board_pos_t current_position = position(k, i);
				remove_possibilities(board, current_position,
					subset_poss);
			}
		}
		if (0 &&
				board->small_changed && subset_size != 1 && subset_size != 8) {
			printf("Changed subset = {");
			for (i=0; i<SIZE; i++) {
				if (is_possible(subset_poss, i)) {
					printf("%d", i+1);
				}
			}
			printf("}, k = %d\n", k);

			print_board(board);
		}
	}

	if (subset_size > possibility_count) {
		board->impossible = 1;
	}
}

/* Check all subsets of all {row,column,block}s of the given size */
void check_subsets(board_t *board, board_pos_t position(int, int), int size) {
	int i, k;
	poss_t subset;

	for (k=0; k<SIZE; k++) {
		for (i=0; i<subsets_of_size[size] && !board->changed; i++) {
			subset = subsets[size][i];
			check_subset(board, position, subset, k, size);
		}
	}
}

/* Solve the given board */
int solve(board_t *board, int guesses, recursion_data_t *rd) {
	int i, j, k, s, impossible;
	board_t board_copy;

	do {
		board->changed = 0;
		check_subsets(board, row_position, 1);
		check_subsets(board, row_position, 8);
		check_subsets(board, col_position, 1);
		check_subsets(board, col_position, 8);
		check_subsets(board, block_position, 1);
		check_subsets(board, block_position, 8);
		if (!board->changed) {
			for (s=2; s<SIZE-2; s++) {
				check_subsets(board, row_position, s);
				check_subsets(board, col_position, s);
				check_subsets(board, block_position, s);
				if (board->impossible)
					break;
			}
		}
	} while (board->changed && !board->impossible);

	if (board->impossible)
		return 1;
	
	for (i=0; i<SIZE; i++) {
		for (j=0; j<SIZE; j++) {
			if (count_possibilities(board->position[i][j]) != 1) {

		/*		print_board(board); */
		/*		return 0; */

				/* Not solved, so guess */
				impossible = 1;
				for (k=0; k<SIZE; k++) {
					if (is_possible(board->position[i][j], k)) { 
						board_copy = *board;
						board_copy.position[i][j] = num_to_possibility(k);
						rd->total_guesses += 1;
						if (solve(&board_copy, guesses+1, rd) == 0) {
							impossible = 0;
							return 0;
						}
					}
				}
				return impossible;
			}
		}
	}
	rd->total_solutions += 1;
	print_solved_board(board);
	fprintf(stderr, "Guesses: %d\n", guesses);
	return 0;
}

/* Read the input board from stdin and try and solve it */
int main() {
	board_t board;
	recursion_data_t rd;
	int i, j;
	char *line;
	size_t n;
	ssize_t m;
	struct timeval tv1, tv2;

	n=0;
	for (j=0; j<SIZE; j++) {
		if ((m=getline(&line, &n, stdin)) == -1) {
			printf("Not enough input lines\n");
			exit(1);
		}
		if (m<=9) {
			printf("Not enough input at line %d\n", j);
			exit(1);
		}
		for (i=0; i<SIZE; i++) {
			board.position[i][j] = char_to_possibility(line[i]);
		}
	}
	while ((m=getline(&line, &n, stdin)) != -1) {
		if (m != 4) {
			printf("Bad line at extras\n");
			continue;
		}
		j=line[0]-'1';
		i=line[1]-'1';
		if (i<0 || i >= SIZE || j < 0 || j >= SIZE) {
			printf("Out of bounds at extras\n");
			continue;
		}
		board.position[i][j] &= ~char_to_possibility(line[2]);
	}
	free(line);
	board.impossible = 0;

	rd.total_guesses = 0;
	rd.total_solutions = 0;

	make_subsets();

	gettimeofday(&tv1, NULL);
	solve(&board, 0, &rd);
	gettimeofday(&tv2, NULL);

	fprintf(stderr, "Time taken: %fs\n", (tv2.tv_usec - tv1.tv_usec)*1.0e-6 +
		tv2.tv_sec - tv1.tv_sec);

	free_subsets();

	return 0;
}
