
# Resume Scanner

In short: 

* tokenize a resume
* remove stopwords
* get word frequency count 
* create a score based on words of interest

# Workflow

## convert to text

It is assumed the resume is in MS Word format.
If in text, then skip this step.

Copy the scripts Word2Text.cmd and Word2Text.pl to a Windows machine that has Perl installed.

Edit the Word2Text.cmd for path and file name as needed.

Then run Word2Text.cmd.

The output will be Resumes in text format.

```
X:\tmp\HR>Word2Text.cmd

X:\tmp\HR>perl Word2Text.pl --dir "X:/tmp/HR" --file Resume-1.doc
X:\tmp\HR>perl Word2Text.pl --dir "X:/tmp/HR" --file Resume-2.doc
X:\tmp\HR>perl Word2Text.pl --dir "X:/tmp/HR" --file Resume-3.docx
X:\tmp\HR>perl Word2Text.pl --dir "X:/tmp/HR" --file Resume-4.docx

```

## tokenize the resume

All following steps can be executed on Linux if you like, just copy the *.txt files from the previous step.

Now use rscan.sh to tokenize and create the *-word-counts.log files


```
>  ./rscan.sh
Working on: Resume-1.txt
  Outfile: Resume-1-word-counts.log
Working on: Resume-2.txt
  Outfile: Resume-2-word-counts.log
Working on: Resume-3.txt
  Outfile: Resume-3-word-counts.log
Working on: Resume-4.txt
  Outfile: Resume-4-word-counts.log
```

## score the resumes

Score are based on the values found for words in keywords.words.

Currently most words have a value of 1, while a few have a value of 2.

Though the frequency of words in resumes is known, the frequency is not currently being used to calculated the score.

For each word in a resume:

  if word in keywords.works
    
	 score = score + score_for_keyword


The score.sh script can be used.

```
>  ./score.sh | sed -e 's/-word-counts.log//'
Resume-1:  Score: 90
Resume-2:  Score: 77
Resume-3:  Score: 74
Resume-4:  Score: 70
```

# File extensions

## .doc .docx

MS Word Files

## .txt

MS Word Files saved as text

## .pl

Perl scripts

## .sh

Shell scripts (bash)

## .cmd

DOS Command file
( required for Word -> Text )

## .log

Word count files based on the text files (Resumes)

## .out

Other analysis files

## .words

Files containing words - such as the words we are interested in as found in a resume

# Files

## Word2Text.cmd
  Calls Word2Text per doc|docx file

## Word2Text.pl
  Converts doc|docx to text
  
  Must be run from Windows

## keywords.words
  List of keyword of interest - includes a score per word (1 or 2)

## rscan.pl
  Resume scanner - tokenizes words and produces list of words reverse sorted by frequency
  Works on stdin and stdout

  Removes words as found in a list of stopwords

## rscan.sh
  Driver for rscan.pl

## total-count.pl

 Gets a count of all words in all resumes in the current directory

 total-count.pl *.log  

## score.pl

  Create a score of resumes based on a set of scored words (keywords.words)

  This script is a filter working on stdin and stdout

## score.sh
  Driver for score.pl

  ./score.sh | sed -e 's/-word-counts.log//'


