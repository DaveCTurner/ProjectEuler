#!/usr/bin/perl

use strict;

chomp @ARGV[0];
my @encodedBytes = split /,/, @ARGV[0];
my @password = unpack 'C3', 'god';

my $total = 0;

for (my $i = 0; $i <= $#encodedBytes; $i++) {
	my $decodedByte = $encodedBytes[$i] ^ $password[$i % 3];
	print chr($decodedByte);
	$total += $decodedByte;
}

printf("\n%d\n", $total);
