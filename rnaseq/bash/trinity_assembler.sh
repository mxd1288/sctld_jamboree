#!/bin/bash
#./bash/trinity_assembler.sh
#purpose:
#To start this job from the sctld_jamboree/rnaseq directory, use:
#bsub -P transcriptomics < ./bash/trinity_assembler.sh

#BSUB -J trinity_assembler_cnat
#BSUB -q general
#BSUB -P transcriptomics
#BSUB -o trinity_assembler_cnat%J.out
#BSUB -e trinity_assembler_cnat%J.err
#BSUB -n 8
#BSUB -u mconnelly@rsmas.miami.edu
#BSUB -N

#specify variable containing sequence file prefixes and directory paths
mcs="/scratch/projects/transcriptomics/mikeconnelly"
prodir="/scratch/projects/transcriptomics/mikeconnelly/projects/sctld_jamboree"
exp="1"
samples="K1 K2 K6 K7 K8 K12 K13"

#
Trinity --seqType fq \
--left reads_1.fq \
--right reads_2.fq \
--SS_lib_type RF \
--CPU 6 \
--max_memory 20G
