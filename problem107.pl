#!/usr/bin/perl

# Prim's algorithm for a minimal spanning tree.

use strict;

my @edgeWeights = ();
my @verticesAdded = ();

while (<>) {
	chomp;
	push @edgeWeights, [split /,/];
	push @verticesAdded, 0;
}

my $vertexCount = @edgeWeights;

my $totalWeight = 0;

my $asymmetric = 0;
for (my $i = 0; $i < $vertexCount; $i++) {
	for (my $j = 0; $j < $i; $j++) {
		if ($edgeWeights[$i]->[$j] ne $edgeWeights[$j]->[$i]) {
			printf("Asymmetric at (%d,%d) : '%s' != '%s'\n", $i, $j,
				$edgeWeights[$i]->[$j], $edgeWeights[$j]->[$i]);
			$asymmetric = 1;
		}
		$totalWeight += $edgeWeights[$i]->[$j]
			if $edgeWeights[$i]->[$j] ne '-';
	}
}
die "Asymmetric" if $asymmetric;

for (my $i = 0; $i < $vertexCount; $i++) {
	for (my $j = 0; $j < $vertexCount; $j++) {
		printf("%4s ", $edgeWeights[$i]->[$j]);
	}
	printf "\n";
}
printf "\n";

$verticesAdded[0] = 1;

for (my $iteration = 1; $iteration < $vertexCount; $iteration++) {
	my $bestEdge = undef;
	my $bestEdgeWeight = undef;
	for (my $i = 0; $i < $vertexCount; $i++) {
		next unless $verticesAdded[$i];
		for (my $j = 0; $j < $vertexCount; $j++) {
			next if $verticesAdded[$j];
			next if ($edgeWeights[$i]->[$j] eq '-');

			if (!defined($bestEdgeWeight) 
				|| $edgeWeights[$i]->[$j] < $bestEdgeWeight) {

				$bestEdge = [$i, $j];
				$bestEdgeWeight = $edgeWeights[$i]->[$j];
			}
		}
	}
	if (!defined($bestEdgeWeight)) {
		die "Couldn't find any more edges to add\n";
	}
	printf("Adding vertex %d: connection to %d (%d) is best\n",
		$bestEdge->[1], $bestEdge->[0], $bestEdgeWeight);
	$verticesAdded[$bestEdge->[1]] = 1;
	$totalWeight -= $bestEdgeWeight;
}

printf "%d\n", $totalWeight;
