#!/bin/bash
#./bash/sample_management.sh
#purpose: scripts and one-liners to organize and re-name raw read files for the RNAseq SCTLD jamboree
#To start this job from the sctld_jamboree/rnaseq directory, use:
#bsub -P transcriptomics < ./bash/sample_management.sh

#specify variable containing sequence file prefixes and directory paths
prodir="/scratch/projects/transcriptomics/mikeconnelly/projects/sctld_jamboree"
samples="K1 K2 K6 K7 K8 K12 K13"

# path to raw reads
cd ${prodir}/data/reads

# unzip reads
bzip2 -d -v -k *

# for loop that iterates through all the files stored in the directory, and then runs a sed command
# which removes the info at the beginning and maintains the important information for subsequent steps
for SAMPLE in *
do
FILE=`echo $SAMPLE | sed 's/nKnowles_RNASeq07212020_//g'`
echo ${FILE}
mv "${SAMPLE}" "${FILE}"
done

# for loop that iterates through all the files stored in the directory, and then runs a sed command
# which removes the info at the beginning and maintains the important information for subsequent steps
for SAMPLE in *
do
FILE=`echo $SAMPLE | sed 's/-nKnowlesRNASeq//g'`
echo ${FILE}
mv "${SAMPLE}" "${FILE}"
done

for SAMPLE in *
do
FILE=`echo $SAMPLE | sed 's/_S//g'`
echo ${FILE}
mv "${SAMPLE}" "${FILE}"
done

# rename reads to fastq
for SAMPLE in *
do
FILE=`echo $SAMPLE | sed 's/\.txt/\.fastq/g'`
echo ${FILE}
mv "${SAMPLE}" "${FILE}"
done

# rename reads
for SAMPLE in *
do
FILE=`echo $SAMPLE | sed 's/_1_/\_/g'`
echo ${FILE}
mv "${SAMPLE}" "${FILE}"
done

# gzipping
gzip *.fastq
