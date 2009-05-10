#!/usr/bin/perl

use Math::BigInt;
use strict;

my $tileCount = 1000000;

my $laminaCount = 0;

my $maxThickness = int(sqrt($tileCount)/2); # Thickness of annulus.

for (my $holeSize = 1; $maxThickness; $holeSize += 1) {
	while (4 * $maxThickness * ($holeSize + $maxThickness) > $tileCount) {
		$maxThickness -= 1;
	}

#	printf("Hole %d max thickness %d full size %dx%d = %d - %d = %d\n",
#		$holeSize, $maxThickness,
#		$holeSize + 2 * $maxThickness, $holeSize + 2 * $maxThickness,
#		($holeSize + 2 * $maxThickness) * ($holeSize + 2 * $maxThickness),
#		$holeSize * $holeSize,
#		($holeSize + 2 * $maxThickness) * ($holeSize + 2 * $maxThickness) -
#		$holeSize * $holeSize
#	);
	
	$laminaCount += $maxThickness;
}

printf("%d\n", $laminaCount);
