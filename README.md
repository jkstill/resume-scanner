
# Resume Scanner

In short: 

* tokenize a resume
* remove stopwords
* get word frequency count 
* create a score based on words of interest

# Workflow

## convert to text

Previously this step required running a batch script on a Windows machine.

The script used a Perl script that ran MS Word to extract the data via Win32::OLE.

Today it occurred to me there is a mucn better solution.

All `.docx` files are really a zip file, full of XML documents.

```text

>  unzip -l M-Smith.docx
Archive:  M-Smith.docx
  Length      Date    Time    Name
---------  ---------- -----   ----
     2015  1980-01-01 00:00   [Content_Types].xml
      590  1980-01-01 00:00   _rels/.rels
     1471  1980-01-01 00:00   word/_rels/document.xml.rels
    40532  1980-01-01 00:00   word/document.xml
      289  1980-01-01 00:00   word/_rels/header1.xml.rels
      510  1980-01-01 00:00   word/_rels/footer1.xml.rels
     3394  1980-01-01 00:00   word/footer1.xml
     3724  1980-01-01 00:00   word/header1.xml
     1535  1980-01-01 00:00   word/endnotes.xml
     1541  1980-01-01 00:00   word/footnotes.xml
      154  1980-01-01 00:00   word/media/image1.png
     6992  1980-01-01 00:00   word/theme/theme1.xml
     2932  1980-01-01 00:00   word/settings.xml
    33425  1980-01-01 00:00   word/styles.xml
      446  1980-01-01 00:00   word/webSettings.xml
     7374  1980-01-01 00:00   word/numbering.xml
      726  1980-01-01 00:00   docProps/core.xml
     2050  1980-01-01 00:00   word/fontTable.xml
     1063  1980-01-01 00:00   docProps/app.xml
---------                     -------
   110763                     19 files

```

The files with the data of interesst are:

- word/document.xml
- word/footnotes.xml
- word/endnotes.xml
- word/footer1.xml
- word/header1.xml

By using the `xsltproc` tool, which is available on most Linux systems, the data can be easily extracted from `.docx` files.

### text-extract.xsl

The text-extract.xsl file is used to get just the text from the XML file.

This XSL file was found here: [How to convert xml file to text file](https://www.unix.com/shell-programming-and-scripting/147483-how-convert-xml-file-text-file.html)

```xml
 <xsl:stylesheet version="1.0"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

   <xsl:output method="text"/>

   <xsl:template match="catalog">
      <xsl:call-template name="header" />
      <xsl:apply-templates select="book" />
   </xsl:template>

   <xsl:template name="header">
      <xsl:for-each select="//book[1]/child::*" >
         <xsl:value-of select="name()" />
         <xsl:if test="following-sibling::*">|</xsl:if>
      </xsl:for-each>
      <xsl:text>
</xsl:text>
   </xsl:template>

   <xsl:template match="book">
      <xsl:for-each select="child::*" >
         <xsl:value-of select="." />
         <xsl:if test="following-sibling::*">|</xsl:if>
      </xsl:for-each>
      <xsl:text>
</xsl:text>
   </xsl:template>

</xsl:stylesheet>
```

### Extracting the Text

There are just a few steps:

- unzip the word file to a tmp directory
  - mkdir -p ./word/extract
  - unzip -d ./word/extract my-file.docx
- parse the text from the XML to a file
  - xsltproc text-extract.xsl ./word/extract/word/document.xml >> my-file.txt
- remove the tmp directory
  -rm -rf ./word/extract





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

  if word in keywords.words
    
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


