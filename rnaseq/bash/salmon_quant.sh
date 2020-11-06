#!/bin/bash
#./bash/salmon_quant.sh
#purpose:
#To start this job from the sctld_jamboree/rnaseq directory, use:
#bsub -P transcriptomics < ./bash/salmon_quant.sh

#BSUB -J salmon_quant
#BSUB -q general
#BSUB -P transcriptomics
#BSUB -o salmon%J.out
#BSUB -e salmon%J.err
#BSUB -n 8
#BSUB -u mconnelly@rsmas.miami.edu
#BSUB -N

#specify variable containing sequence file prefixes and directory paths
prodir="/scratch/projects/transcriptomics/mikeconnelly/projects/sctld_jamboree/rnaseq"
samples="K1 K2 K6 K7 K8 K12 K13"
