#!/usr/bin/perl

use strict;

my $total = 0;

for (my $n = 1; $n < 1000000; $n++) {
	my $nstr10 = "$n";
	my $nstr2 = unpack("B32", pack("N", $n));
	$nstr2 =~ s/^0+//;

	if ((reverse $nstr10) eq $nstr10 && (reverse $nstr2) eq $nstr2) {
		print "$nstr10 = $nstr2\n";
		$total += $n;
	}
}

print "Total $total\n";
