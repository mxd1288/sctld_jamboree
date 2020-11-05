#!/bin/bash
#./bash/RNAseq_setup_start.sh
#purpose: create directory structure, copy program binaries and reference sequences into Pegasus scratch space
#To start this job from the sctld_jamboree/rnaseq directory, use:
#bsub -P transcriptomics < ./bash/RNAseq_setup_start.sh

#BSUB -J RNAseq_setup
#BSUB -q general
#BSUB -P transcriptomics
#BSUB -o setup%J.out
#BSUB -e setup%J.err
#BSUB -n 8
#BSUB -u mconnelly@rsmas.miami.edu
#BSUB -N

#specify variable containing sequence file prefixes and directory paths
prodir="/scratch/projects/transcriptomics/mikeconnelly/projects/sctld_jamboree/rnaseq"
samples="K1 K2 K6 K7 K8 K12 K13"
echo "Pipeline setup process started"

#copy program binaries, change permissions, and load necessary modules
#execute FASTQC and Trimmomatic using Pegasus modules
module load java/1.8.0_60
module load trimmomatic/0.36
#module load trinity
echo "Program files copied to scratch"

#Call first scripts in analysis pipeline
bsub -P transcriptomics < ${prodir}/bash/fastqc.sh
bsub -P transcriptomics < ${prodir}/bash/trim.sh
echo "RNAseq pipeline scripts successfully activated"
