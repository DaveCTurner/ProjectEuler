#!/usr/bin/perl

use strict;

my $n = 5000;

my @pents = (0);
my %pentsHash = ();

for (my $i = 1; $i < $n; $i++) {
	my $pent = $i * (3*$i-1) / 2;
	$pents[$i] = $pent;
	$pentsHash{$pent} = 1;
}

for (my $i = 1; $i < $n; $i++) {
	for (my $j = 1; $j < $i; $j++) {
		if ($pentsHash{$pents[$i] + $pents[$j]}
			&& ($pentsHash{$pents[$i] - $pents[$j]})) {

			printf "%d %d %d %d %d\n",
				$pents[$i] - $pents[$j], $i, $j, $pents[$i], $pents[$j];
		}
	}
}
