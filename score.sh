#!/bin/bash

for resume in *-word-counts.log
do
	echo -n  "$resume:  "
	score=$(./score.pl $resume)
	echo $score 

done | sort -r -k3.1


