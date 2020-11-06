#!/bin/bash
#./bash/salmon_index_pstrigosa.sh
#purpose:
#To start this job from the sctld_jamboree/rnaseq directory, use:
#bsub -P transcriptomics < ./bash/salmon_index_pstrigosa.sh

#BSUB -J salmon_index_pstrigosa
#BSUB -q general
#BSUB -P transcriptomics
#BSUB -o salmon_index_pstrigosa%J.out
#BSUB -e salmon_index_pstrigosa%J.err
#BSUB -n 8
#BSUB -u mconnelly@rsmas.miami.edu
#BSUB -N

#specify variable containing sequence file prefixes and directory paths
mcs="/scratch/projects/transcriptomics/mikeconnelly"
prodir="/scratch/projects/transcriptomics/mikeconnelly/projects/sctld_jamboree/rnaseq"
samples="K1 K2 K6 K7 K8 K12 K13"

${mcs}/programs/salmon-latest_linux_x86_64/bin/salmon \
index -t ${prodir}/data/refs/Pstrigosa_assembly.fasta \
-i ${prodir}/data/refs/Pstrigosa_salmon_index
