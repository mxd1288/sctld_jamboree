#!/bin/bash
#./bash//Pstrigosa_annotate/pstrigosa_uniprot_blastp.sh
#purpose: BLAST search against the Uniprot protein database to annotate transcriptome in Transdecoder
#To start this job from the sctld_jamboree/rnaseq directory, use:
#bsub -P transcriptomics < ./bash/Pstrigosa_transdecoder/pstrigosa_uniprot_blastp.sh

#BSUB -J pstrigosa_uniprot_blastp
#BSUB -q general
#BSUB -P transcriptomics
#BSUB -o pstrigosa_uniprot_blastp%J.out
#BSUB -e pstrigosa_uniprot_blastp%J.err
#BSUB -n 8
#BSUB -u mconnelly@rsmas.miami.edu
#BSUB -N

#specify variable containing sequence file prefixes and directory paths
prodir="/scratch/projects/transcriptomics/mikeconnelly/projects/sctld_jamboree/rnaseq"
samples="K1 K2 K6 K7 K8 K12 K13"

module load blast/2.2.29+

blastp -query ${prodir}/data/refs/Pstrigosa_transdecoder/longest_orfs.pep \
-db /nethome/m.connelly/sequences/uniprot_sprot \
-max_target_seqs 1 \
-outfmt 6 \
-evalue 1e-5 \
-num_threads 10 > ${prodir}/data/refs/Pstrigosa_transdecoder/blastp.outfmt6
