#!/usr/bin/perl

# quick and dirty tokenizer

while (<>) {
	chomp;
	s/,//g;
	my @a=split(/\s+/);
	print join("\n",@a),"\n";
}
