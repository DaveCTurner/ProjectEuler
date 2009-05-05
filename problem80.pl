#!/usr/bin/perl

use Math::BigInt;

use strict;

my $total = 0;
for (my $i = 2; $i <= 100; $i++) {
	if (0 == Math::BigInt->new($i)->bsqrt()->bpow(2)->bcmp($i)) {
		next;
	}
	my $sqrtI = Math::BigInt->new($i)->blsft(200,10)->bsqrt();

	printf("%s\n", $sqrtI->bstr());
	for (my $dig = 1; $dig <= 100; $dig++) {
		$total += $sqrtI->digit($dig);
	}
}
printf("%d\n", $total);
