#!/usr/bin/perl

use strict;

chomp $ARGV[0];
my @encoded = split /,/, $ARGV[0];

my @passcode = map { ord } ('g', 'o', 'd');

#for ($passcode[0] = 0; $passcode[0] <= 26; $passcode[0] += 1) {
#for ($passcode[1] = 0; $passcode[1] <= 26; $passcode[1] += 1) {
#for ($passcode[2] = 0; $passcode[2] <= 26; $passcode[2] += 1) {

print join ' ', @passcode;
print "\n";

my $total = 0;

for (my $i = 0; $i < $#encoded; $i++) {
	my $passcodePosition = $i % 3;
	
	my $decoded = $encoded[$i] ^ $passcode[$passcodePosition];
	$total += $decoded;
#	$decoded = $decoded & 31;
#	$decoded = $decoded | 96;
	print chr($decoded);
	print " ";
	print $decoded;
	print "\n";
}
print "\n";

printf "%d\n", $total;

#}
#}
#}


