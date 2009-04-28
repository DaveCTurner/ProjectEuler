#!/usr/bin/perl

use strict;

my $n = 100000;

my @pents = (0);
my %pentsHash = ();

for (my $i = 1; $i < $n; $i++) {
	my $pent = $i * (3*$i-1) / 2;
	$pents[$i] = $pent;
	$pentsHash{$pent} = 1;
}

for (my $i = 1; $i < $n; $i++) {
	for (my $j = $i + 1; $j < $n; $j++) {
		if ($pentsHash{$pents[$i] + $pents[$j]}
			&& ($pentsHash{$pents[$j] - $pents[$i]})) {

			printf "%d %d %d %d %d\n",
				$pents[$j] - $pents[$i], $i, $j, $pents[$i], $pents[$j];
		}
	}
}
