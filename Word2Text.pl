
use Win32::OLE qw(in with);
use Win32::OLE::Const;
use Win32::OLE::Const 'Microsoft Word';

use strict;
use warnings;

use Getopt::Long;

my $docDir='';
my $docFile='';

GetOptions (
	"dir=s" => \$docDir,
	"file=s" => \$docFile,
);

usage(1) unless ( $docDir and $docFile );

my $fqnDocFile=qq{${docDir}/${docFile}};

my $fqnTxtFile=$fqnDocFile;
$fqnTxtFile =~ s/.doc([x]){0,1}$/.txt/;

#print "FQN Text File: $fqnTxtFile\n";
#exit;

# Instantiate our very own MS Word process:

my $wordApp = Win32::OLE->new('Word.Application','Quit') or die "Oops!\n";
$wordApp->{Visible}= 1; # Set to 0 to hide
# Load "foo.doc" into our instance of MS Word. Terminate with error message if something goes awry:

$wordApp->Documents->Open($fqnDocFile)
	or die("Unable to open Word document: ", Win32::OLE->LastError());

# Save the file as a text file. Delete the destination text file first so we don't have to contend with an overwrite warning window in Word:
unlink $fqnTxtFile if (-e $fqnTxtFile);

$wordApp->ActiveDocument->SaveAs
({
	FileName => $fqnTxtFile,
	FileFormat => wdFormatDOSTextLineBreaks
});

# Close document, leave Word running to speed future conversions:

$wordApp->ActiveDocument->Close();

# When you are finished doing conversions, kill the word instance:

$wordApp->Quit;


sub usage {

	my $exitVal = shift;
	use File::Basename;
	my $basename = basename($0);
	print qq{

	$basename

	usage: $basename - format readable execution plans found in Oracle 10046 trace files

	$basename --file <filename> --dir <directory name>

	--file Word Document
	--dir  Full directory path (/ slashes are OK)

	examples here:

	$basename --file some-dba-resume.doc --d: 'C:/users/scott/Documents'
	};

	exit eval { defined($exitVal) ? $exitVal : 0 };

}
