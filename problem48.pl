#!/usr/bin/perl

use Math::BigInt;

use strict;

my $modulus = Math::BigInt->new('10000000000');

my $accumulator = Math::BigInt->bzero();

for (my $i = 1; $i < 1000; $i++) {
	$accumulator->badd(Math::BigInt->new($i)->bmodpow($i,$modulus));
}

print $accumulator->bmod($modulus);
