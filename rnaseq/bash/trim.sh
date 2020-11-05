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
prodir="/scratch/projects/transcriptomics/mikeconnelly/projects/sctld_jamboree/rnaseq"
samples="K1 K2 K6 K7 K8 K12"

module load trimmomatic/0.36

#lets me know which files are being processed
echo "These are the samples to be processed:"
echo $samples

#loop to automate generation of scripts to direct sequence file trimming
for sample in $samples
do \
echo "$sample"

#   input BSUB commands
echo '#!/bin/bash' > "${prodir}"/bash/jobs/"${sample}"_trimmomatic.job
echo '#BSUB -q general' >> "${prodir}"/bash/jobs/"${sample}"_trimmomatic.job
echo '#BSUB -J '"${sample}"_trimmomatic'' >> "${prodir}"/bash/jobs/"${sample}"_trimmomatic.job
echo '#BSUB -o '"${prodir}"/outputs/logfiles/"$sample"trim%J.out'' >> "${prodir}"/bash/jobs/"${sample}"_trimmomatic.job
echo '#BSUB -e '"${prodir}"/outputs/errorfiles/"$sample"trim%J.err'' >> "${prodir}"/bash/jobs/"${sample}"_trimmomatic.job

#   input command to load modules for trimming
echo 'module load java/1.8.0_60' >> "${prodir}"/bash/jobs/"${sample}"_trimmomatic.job
echo 'module load trimmomatic/0.36' >> "${prodir}"/bash/jobs/"${sample}"_trimmomatic.job

#   input command to unzip raw reads before trimming
echo 'echo 'Unzipping "${sample}"'' >> "${prodir}"/bash/jobs/"${sample}"_trimmomatic.job
echo 'gunzip '"${prodir}"/data/reads/"${sample}"_1.fastq.gz >> "${prodir}"/bash/jobs/"${sample}"_trimmomatic.job
echo 'gunzip '"${prodir}"/data/reads/"${sample}"_2.fastq.gz >> "${prodir}"/bash/jobs/"${sample}"_trimmomatic.job

#   input command to trim raw reads
echo 'echo 'Trimming "${sample}"'' >> "${prodir}"/bash/jobs/"${sample}"_trimmomatic.job
echo '/share/opt/java/jdk1.8.0_60/bin/java -jar /share/apps/trimmomatic/0.36/trimmomatic-0.36.jar \
PE \
-phred33 \
-trimlog '"${prodir}"/outputs/logfiles/"${sample}"_trim.log \
"${prodir}"/data/reads/"${sample}"_1.fastq \
"${prodir}"/data/reads/"${sample}"_2.fastq \
"${prodir}"/outputs/trimmomaticreads/"${sample}"_1_trimmed_paired.fastq.gz \
"${prodir}"/outputs/trimmomaticreads/"${sample}"_1_trimmed_unpaired.fastq.gz \
"${prodir}"/outputs/trimmomaticreads/"${sample}"_2_trimmed_paired.fastq.gz \
"${prodir}"/outputs/trimmomaticreads/"${sample}"_2_trimmed_unpaired.fastq.gz \
ILLUMINACLIP:"${prodir}"/data/adapters/TruSeq3-PE-2.fa:2:30:10:2:keepBothReads \
LEADING:3 \
TRAILING:3 \
SLIDINGWINDOW:4:15 \
MINLEN:36 >> "${prodir}"/bash/jobs/"${sample}"_trimmomatic.job
echo 'echo '"$sample" trimmed''  >> "${prodir}"/bash/jobs/"${sample}"_trimmomatic.job

#   input command to zip raw reads after trimming
echo 'gzip '"${prodir}"/data/reads/"${sample}"_1.fastq  >> "${prodir}"/bash/jobs/"${sample}"_trimmomatic.job
echo 'gzip '"${prodir}"/data/reads/"${sample}"_2.fastq  >> "${prodir}"/bash/jobs/"${sample}"_trimmomatic.job

#   submit generated trimming script to job queue
bsub < "${prodir}"/bash/jobs/"${sample}"_trimmomatic.job
done
