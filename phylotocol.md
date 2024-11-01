# MAPK Phylogeny Phylotocol
 
 Principal Investigator: Joseph Ryan  

 Version Number: v.0.01

 Date: 1 Nov 2024  

## SUMMARY OF CHANGES FROM PREVIOUS VERSION

NA

## 1 INTRODUCTION: BACKGROUND INFORMATION AND SCIENTIFIC RATIONALE  

### 1.1 _Background Information_  

Several genes with protein tyrosine and serine/threonine kinase (PF07714) 
domains were expressed in all 4 of our muscle cells. 

### 1.2 _Rationale_  

We are conducting a phylogenetic analysis to better identify the relationship 
of these genes human protein tyrosine and serine/threonine kinase genes.

## 2 STUDY DESIGN AND ENDPOINTS  

#### 2.1 DATASETS AND SOFTWARE

* hmm2aln.pl downloaded from https://github.com/josephryan/hmm2aln.pl
* ML2.2.aa protein set was downloaded from http://research.nhgri.nih.gov/mnemiopsis
* HumRef2024.fa was created in January of 2024 using https://github.com/josephryan/reduce_refseq
* Both of these files were put into a directory called "aa" where these analyses were conducted
* PFAM model downloaded from https://www.ebi.ac.uk/interpro/wwwapi//entry/pfam/PF07714?annotation=hmm

#### 2.2 COMMANDS

We are using hmm2aln.pl (v 2.0.0) with the PF07714 PFAM domain and the Mnemiopsis (ML2.2) 
and human RefSeq protein sets to (1) identify domains in this set and simultaneously
construct an alignment to the PFAM model.

```bash
hmm2aln.pl --fasta_dir=aa --threads=100 --hmm=PF07714.hmm --name=Pkinase_Tyr > Pkinase_Tyr.aln.fa 2> h2a.err
```

Run a maximum-likelihood tree

```
iqtree -T AUTO -s Pkinase_Tyr.aln.fa
```

## 3 WORK COMPLETED SO FAR WITH DATES  

1 Nov 2024 - I have generated the alignment and the the tree is running (while I'm writing the first version of this document)

## APPENDIX

Version&nbsp; &nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;Date&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Significant Revisions  
1.1  
1.2  
1.3  
1.4  
