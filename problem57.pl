#!/usr/bin/perl

use Math::BigInt;
use strict;

my $n = Math::BigInt->new(3);
my $d = Math::BigInt->new(2);

for (my $i = 1; $i <= 1000; $i++) {
	printf("%d: %d/%d\n", $i, $n, $d);
	$n->badd($d);
	($n, $d) = ($d, $n);
	$n->badd($d);
}
