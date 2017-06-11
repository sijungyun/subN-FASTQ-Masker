# subN-FASTQ-Masker
subN: Masking software for preprocessing of FASTQ files based on PHRED quality score

<USAGE>
perl subN_v_0.1.0.pl -i <input_fastq> -o <output_fastq> -q 30

        Options:

                -help:  brief help message

                -i <input_fastq>: input fastq file

                -o <output_fastq>: output fastq file

                -q 30: cutoff PHRED quality score, default Q30, which corresponds to 0.001 error rate



        -q 30 => Q30 => 0.001 error rate

        -q 20 => Q20 => 0.01  error rate

        -q 10 => Q10 => 0.1   error rate

