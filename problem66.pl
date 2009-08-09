#!/usr/bin/perl

use strict;

use Math::BigRat;

sub solve_pell {
	my $D = shift;

#	printf("Solving Pell for D = %d\n", $D);

	my $p = Math::BigRat->new(1,1);
	my $q = Math::BigRat->new(0,1);

	my @cf_sequence = ();

	my $first = 1;

	while (1) {
		my $y_floor = Math::BigRat->new($D)->bsqrt()->bmul($p)->badd($q)->bfloor();
#		printf("p = %s\n", $p->bstr());
#		printf("q = %s\n", $q->bstr());
#		printf("%s\n", $y_floor->bstr());
#		printf("\n");
		push @cf_sequence, $y_floor;

		if ($first) {
			$first = 0;
		} elsif ($p->is_one()) {
			last;
		}

		my $denominator = $p->copy()->bmul($p)->bmul($D)->bsub(
			$q->copy()->bsub($y_floor)->bpow(2)
		);

		$p->bdiv($denominator)->bnorm();
		$q->bneg()->badd($y_floor)->bdiv($denominator)->bnorm();
	}

	my $cf_count = scalar @cf_sequence;

	if (0 == $cf_count % 2) {
		my $cf_head = shift @cf_sequence;
		@cf_sequence = ($cf_head, @cf_sequence, @cf_sequence);
	}
	pop @cf_sequence;

#	printf("[%s] (%d)\n", (join ', ', (map { $_->bstr(); } @cf_sequence)),
#		$cf_count);

	my $convergent = pop @cf_sequence;
	while (@cf_sequence) {
		$convergent = Math::BigRat->new(1,1)->bdiv($convergent)
			->badd(pop @cf_sequence);
	}

	return $convergent;
}

my $max_numerator = Math::BigInt->bzero();
my $max_i = 0;

for (my $i = 2; $i <= 1000; $i++) {
	if (Math::BigInt->new($i)->bsqrt()->bpow(2)->bcmp($i) == 0) {
		next;
	}

	my $solution = solve_pell($i);
	my $numerator = $solution->numerator();
	if ($max_numerator->bcmp($numerator) < 0) {
		$max_i = $i;
		$max_numerator = $numerator;
	}

	printf("%5d: %s\n", $i, $solution->bstr());
}

printf("%s\n", $max_numerator);
printf("%d\n", $max_i);

