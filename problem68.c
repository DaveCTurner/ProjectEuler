#define N 5 
/*
 * The cells are arranged in a N-gon with N 'satellite' cells
 * around its edge. Cells numbered 0..(N-1) are the cells in
 * the N-gon and those numbered N..(2N-1) are the satellites.
 * The satellites are numbered such that for each i in
 * 0..(N-1), cell i, cell (i+1)%N and cell i+N form a 'line'.
 */
int cells[N*2];

/*
 * Record of which numbers have already been used (1-based
 * numbering)
 */
char usedNumbers[1 + N*2];

#ifdef DEBUG
char indent[N+2];
#endif

int trySatellites(int lineIndex, int lineTotal, int minSatellite);

int tryEndLine(int lineIndex, int lineTotal, int minSatellite) {
	/*
	 * Try to end the indicated line (the satellite and centre
	 * are already filled in) and recurse.
	 */
#ifdef DEBUG
	indent[lineIndex] = ' ';
#endif
	
	if (N-1 == lineIndex) {
		/*
		 * Have arrived back at start, so it's already filled
		 * in. Just check it's ok.
		 */
#ifdef DEBUG
		int i;
		for (i = 0; i < N; i++) {
			printf("%s%d,%d,%d;", indent, cells[i+N], cells[i],
				cells[(i+1)%N]);
		}
		printf("%d", lineTotal);
#endif
		if ((cells[N-1] + cells[0] + cells[2*N - 1]) == lineTotal) {
#ifdef DEBUG
			printf(" OK\n");
			indent[lineIndex] = '\0';
#else
			int i;
			for (i = 0; i < N; i++) {
				printf("%d%d%d", cells[i+N], cells[i],
					cells[(i+1)%N]);
			}
			printf("\n", lineTotal);
#endif
			return 1;
		} else {
#ifdef DEBUG
			printf(" BAD\n");
			indent[lineIndex] = '\0';
#endif
			return 0;
		}
	}

#ifdef DEBUG
	printf("%sTrying to fill line %d: ", indent, lineIndex);
#endif

	int cellIndex = (lineIndex + 1);
	cells[lineIndex+1] 
		= lineTotal - cells[lineIndex] - cells[lineIndex + N];
#ifdef DEBUG
	printf("need %d", cells[lineIndex+1]);
#endif
	
	if (cells[lineIndex+1] <= 0 || cells[lineIndex+1] > 2*N
			|| usedNumbers[cells[lineIndex+1]]) {
#ifdef DEBUG
		printf(" but invalid\n");
		indent[lineIndex] = '\0';
#endif
		return 0;
	}
#ifdef DEBUG
	printf(" - ok\n");
#endif

	usedNumbers[cells[lineIndex+1]] = 1;
	int found 
		= trySatellites(lineIndex+1, lineTotal, minSatellite);
	usedNumbers[cells[lineIndex+1]] = 0;

#ifdef DEBUG
	indent[lineIndex] = '\0';
#endif
	return found;
}

int trySatellites(int lineIndex, int lineTotal, int minSatellite) {
	int satelliteCellIndex = lineIndex + N;
	int found = 0;
	for (cells[satelliteCellIndex] = 2*N;
			cells[satelliteCellIndex] > minSatellite;
			cells[satelliteCellIndex] -= 1) {
		if (usedNumbers[cells[satelliteCellIndex]]) {
			continue;
		}
		usedNumbers[cells[satelliteCellIndex]] = 1;

#ifdef DEBUG
		printf("%sTrying %d for satellite %d\n", indent,
			cells[satelliteCellIndex], lineIndex);
#endif

		/* Recursive search for remainder of grid */
		found |= tryEndLine(lineIndex, lineTotal, minSatellite);

		usedNumbers[cells[satelliteCellIndex]] = 0;
	}
	return found;
}

int main() {
#ifdef DEBUG
	memset(indent, 0, N+2);
#endif


	memset(usedNumbers, 0, 1+N*2);

	/*
	 * Have to maximise:
	 * 1) The smallest satellite, say, cells[N]
	 * 2) The number in the middle of its line: cells[0]
	 * 3) The number at the other end of its line: cells[1]
	 * 4) The next satellite: cells[N+1]
	 * 5) The number at the other end of its line: cells[2]
	 * 6) The next satellite: cells[N+2]
	 * and so on.
	 *
	 * Note: the smallest satellite is <= N+1 by the
	 * pigeonhole principle.
	 *
	 * Note: for the main part of the question where N = 5, 10
	 * should probably sort before 1 since it's the concatenated
	 * string we're trying to maximise.  Also, should restrict 10
	 * to appear as a satellite to make sure that the resulting
	 * string is 16 digits long.  But this doesn't seem to
	 * matter.
	 *
	 * Note: the sums along the lines are all equal to T, say;
	 * the total of all the cells is N(2N+1) and the total on the
	 * N-gon is R (for 'ring') where T = N(2N+1) + R and by the
	 * pigeonhole principle, N(N+1)/2 <= R <= N(3N+1)/2. It
	 * follows that (5N+3)/2 <= T/N <= (7N+3)/2 and note that T/N
	 * is equal to the sum along each line. Therefore there are
	 * N+1 possible values for T/N if N odd (and one fewer if N
	 * is even)
	 */

	/* Try different line totals as above. Smaller is better */
	int lineTotal;
	for (lineTotal = (5*N+3)/2;
			lineTotal <= (7*N+3)/2;
			lineTotal += 1) {

		/* Try different values for smallest satellite. */
		for (cells[N] = N+1; cells[N] > 0; cells[N] -= 1) {
			usedNumbers[cells[N]] = 1;

#ifdef DEBUG
			printf("Starting with %d\n", cells[N]);
#endif

			/* Try different values for the centre of its line. */
			for (cells[0] = 2*N; cells[0] > 0; cells[0] -= 1) {
				if (usedNumbers[cells[0]]) {
					continue;
				}
				usedNumbers[cells[0]] = 1;
#ifdef DEBUG
				printf("Next: %d\n", cells[0]);
#endif

				/* Recursive search for remainder of grid */
				tryEndLine(0, lineTotal, cells[N]);

				usedNumbers[cells[0]] = 0;
			}

			usedNumbers[cells[N]] = 0;
		}

	}
}
