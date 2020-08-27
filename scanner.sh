#!/usr/bin/env bash

# extract text from xml

set -u

declare fileCount
fileCount=$(ls -1 resumes/docx/*.docx 2>/dev/null | wc -l)

[[ $fileCount -lt 1 ]] && {
	echo >&2
	echo no docx files found >&2
	echo >&2
	exit 1
}

mkdir -p resumes/text
mkdir -p resumes/log

declare -a fileParts

for docxFile in resumes/docx/*.docx
do

	fileParts=()

	IFS=/
	for part in $docxFile
	do
		#echo $part
		fileParts[${#fileParts[@]}]=$part
	done
	unset IFS

	declare textFile='.'
	fileParts[1]=text
	fileParts[2]=$(echo ${fileParts[2]} | sed -e 's/docx$/txt/' )

	IFS=/
	for idx in ${!fileParts[@]}
	do
		textFile="${textFile}/${fileParts[$idx]}"
	done
	unset IFS

	echo Extracting text from $docxFile
	./Word2Text.sh $docxFile > $textFile
done

# now create the list of words with frequency

for resume in resumes/text/*.txt
do
	echo Working on: $resume

	fileParts=()

	IFS=/
	for part in $resume
	do
		#echo $part
		fileParts[${#fileParts[@]}]=$part
	done
	unset IFS

	declare logFile='.'
	fileParts[1]=log
	fileParts[2]=$(echo ${fileParts[2]} | sed -e 's/txt$/log/' )

	IFS=/
	for idx in ${!fileParts[@]}
	do
		logFile="${logFile}/${fileParts[$idx]}"
	done
	unset IFS

	./rscan.pl < $resume > $logFile

done


# now score the log files

echo
echo "### Scoring Resumes ###"
echo

for logFile in resumes/log/*.log
do
	echo -n  $(basename $logFile)":  "
	score=$(./score.pl $logFile)
	echo $score 
done | sed -e 's/\.log//' | sort -n -r -k3.1


