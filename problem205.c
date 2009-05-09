#include <stdlib.h>

int diceRoll(int faces) {
	return (rand() % faces) + 1;
}

void monteCarlo() {
	int rollCount;
	int winCount = 0;
	int i;

	srand(time());

	for (rollCount = 0; rollCount < 1000000; rollCount += 1) {

		int peterScore = 0;
		for (i = 0; i < 9; i++) {
			peterScore += diceRoll(4);
		}

		int colinScore = 0;
		for (i = 0; i < 6; i++) {
			colinScore += diceRoll(6);
		}

		if (peterScore > colinScore) {
			winCount += 1;
		}
	}

	printf("%d out of %d wins = %f\n", winCount, rollCount,
		(double)winCount/rollCount);
}

void countScores(int diceCount, int faceCount, int * results) {
	memset(results, 0, (1 + diceCount * faceCount) * sizeof(int));
	int* rolls = (int*)malloc(diceCount * sizeof(int));

	int i;
	for (i = 0; i < diceCount; i++) {
		rolls[i] = 1;
	}

	int total = diceCount;
	while (1) {
		results[total] += 1;
		results[0] += 1;

		i = 0;
		while (i < diceCount && rolls[i] == faceCount) {
			rolls[i] = 1;
			total -= faceCount - 1;
			i += 1;
		}
		if (i == diceCount) {
			break;
		}
		rolls[i] += 1;
		total += 1;
	}
	free(rolls);
}

int main() {
	int i;

	int peterFrequencies[37];
	countScores(9, 4, peterFrequencies);
	for (i = 1; i <= 36; i++) {
		printf("%d %d\n", i, peterFrequencies[i]);
	}
	printf("%d total\n", peterFrequencies[0]);
	
	int colinFrequencies[37];
	countScores(6, 6, colinFrequencies);
	for (i = 1; i <= 36; i++) {
		printf("%d %d\n", i, colinFrequencies[i]);
	}
	printf("%d total\n", colinFrequencies[0]);

	int winnerScore, loserScore;
	long long int winCount = 0;
	for (winnerScore = 1; winnerScore <= 36; winnerScore += 1) {
		for (loserScore = 1; loserScore < winnerScore; loserScore += 1) {
			winCount += peterFrequencies[winnerScore] * 
				colinFrequencies[loserScore];
		}
	}
	printf("%lld wins\n", winCount);
	printf("0.%07d\n", (int)floor((double)winCount / peterFrequencies[0] /
		colinFrequencies[0] * 10000000.0 + 0.5));
}
