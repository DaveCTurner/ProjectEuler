#!/usr/bin/perl

use Math::BigInt;
use strict;

my $m = 50;

my @values = map { Math::BigInt->new($_) } ((1)x$m,2);

# values[n] = values[n-1] (if first square is black)
#           + values[n-m-1] (if first block is red length m)
#           + values[n-m-2] (if first block is red length m+1)
#     + ... + values[0]   (if first block is red length n-1)
#           + 1           (if first block is red length n)

my $i;
map { printf("values[%d] = %s\n", $i++, $_->bstr()); } @values;

my $acc = Math::BigInt->new(1);
for ($i = $m+1; ; $i++) {
	$acc->badd($values[$i-$m-1]);
	$values[$i] = $values[$i-1]->copy()->badd($acc);
	printf("values[%d] = %s\n", $i, $values[$i]->bstr());
	if ($values[$i] > 1000000) { last; }
} 

printf("%d\n", $i);

