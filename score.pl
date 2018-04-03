#!/usr/bin/env perl


use Data::Dumper;
use warnings;
use strict;

my $wordFile='keywords.words';
my $fh;

open $fh, '<', $wordFile or die "cannot open $wordFile - $!\n";

my %keyWordScores=();

while (my $line = <$fh> ) {
	chomp $line;
	my ($word, $score) = split(/\s+/,$line);
	$keyWordScores{$word} = $score;
}


my %wordList=();

my $score=0;

while (<>) {
	chomp;
	my ($word, $count) = split(/\s+/);

	if ( $keyWordScores{$word} ) {
		# kudos for word frequency
		#$score += ${count} * $keyWordScores{$word};

		# or just score by appearance of the word
		$score += $keyWordScores{$word};
	}
}

print "Score: $score\n";

