
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


