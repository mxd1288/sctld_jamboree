#!/bin/bash
#./bash//Pstrigosa_annotate/pstrigosa_pfam_hmmscan.sh
#purpose: Search pfam database HMM models using HMMER
#To start this job from the sctld_jamboree/rnaseq directory, use:
#bsub -P transcriptomics < ./bash/Pstrigosa_annotate/pstrigosa_pfam_hmmscan.sh

#BSUB -J pstrigosa_pfam_hmmscan
#BSUB -q general
#BSUB -P pstrigosa_pfam_hmmscan%J.out
#BSUB -e pstrigosa_pfam_hmmscan%J.err
#BSUB -n 8
#BSUB -u mconnelly@rsmas.miami.edu
#BSUB -N

#specify variable containing sequence file prefixes and directory paths
mcs="/scratch/projects/transcriptomics/mikeconnelly"
prodir="/scratch/projects/transcriptomics/mikeconnelly/projects/sctld_jamboree/rnaseq"
samples="K1 K2 K6 K7 K8 K12 K13"

${mcs}/programs/hmmer-3.3.1/src/hmmscan \
--domtblout ${prodir}/data/refs/Pstrigosa_transdecoder/pfam.domtblout \
/nethome/m.connelly/sequences/Pfam-A.hmm \
${prodir}/data/refs/Pstrigosa_transdecoder/longest_orfs.pep \
--cpu 8 \
