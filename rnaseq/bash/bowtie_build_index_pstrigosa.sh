#!/bin/bash
#./bash/bowtie_build_index_pstrigosa.sh
#purpose:
#To start this job from the sctld_jamboree/rnaseq directory, use:
#bsub -P transcriptomics < ./bash/bowtie_build_index_pstrigosa.sh

#BSUB -J bowtie_build_pstrigosa
#BSUB -q general
#BSUB -P transcriptomics
#BSUB -o bowtie_build_pstrigosa%J.out
#BSUB -e bowtie_build_pstrigosa%J.err
#BSUB -n 8
#BSUB -u mconnelly@rsmas.miami.edu
#BSUB -N

#specify variable containing sequence file prefixes and directory paths
prodir="/scratch/projects/transcriptomics/mikeconnelly/projects/sctld_jamboree"
samples="K1 K2 K6 K7 K8 K12"
