#!/bin/bash
#./bash/sample_management.sh
#purpose: scripts and one-liners to organize and re-name raw read files for the RNAseq SCTLD jamboree
#To start this job from the sctld_jamboree/rnaseq directory, use:
#bsub -P transcriptomics < ./bash/sample_management.sh

#specify variable containing sequence file prefixes and directory paths
mcs="/scratch/projects/transcriptomics/mikeconnelly"
prodir="/scratch/projects/transcriptomics/mikeconnelly/projects/sctld_jamboree"
exp="1"
samples="K1 K2 K6 K7 K8 K12 K13"

# path to raw reads

# making variable with all the raw reads in the file we have cd to
SAMPLES=`ls|echo`

# for loop that iterates through all the files stored in the SAMPLE variable, and then runs a sed command
# which removes the info at the beginning and maintains the important information for subsequent steps
for SAMPLES in *
do
FILES=`echo $SAMPLES | sed 's/nKnowles_RNASeq07212020_\([0-9r]*-01_S_._.\.txt\.bz2\)/\1/'`
echo ${FILES}
mv "${SAMPLES}" "${FILES}"
done

# unzip reads

# rename reads
