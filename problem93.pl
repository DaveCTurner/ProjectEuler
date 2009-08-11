#!/usr/bin/perl

# a b c d op op op = a op (b op (c op d))
# a b c op d op op = a op ((b op c) op d)
# a b c op op d op = (a op (b op c)) op d
# a b op c d op op = (a op b) op (c op d)
# a b op c op d op = ((a op b) op c) op d

use strict;
use Math::BigRat;

$| = 1;

sub permutations {
	my @unused_items = @_;
	my @used_items = ();

	return ([]) unless @unused_items;

	my @retval = ();
	while (@unused_items) {
		my $current_item = shift @unused_items;
		my @sub_perms = permutations(@unused_items, @used_items);
		push @retval, map { [$current_item, @$_] } @sub_perms;
		push @used_items, $current_item;
	}

	return @retval;
}

my @index_permutations = permutations(0..3);
die unless ((4*3*2*1) == @index_permutations);
#printf("Index permutations\n");
#for my $p (@index_permutations) {
#	printf("[%s]\n", join ', ', @$p);
#}

sub repeating_permutations {
	my ($n, $p) = @_;
	return ([]) unless $n > 0;

	my @retval = ();
	my @sub_perms = repeating_permutations($n-1, $p);
	for my $i (0..($p-1)) {
		push @retval, map { [$i, @$_] } @sub_perms;
	}

	return @retval;
}

my @op_permutations = repeating_permutations(3, 4);
die unless ((4*4*4) == @op_permutations);
#printf("Op permutations\n");
#for my $p (@op_permutations) {
#	printf("[%s]\n", join ', ', @$p);
#}

sub enumerate_digits {
	my ($n, $max) = @_;
	return ([]) unless $n > 0;

	my @retval = ();
	for my $i (0..$max) {
		my @sub_perms = enumerate_digits($n-1, $i-1);
		push @retval, map { [@$_, $i] } @sub_perms;
	}

	return @retval;
}

my @digit_sets = enumerate_digits(4, 9);
die unless ((10*9*8*7)/(4*3*2*1) == @digit_sets);
#printf("Digit sets\n");
#for my $p (@digit_sets) {
#	printf("[%s]\n", join ', ', @$p);
#}

my @operation_strings = ( '+', '-', '*', '/' );

sub apply_operation {
	my ($a, $b, $op) = @_;
	return undef unless defined($a) && defined($b);
	if    (0 == $op) { return $a->copy()->badd($b); }
	elsif (1 == $op) { return $a->copy()->bsub($b); }
	elsif (2 == $op) { return $a->copy()->bmul($b); }
	else             { return $a->copy()->bdiv($b); }
#	elsif ((0 != $b) #&& (0 == ($a % $b))
#) { return $a / $b; }
#	else { return undef; }
}

my @tree_formats = (
	"%d%s(%d%s(%d%s%d))",
	"%d%s((%d%s%d)%s%d)",
	"(%d%s(%d%s%d))%s%d",
	"((%d%s%d)%s%d)%s%d",
	"(%d%s%d)%s(%d%s%d)",
);

sub apply_operations_0 {# a*(b*(c*d))
	my ($digits, $operations) = @_;
	my $a = apply_operation($digits->[2], $digits->[3], $operations->[2]);
	my $b = apply_operation($digits->[1], $a,           $operations->[1]);
	my $c = apply_operation($digits->[0], $b,           $operations->[0]);
	return $c;
}

sub apply_operations_1 {# a*((b*c)*d)
	my ($digits, $operations) = @_;
	my $a = apply_operation($digits->[1], $digits->[2], $operations->[1]);
	my $b = apply_operation($a,         , $digits->[3], $operations->[2]);
	my $c = apply_operation($digits->[0], $b,           $operations->[0]);
	return $c;
}

sub apply_operations_2 {# (a*(b*c))*d
	my ($digits, $operations) = @_;
	my $a = apply_operation($digits->[1], $digits->[2], $operations->[1]);
	my $b = apply_operation($digits->[0], $a,           $operations->[0]);
	my $c = apply_operation($b,           $digits->[3], $operations->[2]);
	return $c;
}

sub apply_operations_3 {# ((a*b)*c)*d
	my ($digits, $operations) = @_;
	my $a = apply_operation($digits->[0], $digits->[1], $operations->[0]);
	my $b = apply_operation($a,           $digits->[2], $operations->[1]);
	my $c = apply_operation($b,           $digits->[3], $operations->[2]);
	return $c;
}

sub apply_operations_4 {# (a*b)*(c*d)
	my ($digits, $operations) = @_;
	my $a = apply_operation($digits->[0], $digits->[1], $operations->[0]);
	my $b = apply_operation($digits->[2], $digits->[3], $operations->[2]);
	my $c = apply_operation($a,           $b,           $operations->[1]);
	return $c;
}

sub apply_operations {
	my ($digits, $operations, $t) = @_;
	my $v = apply_operations_impl($digits, $operations, $t);

	if ($v->is_int()) { return $v->numify(); } else { return undef; }
}

sub apply_operations_impl {
	my ($digits, $operations, $t) = @_;
	if    (0 == $t) { return apply_operations_0($digits, $operations); }
	elsif (1 == $t) { return apply_operations_1($digits, $operations); }
	elsif (2 == $t) { return apply_operations_2($digits, $operations); }
	elsif (3 == $t) { return apply_operations_3($digits, $operations); }
	elsif (4 == $t) { return apply_operations_4($digits, $operations); }
} 

my $best = 0;
my $best_digits = undef;

for my $digits (@digit_sets) {
	my @found = ();
	my $found_count = 0;
	my $max_found = 0;
	for my $indices (@index_permutations) {
		my @permuted_digits 
			= map { Math::BigRat->new($digits->[$_],1) } @$indices;
		for my $operations (@op_permutations) {
			for my $t (0..4) {
				my $v = apply_operations(\@permuted_digits, $operations, $t);
#		printf("%s = ".$tree_formats[$t]."\n",
#				defined($v) ? sprintf("%d", $v) : 'undef',
#			$permuted_digits[0], $operation_strings[$operations->[0]],
#			$permuted_digits[1], $operation_strings[$operations->[1]],
#			$permuted_digits[2], $operation_strings[$operations->[2]],
#			$permuted_digits[3]);
				if (defined($v) && 0 < $v) {
					unless ($found[$v]) {
						$found_count += 1;
						$found[$v] = [[@permuted_digits], [@$operations], $t];
						if ($v > $max_found) { $max_found = $v; }
					}
				}
			}
		}
	}

	my $max_consecutive = -1;
	for my $i (0..($#found)) {
		unless ($found[$i]) {
			$max_consecutive = $i-1 if (-1 == $max_consecutive);
			next;
		}
		my ($permuted_digits, $operations, $t) = @{$found[$i]};
		printf("%d = ".$tree_formats[$t]."\n", $i,
			$permuted_digits->[0], $operation_strings[$operations->[0]],
			$permuted_digits->[1], $operation_strings[$operations->[1]],
			$permuted_digits->[2], $operation_strings[$operations->[2]],
			$permuted_digits->[3]);
	}
	printf("[%s]: %d consec %d total %d max\n", (join ', ', @$digits),
		$max_consecutive, $found_count, $max_found);
	if ($max_consecutive > $best) {
		$best = $max_consecutive;
		$best_digits = [@$digits];
	}
}
printf("Max: %d\n", $best-1);
printf("Digits: [%s]\n", join ', ', @$best_digits);
printf("%s\n", join '', @$best_digits);
