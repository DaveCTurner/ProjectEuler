#!/usr/bin/perl

use strict;

my $allowLeftMoves = 0;
my $allowUpMoves = 0;
my $useTestArray = 0;
my $startAndFinishInAnyRow = 0;

my $testArray = [
	[qw/ 131 673 234 103  18 /],
	[qw/ 201  96 342 965 150 /],
	[qw/ 630 803 746 422 111 /],
	[qw/ 537 699 497 121 956 /],
	[qw/ 805 732 524  37 331 /],
];

my $array = $testArray;

unless ($useTestArray) {
	$array = [];
	while (<>) {
		if ($startAndFinishInAnyRow) {
			push @$array, [0, (split /,/), 0];
		} else {
			push @$array, [split /,/];
		}
	}
}

my $colSize = scalar @$array;
my $colCount = scalar @{$array->[0]};

# Array of minimal distances to each cell.
my @bestRoutes = ();

sub minus1 { return -1; }

for (my $row = 0; $row < $colSize; $row += 1) {
	$bestRoutes[$row] = [map { minus1 } (1..$colCount)];
}

$bestRoutes[0]->[0] = $array->[0]->[0];
my $changing;
do {
	$changing = 0;
	for (my $row = 0; $row < $colSize; $row += 1) {
		for (my $col = 0; $col < $colCount; $col += 1) {

			my $minAdjacentRoute = undef;
			if ($row > 0 && $bestRoutes[$row-1]->[$col] != -1
				&& (!defined($minAdjacentRoute) 
					|| $bestRoutes[$row-1]->[$col] < $minAdjacentRoute)) {
				$minAdjacentRoute = $bestRoutes[$row-1]->[$col];
			}
			if ($row < $colSize - 1 && $bestRoutes[$row+1]->[$col] != -1
				&& $allowUpMoves && (!defined($minAdjacentRoute) 
					|| $bestRoutes[$row+1]->[$col] < $minAdjacentRoute)) {
				$minAdjacentRoute = $bestRoutes[$row+1]->[$col];
			}
			if ($col > 0 && $bestRoutes[$row]->[$col-1] != -1
				&& (!defined($minAdjacentRoute) 
					|| $bestRoutes[$row]->[$col-1] < $minAdjacentRoute)) {
				$minAdjacentRoute = $bestRoutes[$row]->[$col-1];
			}
			if ($col < $colCount - 1 && $bestRoutes[$row]->[$col+1] != -1
				&& $allowLeftMoves && (!defined($minAdjacentRoute) 
					|| $bestRoutes[$row]->[$col+1] < $minAdjacentRoute)) {
				$minAdjacentRoute = $bestRoutes[$row]->[$col+1];
			}

			my $minRoute = $minAdjacentRoute + $array->[$row]->[$col];

			if ($bestRoutes[$row]->[$col] == -1) {
				if (defined($minAdjacentRoute)) {
					$bestRoutes[$row]->[$col] = $minRoute;
					$changing = 1;
				} else {
					die "Unreachable update";
				}
			} else {
				if ($bestRoutes[$row]->[$col] > $minRoute) {
					$bestRoutes[$row]->[$col] = $minRoute;
					$changing = 1;
				}
			}
		}
	}
} while ($changing > 0);

#for (my $row = 0; $row < $colSize; $row += 1) {
#	for (my $col = 0; $col < $colCount; $col += 1) {
#		printf("%9d ", $bestRoutes[$row]->[$col]);
#	}
#	printf("\n");
#}

printf "%d\n", $bestRoutes[$colSize-1]->[$colCount-1];
