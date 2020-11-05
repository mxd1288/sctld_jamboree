#!/bin/bash
#./bash/trinity_assembler.sh
#purpose:
#To start this job from the sctld_jamboree/rnaseq directory, use:
#bsub -P transcriptomics < ./bash/trinity_assembler.sh

#BSUB -J trinity_assembler_cnat
#BSUB -q bigmem
#BSUB -P transcriptomics
#BSUB -o trinity_assembler_cnat%J.out
#BSUB -e trinity_assembler_cnat%J.err
#BSUB -n 8
#BSUB -u mconnelly@rsmas.miami.edu
#BSUB -N

#specify variable containing sequence file prefixes and directory paths
prodir="/scratch/projects/transcriptomics/mikeconnelly/projects/sctld_jamboree/rnaseq"
samples="K1 K2 K6 K7 K8 K12"

module load trinityrnaseq/r20140717
#
Trinity --seqType fq \
--left ${prodir}/outputs/trimmomaticreads/K1_2_trimmed_paired.fastq.gz ${prodir}/outputs/trimmomaticreads/K2_2_trimmed_paired.fastq.gz  \
--right ${prodir}/outputs/trimmomaticreads/K1_1_trimmed_paired.fastq.gz ${prodir}/outputs/trimmomaticreads/K2_2_trimmed_paired.fastq.gz \
--SS_lib_type RF \
--CPU 6 \
--normalize_reads \
--JM 100G \
--output ${prodir}/outputs/trinity_assembly_out
