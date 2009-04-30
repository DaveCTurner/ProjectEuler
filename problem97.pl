#!/usr/bin/perl

use Math::BigInt lib => 'GMP';

$x = Math::BigInt->new(2);
$m = Math::BigInt->new('10000000000');
$x->bmodpow(7830457, $m);
$x->bmuladd(28433, 1);
$x->bmod($m);

printf("%s", $x->bstr());
