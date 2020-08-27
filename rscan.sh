#!/bin/bash

for resume in resumes/text/*.txt
do
	echo Working on: $resume
	baseName=$(echo $resume | cut -d. -f1)
	outFile="${baseName}-word-counts.log"
	echo "    Outfile: $outFile"

	./rscan.pl < $resume > $outFile
done

