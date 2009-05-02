#!/usr/bin/perl

use strict;

sub crossesPositiveYAxis {
	# Point-in-polygon algo - quick hack since there are no
	# special cases in the input.
	my ($x1, $y1, $x2, $y2) = @_;

	if (($x1 < 0) == ($x2 < 0)) { return 0; }

	# Linearly interpolate 'y' value at x = 0.
	my $y = (1.0 * $y2 - $y1) / ($x2 - $x1) * (0 - $x1) + $y1;

	return ($y > 0.0) ? 1 : 0;
}

my $insideCount = 0;

while (<>) {
	chomp;
	my ($x1, $y1, $x2, $y2, $x3, $y3) = split /,/;

	my $seg1 = crossesPositiveYAxis($x1, $y1, $x2, $y2);
	my $seg2 = crossesPositiveYAxis($x2, $y2, $x3, $y3);
	my $seg3 = crossesPositiveYAxis($x3, $y3, $x1, $y1);

	if ($seg1 ^ $seg2 ^ $seg3) {
		$insideCount += 1;
	}
}

printf "%d\n", $insideCount;
