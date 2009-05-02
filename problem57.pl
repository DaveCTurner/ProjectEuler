#!/usr/bin/perl

use Math::BigInt;
use strict;

my $n = Math::BigInt->new(3);
my $d = Math::BigInt->new(2);

my $longerNumeratorCount = 0;

for (my $i = 1; $i <= 1000; $i++) {
#	printf("%d: %s/%s\n", $i, $n, $d);
	if ($n->length() > $d->length()) {
		$longerNumeratorCount += 1;
	}
	$n->badd($d);
	($n, $d) = ($d, $n);
	$n->badd($d);
}

printf("%d\n", $longerNumeratorCount);
