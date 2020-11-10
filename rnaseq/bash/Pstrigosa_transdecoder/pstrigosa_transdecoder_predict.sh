#!/bin/bash
#./bash//Pstrigosa_annotate/pstrigosa_transdecoder_predict.sh
#purpose: Use Transdecoder to extract long ORFs (> 100aa) from a transcriptome
#To start this job from the sctld_jamboree/rnaseq directory, use:
#bsub -P transcriptomics < ./bash/Pstrigosa_transdecoder/pstrigosa_transdecoder_predict.sh

#BSUB -J pstrigosa_transdecoder_predict
#BSUB -q general
#BSUB -P transcriptomics
#BSUB -o pstrigosa_transdecoder_predict%J.out
#BSUB -e pstrigosa_transdecoder_predict%J.err
#BSUB -n 8
#BSUB -u mconnelly@rsmas.miami.edu
#BSUB -N

#specify variable containing sequence file prefixes and directory paths
mcs="/scratch/projects/transcriptomics/mikeconnelly"
prodir="/scratch/projects/transcriptomics/mikeconnelly/projects/sctld_jamboree/rnaseq"
samples="K1 K2 K6 K7 K8 K12 K13"

# incorporate blastp results, may also want to include hmmscan of Pfam database one day
${mcs}/programs/TransDecoder-TransDecoder-v5.5.0/TransDecoder.Predict \
-t ${prodir}/data/refs/Pstrigosa_assembly.fasta \
--retain_blastp_hits ${prodir}/data/refs/Pstrigosa_transdecoder/blastp.outfmt6 \
-O ${prodir}/data/refs/Pstrigosa_transdecoder

#--retain_pfam_hits ${prodir}/data/refs/Pstrigosa_transdecoder/pfam.domtblout \
