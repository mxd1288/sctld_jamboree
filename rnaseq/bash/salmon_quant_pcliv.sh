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
mcs="/scratch/projects/transcriptomics/mikeconnelly"
prodir="/scratch/projects/transcriptomics/mikeconnelly/projects/sctld_jamboree/rnaseq"
samples="K19 K21 K28 K28 K29 K31 K32 K34 K36"

for samp in $samples;
do
echo "Processing sample ${samp}"
${mcs}/programs/salmon-latest_linux_x86_64/bin/salmon \
          quant -i ${prodir}/data/refs/Pstrigosa_salmon_index\
         -l A \
         -1 ${prodir}/outputs/trimmomaticreads/${samp}_1_trimmed_paired.fastq.gz \
         -2 ${prodir}/outputs/trimmomaticreads/${samp}_2_trimmed_paired.fastq.gz \
         -p 8 --validateMappings -o ${prodir}/outputs/salmon_quants/${samp}_quant
done
