#!/usr/bin/perl

use Math::BigInt;
use strict;

my $n = Math::BigInt->new(3);
my $d = Math::BigInt->new(2);

for (my $i = 1; $i <= 1000; $i++) {
	printf("%d: %d/%d\n", $i, $n, $d);
	my $n2 = $n->bstr();
	my $d2 = $d->bstr();
	$n->badd(Math::BigInt->new($d2));
	$d->badd(Math::BigInt->new($n2));
#	($n, $d) = ($d, $n);
}
