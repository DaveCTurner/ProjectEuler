#!/usr/bin/perl

use strict;

my %triangles = ();

for (my $i = 0; $i < 20; $i++) {
	$triangles{$i*($i+1)/2} = 1;
}

while (<>) {
	chomp;
	my $total = 0;
	map { $total += $_ & 31 } unpack "C*", $_;
	if ($triangles{$total}) {
		printf "%s %d\n", $_, $total;
	}
}
