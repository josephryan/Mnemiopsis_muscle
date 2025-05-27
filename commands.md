# COMMANDS

### Align and estimate abundance of muscle cell transcripts

```bash
/usr/local/trinityrnaseq-Trinity-v2.8.5/util/align_and_estimate_abundance.pl --transcripts ML2.2.nt --seqType fq --left mc1-MnemiopsisCell1-A_1.fq.gz --right mc1-MnemiopsisCell1-A_2.fq.gz --output_dir aea --est_method RSEM --aln_method bowtie2 --thread_count 100 --prep_reference 
```

### GO ANALYSIS

```bash
perl mcgo.pl mlgo.biological_process.csv inall4.txt > muscle_bp_monte.all.csv

perl mcgo.pl mlgo.cellular_component.csv inall4.txt > muscle_cc_monte.all.csv

perl mcgo.pl mlgo.molecular_function.csv inall4.txt > muscle_mf_monte.all.csv
```

