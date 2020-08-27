#!/usr/bin/env bash


declare docxFile=$1

set -u

: ${docxFile:?Call with a MS Word file name!}


runCmd () {
	local myCmd="$@"

	eval $myCmd
	local rc=$?
	[[ $rc -eq 0 ]] || {
		echo
		echo Cmd Failed: $myCmd
		echo Return Code: $rc
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
		echo
		echo $tmpDir does not exist
		echo
		return 1
	}

	[[ -r $tmpDir ]] || {
		echo
		echo $tmpDir not readable
		echo
		return 1
	}

	[[ -w $tmpDir ]] || {
		echo
		echo $tmpDir not writable
		echo
		return 1
	}

	[[ -x $tmpDir ]] || {
		echo
		echo $tmpDir cannot be traversed
		echo
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
	unzip -d $tmpDir $docxFile

	return $?
}

declare rc
declare xslFile=text-extract.xsl

checkFileAccess "$xslFile"
rc=$?
[[ $rc -ne 0 ]] && {
	echo
	echo Cannot read "$xslFile"
	echo
	exit 1
}

checkFileAccess "$docxFile"
rc=$?
[[ $rc -ne 0 ]] && {
	echo
	echo Cannot read "$docxFile"
	echo
	exit 1
}

extractText () {

	# this file must exist
	xsltproc $xslFile ${tmpDir}/word/document.xml
	[[ $rc -ne 0 ]] && { 
		echo
		echo extractText failed while processing: ${tmpDir}/word/document.xml
		echo
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

extractText | ./tokenize.pl

rc=$?
[[ $rc -ne 0 ]] && {
	echo
	echo failed while extracting text: $rc
	echo
	echo Temp Dir: $tmpDir
	exit 1
}

cleanup;
rc=$?
[[ $rc -ne 0 ]] && {
	echo
	echo failed during cleanup
	echo
	exit 1
}

echo 

