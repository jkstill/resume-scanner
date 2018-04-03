#!/usr/bin/env perl

use warnings;
use strict;
use Data::Dumper;

my %wordCounts;

while (<>){
	chomp;
	my ($word,$count) = split(/\s+/);
	$wordCounts{$word} += $count
}

#print Dumper(\%wordCounts);

foreach my $word ( sort { $wordCounts{$b} <=> $wordCounts{$a} } keys %wordCounts ) {
	printf "%-25s  %i\n", $word, $wordCounts{$word};
}

