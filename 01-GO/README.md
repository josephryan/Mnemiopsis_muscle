# FILES

##### Compressed versions of ML2.2 GO CSV files (created w/Trinotate below)

mlgo.biological_process.csv.gz

mlgo.cellular_component.csv.gz

mlgo.molecular_function.csv.gz

# GO COMMANDS

### Trinotate

##### Download Trinotate sqlite database

```bash
wget ftp://ftp.broadinstitute.org/pub/users/bhaas/Trinotate_v2.0_RESOURCES/Trinotate.sprot_uniref90.20150131.boilerplate.sqlite.gz

gzip -d Trinotate.sprot_uniref90.20150131.boilerplate.sqlite.gz
```

##### Init database

```bash
/usr/local/Trinotate-v4.0.2/Trinotate --db Trinotate.sprot_uniref90.20150131.boilerplate.sqlite --init --gene_trans_map ML2.2.gene-to-trans-map --transcript_fasta ML2.2.transcripts.cdna.fa --transdecoder_pep ML2.2.proteins.fa
```

##### Load blast, signalp, and pfam analyses

```bash
/usr/local/Trinotate-v4.0.2/Trinotate --db 01-DATA/Trinotate.sprot_uniref90.20150131.boilerplate.sqlite --LOAD_swissprot_blastp ML2.2_v_swissprot
/usr/local/Trinotate-v4.0.2/Trinotate --db 01-DATA/Trinotate.sprot_uniref90.20150131.boilerplate.sqlite --LOAD_signalp signalp.out
/usr/local/Trinotate-v4.0.2/Trinotate --db 01-DATA/Trinotate.sprot_uniref90.20150131.boilerplate.sqlite --LOAD_pfam TrinotatePFAM.out
```

##### Generate reports

NOTE: Trinotate script was edited. All eggnog and infernal lines were commented out.

```bash
/usr/local/Trinotate-v4.0.2/Trinotate --db 01-DATA/Trinotate.sprot_uniref90.20150131.boilerplate.sqlite --report > Mgar.v1.trinotate.report.tsv

/usr/local/Trinotate-v4.0.2/Trinotate --db 01-DATA/Trinotate.sprot_uniref90.20150131.boilerplate.sqlite --run ALL --CPU 170 --trinotate_data_dir ../85-TRINOTATE/01-DATA --transcript_fasta Mgar.v1.codingseq --transdecoder_pep Mgar.v1.aa.formatted > tt3.out 2> tt3.err
```

###### create Mgar.v1.go.cellular_component.csv, Mgar.v1.go.biological_process.csv, and Mgar.v1.go.molecular_function.csv

```bash
perl trinotate2golists.pl
```

### GO ANALYSIS

```bash
perl mcgo.pl mlgo.biological_process.csv inall4.txt > muscle_bp_monte.all.csv

perl mcgo.pl mlgo.cellular_component.csv inall4.txt > muscle_cc_monte.all.csv

perl mcgo.pl mlgo.molecular_function.csv inall4.txt > muscle_mf_monte.all.csv
```

