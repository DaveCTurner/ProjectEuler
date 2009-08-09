#!/usr/bin/perl

use strict;

sub pentagonal {
	my $n = shift;
	return ($n * 3 - 1) * $n / 2;
}

sub generalised_pentagonal {
	my $n = shift;
	if ($n & 0x01) {
		return pentagonal(($n+1)/2);
	} else {
		return pentagonal(-$n/2);
	}
}

my @pt = (1);
for (my $n = 1; ; $n++) {
	my $f = -1;
	my $r = 0;

	for (my $i = 1; ; $i++) {
		my $k = generalised_pentagonal($i);
		$k = $n - $k;
		last if $k < 0;
		
		if ($i & 0x01) { $f = -$f; }
		if ($f > 0) {
			$r += $pt[$k];
			$r -= 1000000 if ($r >= 1000000);
		} else {
			$r -= $pt[$k];
			$r += 1000000 if ($r < 0);
		}
	}
	push @pt, $r;
	if (0 == $r % 10000) { printf "%d: %d\n", $n, $r; }
	if (0 == $r) { last; }
	if ($n % 100 == 0) {
		printf "%d\n", $n;
	}
}
