#!/bin/bash
#./bash//Pstrigosa_annotate/pstrigosa_transdecoder_longorfs.sh
#purpose: Use Transdecoder to extract long ORFs (> 100aa) from a transcriptome
#To start this job from the sctld_jamboree/rnaseq directory, use:
#bsub -P transcriptomics < ./bash/Pstrigosa_transdecoder/pstrigosa_transdecoder_longorfs.sh

#BSUB -J pstrigosa_transdecoder_longorfs
#BSUB -q general
#BSUB -P transcriptomics
#BSUB -o pstrigosa_transdecoder_longorfs%J.out
#BSUB -e pstrigosa_transdecoder_longorfs%J.err
#BSUB -n 8
#BSUB -u mconnelly@rsmas.miami.edu
#BSUB -N

#specify variable containing sequence file prefixes and directory paths
mcs="/scratch/projects/transcriptomics/mikeconnelly"
prodir="/scratch/projects/transcriptomics/mikeconnelly/projects/sctld_jamboree/rnaseq"
samples="K1 K2 K6 K7 K8 K12 K13"

${mcs}/programs/TransDecoder-TransDecoder-v5.5.0/TransDecoder.LongOrfs \
-t ${prodir}/data/refs/Pstrigosa_assembly.fasta \
-O ${prodir}/data/refs/Pstrigosa_transdecoder
