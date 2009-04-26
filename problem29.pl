#!/usr/bin/perl

use Math::BigInt;
use strict;

for (my $a = 2; $a <= 100; $a++) {
	for (my $b = 2; $b <= 100; $b++) {
		print Math::BigInt->new($a)->bpow($b)."\n";
	}
}
