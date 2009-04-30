#!/usr/bin/perl

use Math::BigInt lib => 'GMP';

use strict;

sub digitSum {
	my ($x) = @_;
	my $sum = 0;
	map { $sum += $_ } split //, $x;
	return $sum;
}

my $dxMax = 0;

for (my $a = 1; $a < 100; $a++) {
	for (my $b = 1; $b < 100; $b++) {
		my $x = Math::BigInt->new($a)->bpow($b)->bstr();
		my $dx = digitSum($x);
		if ($dx > $dxMax) {
			$dxMax = $dx;
			printf("%d %d %d\n", $a, $b, $dx);
		}
	}
}
