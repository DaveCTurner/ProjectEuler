#!/usr/bin/perl

# How many hex. numbers are there with 16 digits which contain
# all three of 0, 1, A? Answer in hex.
#
# There are 16^16 in total.
# 15^16 contain no 0.
# 15^16 contain no 1.
# 15^16 contain no A.
# 14^16 contain no 0 or 1.
# 14^16 contain no 0 or A.
# 14^16 contain no 1 or A.
# 13^16 contain no 0, 1 or A.
#
# Inclusion-exclusion => 16^16 - 3*15^16 + 3*14^16 - 13^16 contain all three.
# 
# *except* this includes numbers with leading zeroes, which aren't counted.
#
# There are 16^16 in total.
# 15^16 + 15^15 + 15^14 + ... + 15 + 1 contain no 0.
# 15^16 contain no 1.
# 15^16 contain no A.
# 14^16 + 14^15 + 14^14 + ... + 14 + 1 contain no 0 or 1.
# 14^16 + 14^15 + 14^14 + ... + 14 + 1 contain no 0 or A.
# 14^16 contain no 1 or A.
# 13^16 + 13^15 + 13^14 + ... + 13 + 1 contain no 0, 1 or A.
#
#
# n^16 + n^15 + ... + n + 1 = (n^17-1)/(n-1)

use Math::BigInt;
use strict;

my $len = 16;

sub explen {
	my ($n) = @_;
	return Math::BigInt->new($n)->bpow($len);
}

sub gplen {
	my ($n) = @_;
	return Math::BigInt->new($n)->bpow($len+1)->bsub(1)->bdiv($n-1);
}

my $n = explen(16);
$n->bsub(gplen(15));
$n->bsub(explen(15));
$n->bsub(explen(15));
$n->badd(gplen(14));
$n->badd(gplen(14));
$n->badd(explen(14));
$n->bsub(gplen(13));

printf("%s\n%s\n", $n->bstr(), substr((uc $n->as_hex()), 2));
