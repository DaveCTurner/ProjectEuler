#!/usr/bin/perl

use strict;
use Lingua::EN::Numbers qw/num2en/;

my $count = 0;
for (my $i = 1; $i <= 1000; $i++) {
	my $str = num2en($i);
	$str =~ s/[ -]//g;
	$count += length($str);
}
print "$count\n";
