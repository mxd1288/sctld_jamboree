#!/bin/bash
#./bash/trim.sh
#purpose: create directory structure, copy program binaries and reference sequences into Pegasus scratch space
#To start this job from the sctld_jamboree/rnaseq directory, use:
#bsub -P transcriptomics < ./bash/trim.sh

#BSUB -J trim_sctld
#BSUB -q general
#BSUB -P transcriptomics
#BSUB -o trim_sctld%J.out
#BSUB -e trim_sctld%J.err
#BSUB -n 8
#BSUB -u mconnelly@rsmas.miami.edu
#BSUB -N

#specify variable containing sequence file prefixes and directory paths
mcs="/scratch/projects/transcriptomics/mikeconnelly"
prodir="/scratch/projects/transcriptomics/mikeconnelly/projects/sctld_jamboree"
exp="1"
samples="K1 K2 K6 K7 K8 K12 K13"
