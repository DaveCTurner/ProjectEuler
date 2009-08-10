#!/usr/bin/perl

use Math::BigInt;
use strict;

my @values = map { Math::BigInt->new($_) } (1,1,1,2);

# values[n] = values[n-1] (if first square is black)
#           + values[n-4] (if first block is red length 3)
#           + values[n-5] (if first block is red length 4)
#     + ... + values[0]   (if first block is red length n-1)
#           + 1           (if first block is red length n)

my $acc = Math::BigInt->new(1);
for (my $i = 4; $i <= 50; $i++) {
	$acc->badd($values[$i-4]);
	$values[$i] = $values[$i-1]->copy()->badd($acc);
	printf("values[%d] = %s\n", $i, $values[$i]->bstr());
} 

printf("%s\n", $values[50]->bstr());

