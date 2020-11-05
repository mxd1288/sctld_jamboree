#!/bin/bash
#./bash/trinity_assembler_K7_test.sh
#purpose:
#To start this job from the sctld_jamboree/rnaseq directory, use:
#bsub -P transcriptomics < ./bash/trinity_assembler_K7_test.sh

#BSUB -J trinity_assembler_cnatK7
#BSUB -q bigmem
#BSUB -P transcriptomics
#BSUB -o trinity_assembler_cnatK7%J.out
#BSUB -e trinity_assembler_cnatK7%J.err
#BSUB -n 8
#BSUB -u mconnelly@rsmas.miami.edu
#BSUB -N

#specify variable containing sequence file prefixes and directory paths
mcs="/scratch/projects/transcriptomics/mikeconnelly"
prodir="/scratch/projects/transcriptomics/mikeconnelly/projects/sctld_jamboree/rnaseq"
exp="1"
samples="K1 K2 K6 K7 K8 K12"

module load trinityrnaseq/r20140717
#
Trinity --seqType fq \
--left ${prodir}/data/reads/K7_1.fastq  --right ${prodir}/data/reads/K7_2.fastq \
--SS_lib_type RF \
--CPU 6 \
--JM 20G \
--output ${prodir}/outputs/trinity_assembly_out_K7
