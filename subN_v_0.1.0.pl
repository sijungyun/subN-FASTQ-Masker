#PROGRAM: 
#subN = SUBstitute as N for the bases whose quality score is less than the quality cutoff 
#USAGE EXAMPLE:>perl subN_v_0.1.0.pl -i input.fastq -o input_masked.fastq -q 30

#!/usr/bin/perl -w

use strict;
use Getopt::Long qw(GetOptions);
use Pod::Usage qw(pod2usage);
use IO::File;

###################################################################################
#GETTING OPTIONS OR DISPLAY HELP MESSAGE
###################################################################################

my $qcutoff = 30; #CUTOFF PHRED QUALITY SCORE. THE BASE WHOSE QULITY IS BELOW THE CUTOFF WILL BE WILL BE SUBSTITUTED AS N.  THE BASE WHOSE QUALITY SCORE IS THE CUTOFF VALUE WILL NOT BE MASKED. 
#qcutoff 30 = Q30 = 0.001 error rate
#qcutoff 20 = Q20 = 0.01  error rate
#qcutoff 10 = Q10 = 0.1   error rate

my $help = 0;
my $man = 0;
my $input_file;
my $output_file;

GetOptions('h|help|?' => \$help, 'm|man' => \$man, 'q|qcutoff=f' => \$qcutoff, 'i|in=s' => \$input_file, 'o|out=s' => \$output_file) or pod2usage(2);
pod2usage(1) if ($help);
pod2usage(-verbose => 2) if ($man);
#pod2usage("$0: No files given.") if ((@ARGV == 0) && (-t STDIN));

$qcutoff += 33;  #Convert the qcutoff to FASTQ Sanger

# CHECK FOR REQUESTED INPUT FILE
unless (defined($input_file))
{
	pod2usage( -exitstatus => 2);
}

if (!defined($output_file))
{
	$output_file = Getting_Output_File_Name($input_file);
}


###################################################################################
#READ THE INPUT FILE BY FOUR LINES
###################################################################################

open(IN, '<', $input_file) or die $!;
open(OUT, '>', $output_file) or die $!;


while (<IN>)
{
	chomp(my $line1 = $_);
	chomp(my $line2 = <IN>);
	chomp(my $line3 = <IN>);
	chomp(my $line4 = <IN>);

	$line1 =~ s/\s+//;
	$line2 =~ s/\s+//;
	$line3 =~ s/\s+//;
	$line4 =~ s/\s+//;

	my $sequence = $line2;
	my $qvalue = $line4;

	my @sequence_array = split('', $sequence); #CONVERT SEQUENCE TO AN ARRAY WITH
	my @qvalue_array = unpack("C*", $qvalue); #CONVERT QVALUE TO AN ARRAY WITH ASCII VALUE

	my $i = 0;
	foreach my $each_qvalue (@qvalue_array)
	{
		if ($each_qvalue < $qcutoff)
		{
			$sequence_array[$i] = 'N';
		}
		$i++;
	}
	my $new_sequence = join('', @sequence_array);

	print OUT "$line1", "\n";
	print OUT "$new_sequence", "\n"; 
	print OUT "$line3", "\n";
	print OUT "$qvalue", "\n";
}

close IN;
close OUT;


###################################################################################
###################################################################################
#FUNCTIONS
###################################################################################
###################################################################################



sub Getting_Output_File_Name
{
    my $input_file = shift;
    my $output_file_front = substr($input_file, 0, -6);
    my $output_file_end = "_masked.fastq";
    my $output_file = sprintf "%s%s", $output_file_front, $output_file_end;
    return $output_file;
}

__END__

=head1 NAME

subN - Masking software for preprocessing of FASTQ files based on PHRED quality score

=head1 SYNOPSIS

	perl subN_v_0.1.0.pl -i <input_fastq> -o <output_fastq> -q 30

	Options:

		-help:  brief help message

		-i <input_fastq>: input fastq file

		-o <output_fastq>: output fastq file

		-q 30: cutoff PHRED quality score, default Q30, which corresponds to 0.001 error rate

	

	-q 30 => Q30 => 0.001 error rate

	-q 20 => Q20 => 0.01  error rate

	-q 10 => Q10 => 0.1   error rate

=back

=head1 DESCRIPTION

subN - Masking software for preprocessing of FASTQ files based on PHRED quality score

=head1 AUTHOR

B<Sijung Yun>

=cut
