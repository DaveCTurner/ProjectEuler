#!/usr/bin/perl

use strict;

my $testArray = [
	[qw/ 131 673 234 103  18 /],
	[qw/ 201  96 342 965 150 /],
	[qw/ 630 803 746 422 111 /],
	[qw/ 537 699 497 121 956 /],
	[qw/ 805 732 524  37 331 /],
];

my $array = $testArray;

my $array = [];

while (<>) {
	push @$array, [split /,/];
}

# First column - best paths are just the cell contents.
#
# Then, for each column, the best path is right one, then up/down
# some number of squares.

my $colSize = scalar @$array;
my $colCount = scalar @{$array->[0]};

for (my $col = 1; $col < $colCount; $col += 1) {
	my @bestRoutes = ();

	for (my $row = 0; $row < $colSize; $row += 1) {
		# Find the best route to ($col,$row)

		# First attempt - just a right move
		my $shortestPath = 
			$array->[$row]->[$col-1] + $array->[$row]->[$col];
		
		my $verticalPath = 0;
		# Look for better options upwards
		for (my $entryRow = $row; $entryRow >= 0; $entryRow -= 1) {
			$verticalPath += $array->[$entryRow]->[$col];
			my $totalPath = $array->[$entryRow]->[$col-1]
				+ $verticalPath;
			if ($totalPath < $shortestPath) {
				$shortestPath = $totalPath;
			}
		}

		my $verticalPath = 0;
		# Look for better options downwards
		for (my $entryRow = $row; $entryRow < $colSize; $entryRow += 1) {
			$verticalPath += $array->[$entryRow]->[$col];
			my $totalPath = $array->[$entryRow]->[$col-1]
				+ $verticalPath;
			if ($totalPath < $shortestPath) {
				$shortestPath = $totalPath;
			}
		}

		$bestRoutes[$row] = $shortestPath;
	}

	for (my $row = 0; $row < $colSize; $row += 1) {
		$array->[$row]->[$col] = $bestRoutes[$row];
	}
}

my $shortestPath = undef;
for (my $row = 0; $row < $colSize; $row += 1) {
	if (!defined($shortestPath)
			|| $array->[$row]->[$colCount-1] < $shortestPath) {
		$shortestPath = $array->[$row]->[$colCount-1];
	}
}

printf "%d\n", $shortestPath;
