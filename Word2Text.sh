#!/usr/bin/env bash


declare docxFile=$1

set -u

: ${docxFile:?Call with a MS Word file name!}


runCmd () {
	local myCmd="$@"

	eval $myCmd
	local rc=$?
	[[ $rc -eq 0 ]] || {
		echo >&2
		echo Cmd Failed: $myCmd >&2
		echo Return Code: $rc >&2
		return $rc
	}

	return 0

}

checkFileAccess () {
	local file2Chk="$@"

	[[ -r "$file2Chk" ]] || {
		return 1
	}

	return 0
}

cleanup () {

	[[ -d $tmpDir ]] || {
		echo >&2
		echo $tmpDir does not exist >&2
		echo >&2
		return 1
	}

	[[ -r $tmpDir ]] || {
		echo >&2
		echo $tmpDir not readable >&2
		echo >&2
		return 1
	}

	[[ -w $tmpDir ]] || {
		echo >&2
		echo $tmpDir not writable >&2
		echo >&2
		return 1
	}

	[[ -x $tmpDir ]] || {
		echo >&2
		echo $tmpDir cannot be traversed >&2
		echo >&2
		return 1
	}


	local rc=$(runCmd "rm -rf $tmpDir")

	return $rc

}

unzipDocx () {
	# we already know if the file can be opened
	# as long as the correct name is passed
	local docxFile="$@"

	# global var
	unzip -qq -d $tmpDir $docxFile

	return $?
}

declare rc
declare xslFile=text-extract.xsl

checkFileAccess "$xslFile"
rc=$?
[[ $rc -ne 0 ]] && {
	echo >&2
	echo Cannot read "$xslFile" >&2
	echo >&2
	exit 1
}

checkFileAccess "$docxFile"
rc=$?
[[ $rc -ne 0 ]] && {
	echo >&2
	echo Cannot read "$docxFile" >&2
	echo >&2
	exit 1
}

extractText () {

	# this file must exist
	xsltproc $xslFile ${tmpDir}/word/document.xml
	[[ $rc -ne 0 ]] && { 
		echo >&2
		echo extractText failed while processing: ${tmpDir}/word/document.xml >&2
		echo >&2
		return 1
	}

	# optional files
	for xmlFile in footnotes.xml endnotes.xml footer1.xml header1.xml
	do
		xsltproc $xslFile ${tmpDir}/word/${xmlFile} 2>/dev/null
	done

	return 0
}

declare tmpDir=$(mktemp -d)

unzipDocx "$docxFile"

# tokenize and print

#extractText | ./tokenize.pl
extractText 

rc=$?
[[ $rc -ne 0 ]] && {
	echo >&2
	echo failed while extracting text: $rc >&2
	echo >&2
	echo Temp Dir: $tmpDir >&2
	exit 1
}

cleanup;
rc=$?
[[ $rc -ne 0 ]] && {
	echo >&2
	echo failed during cleanup >&2
	echo >&2
	exit 1
}

echo 

