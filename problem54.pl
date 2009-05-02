#!/usr/bin/perl

use strict;

my %rankScores = (
	2 => 2,
	3 => 3,
	4 => 4,
	5 => 5,
	6 => 6,
	7 => 7,
	8 => 8,
	9 => 9,
	T => 10,
	J => 11,
	Q => 12,
	K => 13,
	A => 14,
);

my %suitScores = (
	C => 1,
	D => 3,
	H => 2,
	S => 4,
);

my @handStrings = (
	"5H 5C 6S 7S KD 2C 3S 8S 8D TD",
	"5D 8C 9S JS AC 2C 5C 7D 8S QH",
	"2D 9C AS AH AC 3D 6D 7D TD QD",
	"4D 6S 9H QH QC 3D 6D 7H QD QS",
	"2H 2D 4C 4D 4S 3C 3D 3S 9S 9D",
);

sub processHandString {
	my ($handString) = @_;
	chomp $handString;
	my @cardStrings = split / /, $handString;
	my $hands = [[], []];
	my $cardCount = 0;
	for my $cardString (@cardStrings) {
		my $card = {
			rank => $rankScores{substr $cardString, 0, 1},
			suit => $suitScores{substr $cardString, 1, 1},
		};
		if ($cardCount < 5) {
			push @{$hands->[0]}, $card;
		} else {
			push @{$hands->[1]}, $card;
		}
		$cardCount += 1;
	}
	return $hands;
}

my @rankStrings = qw/? ? 2 3 4 5 6 7 8 9 T J Q K A/;
my @suitStrings = qw/? C D H S/;

sub cardToString {
	my ($card) = @_;
	return sprintf "%s%s",
		$rankStrings[$card->{rank}],
		$suitStrings[$card->{suit}];
}

sub printHands {
	my ($hands) = @_;
	for (my $i = 0; $i < 2; $i++) {
		printf ("Player %d: %s\n", $i+1, (join ' ', 
			map { cardToString $_ }
				(reverse sort { $a->{rank} <=> $b->{rank} } @{$hands->[$i]})));
	}
}

my @handRankStrings = qw/?
	HighCard
	Pair
	TwoPair
	ThreeOfAKind
	Straight
	Flush
	FullHouse
	FourOfAKind
	StraightFlush
	RoyalFlush/;

sub rankHand {
	my ($hand) = @_;
	my @cards = @$hand;

	# Check for flush
	my $suit = 0;
	my $isFlush = 1;
	for my $card (@cards) {
		if ($suit != $card->{suit} && $suit != 0) {
			$suit = 0;
			$isFlush = 0;
			last;
		}
		$suit = $card->{suit}
	}

	# Count rank frequencies
	my @rankFrequencies = ();
	for (my $rank = 2; $rank <= 14; $rank++) {
		$rankFrequencies[$rank] = 0;
	}
	for my $card (@cards) {
		$rankFrequencies[$card->{rank}] += 1;
	}

	# Check for straight
	my $straightStart = 0;
	for (my $rank = 2; $rank <= 14; $rank++) {
		if ($rankFrequencies[$rank] > 1) {
			# Found (at least) a pair, so not a straight.
			$straightStart = 0;
			last;
		}
		if (0 == $rankFrequencies[$rank] && $straightStart) {
			# Found a gap, so not a straight.
			$straightStart = 0;
			last;
		}
		if (1 == $rankFrequencies[$rank] && !$straightStart) {
			# Found a singleton - could be the start of a straight.
			$straightStart = $rank;
		}
	}

	if (10 == $straightStart && $isFlush) {
		# Royal flush
		return [10];
	}
	if ($straightStart && $isFlush) {
		# Straight flush
		return [9, $straightStart];
	}

	# Find pairs, triples, etc.
	my $pair1Rank = 0;
	my $pair2Rank = 0;
	my $threeRank = 0;
	my $fourRank = 0;
	for (my $rank = 2; $rank <= 14; $rank++) {
		if ($rankFrequencies[$rank] == 2) {
			if ($pair1Rank) {
				if ($pair1Rank > $rank) {
					$pair2Rank = $rank;
				} else {
					($pair1Rank, $pair2Rank) = ($rank, $pair1Rank);
				}
			} else {
				$pair1Rank = $rank;
			}
		}
		if ($rankFrequencies[$rank] == 3) {
			$threeRank = $rank;
		}
		if ($rankFrequencies[$rank] == 4) {
			$fourRank = $rank;
		}
	}

	if ($fourRank) {
		# Four of a kind.
		# No need to compare on the rank of the singleton - 
		# cannot tie on 4-of-a-kind.
		return [8, $fourRank];
	}
	if ($threeRank && $pair1Rank) {
		# Full house.
		# No need to compare on the rank of the pair - 
		# cannot tie on 3-of-a-kind.
		return [7, $threeRank];
	}
	my @orderedCardRanks = reverse (sort { $a <=> $b }
		(map { $_->{rank} } @cards));
	if ($isFlush) {
		# Flush
		# Ties are broken by comparing highest cards in turn.
		return [6, @orderedCardRanks];
	}
	if ($straightStart) {
		# Straight
		return [5, $straightStart];
	}
	if ($threeRank) {
		# Three of a kind
		return [4, $threeRank, @orderedCardRanks];
	}
	if ($pair1Rank && $pair2Rank) {
		# Two pairs
		return [3, $pair1Rank, $pair2Rank, @orderedCardRanks];
	}
	if ($pair1Rank) {
		# One pair
		return [2, $pair1Rank, @orderedCardRanks];
	}

	# High card
	return [1, @orderedCardRanks];
}

my $player1Wins = 0;

for my $handString (<>) {
	my $hand = processHandString($handString);

	my $handRank1 = rankHand($hand->[0]);
	my $handRank2 = rankHand($hand->[1]);
	my $c = 0;
	for (my $i = 0; $i <= $#{$handRank1}; $i++) {
		$c = ($handRank1->[$i] <=> $handRank2->[$i]);
		last if ($c);
	}
	my $interesting = 0;
	$interesting = 1 if ($handRank1->[0] > 3);
	$interesting = 1 if ($handRank2->[0] > 3);
	$interesting = 1
		if ($handRank1->[0] == $handRank2->[0]
			&& $handRank1->[1] == $handRank2->[1]
			&& $handRank1->[0] > 1);

	printHands($hand) if $interesting;
	

	if ($c > 0) {
		printf "Player 1 wins: %s beat %s\n", 
			$handRankStrings[$handRank1->[0]],
			$handRankStrings[$handRank2->[0]]
				if $interesting;
		$player1Wins += 1;
	} elsif ($c < 0) {
		printf "Player 2 wins: %s beat %s\n", 
			$handRankStrings[$handRank2->[0]],
			$handRankStrings[$handRank1->[0]]
				if $interesting;
	} else {
		printf "Tie! %s equals %s\n",
			$handRankStrings[$handRank1->[0]],
			$handRankStrings[$handRank2->[0]]
				if $interesting;
	}

	printf "\n" if $interesting;
}

printf "%d\n", $player1Wins;
