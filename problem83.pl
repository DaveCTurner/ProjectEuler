#!/usr/bin/perl

# NB This has a bug, although it still works on the test data.
# The bug is that we only update nodes whose path depends on other updated
# nodes in the recursion. In particular, this algorithm fails to answer
# problem 82 correctly, where some node gets improved so much that it changes
# the paths of other nodes around it.

use strict;

my $allowLeftMoves = 0;
my $allowUpMoves = 1;
my $startInFirstColumn = 1;
my $endInLastColumn = 1;
my $useTestArray = 0;

my $testArray = [
	[qw/ 131 673 234 103  18 /],
	[qw/ 201  96 342 965 150 /],
	[qw/ 630 803 746 422 111 /],
	[qw/ 537 699 497 121 956 /],
	[qw/ 805 732 524  37 331 /],
];

my $array = $testArray;

if (0 == $useTestArray) {
	$array = [];
	while (<>) {
		push @$array, [split /,/];
	}
}

# First column - best paths are just the cell contents.
#
# Then, for each column, the best path is right one, then up/down
# some number of squares.

my $colSize = scalar @$array;
my $colCount = scalar @{$array->[0]};

# Array of minimal distances to each cell.
my @bestRoutes = ();

# Array of directions for the last jump of the minimal path
# from the top-left cell to each other cell.
# 1 = from above, 2 = from right, 3 = from below, 4 = from left.
# (and 0 for unknown and -1 for the first cell)
my @lastJumpDirections = ();

for (my $row = 0; $row < $colSize; $row += 1) {
	$bestRoutes[$row] = [];
	$lastJumpDirections[$row] = [];
	for (my $col = 0; $col < $colCount; $col += 1) {
		$bestRoutes[$row]->[$col] = 0;
		$lastJumpDirections[$row]->[$col] = 0;
	}
}

if ($startInFirstColumn) {
	for (my $row = 0; $row < $colSize; $row += 1) {
		$bestRoutes[$row]->[0] = $array->[$row]->[0];
		$lastJumpDirections[$row]->[0] = -1;
	}
} else {
	$bestRoutes[0]->[0] = $array->[0]->[0];
	$lastJumpDirections[0]->[0] = -1;
	for (my $row = 1; $row < $colSize; $row += 1) {
		$bestRoutes[$row]->[0] = $bestRoutes[$row-1]->[0] 
			+ $array->[$row]->[0];
		$lastJumpDirections[$row]->[0] = 1; # From above.
	}
}

sub improvePaths {
	my ($row, $col, $improvement) = @_;
	$bestRoutes[$row]->[$col] -= $improvement;
	if ($row > 0 && 3 == $lastJumpDirections[$row-1]->[$col]) {
		improvePaths($row-1, $col, $improvement);
	}
	if ($row < $colSize-1 && 1 == $lastJumpDirections[$row+1]->[$col]) {
		improvePaths($row+1, $col, $improvement);
	}
	if ($col > 0 && 2 == $lastJumpDirections[$row]->[$col-1]) {
		improvePaths($row, $col-1, $improvement);
	}
	if ($col < $colCount-1 && 4 == $lastJumpDirections[$row]->[$col+1]) {
		improvePaths($row, $col+1, $improvement);
	}
}

sub printState {
	for (my $row = 0; $row < $colSize; $row += 1) {
		for (my $col = 0; $col < $colCount; $col += 1) {
			my $directionString = '?';
			if (1 == $lastJumpDirections[$row]->[$col]) {
				$directionString = '^';
			}
			if (2 == $lastJumpDirections[$row]->[$col]) {
				$directionString = '>';
			}
			if (3 == $lastJumpDirections[$row]->[$col]) {
				$directionString = 'V';
			}
			if (4 == $lastJumpDirections[$row]->[$col]) {
				$directionString = '<';
			}
			
			printf "%09d(%s) ", $bestRoutes[$row]->[$col], $directionString;
		}
		printf "\n";
	}
	printf "\n";
}

#printState();

for (my $col = 1; $col < $colCount; $col += 1) {
	# Best route to top entry is always from the left.
	$bestRoutes[0]->[$col] = $bestRoutes[0]->[$col-1] + $array->[0]->[$col];
	$lastJumpDirections[0]->[$col] = 4; # From left.

	#printState();

	for (my $row = 1; $row < $colSize; $row += 1) {
		# Find the best route to ($row,$col)

		my $thisLength = $array->[$row]->[$col];
		my $fromAboveLength = $bestRoutes[$row-1]->[$col];
		my $fromLeftLength = $bestRoutes[$row]->[$col-1];

		if ($fromAboveLength < $fromLeftLength) {
			$bestRoutes[$row]->[$col] = $fromAboveLength + $thisLength;
			$lastJumpDirections[$row]->[$col] = 1; # From above
			if ($allowLeftMoves) {
				my $improvement = 
					$fromLeftLength - $fromAboveLength 
						- $thisLength - $array->[$row]->[$col-1];
				if ($improvement > 0) {
					$lastJumpDirections[$row]->[$col-1] = 2; # From right.
					improvePaths($row, $col-1, $improvement);
				}
			}
		} else {
			$bestRoutes[$row]->[$col] = $fromLeftLength + $thisLength;
			$lastJumpDirections[$row]->[$col] = 4; # From left
			if ($allowUpMoves) {
				my $improvement = 
					$fromAboveLength - $fromLeftLength 
						- $thisLength - $array->[$row-1]->[$col];
				if ($improvement > 0) {
					$lastJumpDirections[$row-1]->[$col] = 3; # From below.
					improvePaths($row-1, $col, $improvement);
				}
			}
		}
		#printState();
	}
}

if ($endInLastColumn) {
	my $min = $bestRoutes[0]->[$colCount-1];
	printf "%09d\n", $bestRoutes[0]->[$colCount-1];
	for (my $row = 1; $row < $colSize; $row++) {
		printf "%09d\n", $bestRoutes[$row]->[$colCount-1];
		if ($bestRoutes[$row]->[$colCount-1] < $min) {
			$min = $bestRoutes[$row]->[$colCount-1];
		}
	}
	printf "%d\n", $min;
} else {
	printf "%d\n", $bestRoutes[$colSize-1]->[$colCount-1];
}
