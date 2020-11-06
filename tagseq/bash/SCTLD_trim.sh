#!/bin/bash
#BSUB -J SCTLD_trim
#BSUB -q general
#BSUB -P transcriptomics
#BSUB -e /scratch/projects/transcriptomics/ben_young/SCTLD/host/error_output/SCTLD_trim.e%J
#BSUB -o /scratch/projects/transcriptomics/ben_young/SCTLD/host/error_output/SCTLD_trim.o%J

# creating variables and what not
deproj='/scratch/projects/transcriptomics/ben_young/SCTLD/host'

# making a list of sample names
PALMATA=`ls /scratch/projects/transcriptomics/ben_young/SCTLD/raw_reads | cut -f 1 -d '.'`

# the files being processed
echo "samples being trimmed"
echo $PALMATA

# trimming the files
for PALPAL in $PALMATA
do
echo "$PALPAL"
echo '#!/bin/bash' > /scratch/projects/transcriptomics/ben_young/SCTLD/host/loop_scripts/trimming/"$PALPAL"_trimming.sh
echo '#BSUB -q general' >> /scratch/projects/transcriptomics/ben_young/SCTLD/host/loop_scripts/trimming/"$PALPAL"_trimming.sh
echo '#BSUB -J '"$PALPAL"'_trim' >> /scratch/projects/transcriptomics/ben_young/SCTLD/host/loop_scripts/trimming/"$PALPAL"_trimming.sh
echo '#BSUB -o /scratch/projects/transcriptomics/ben_young/SCTLD/host/error_output/trimming/'"$PALPAL"'_trim_o.txt' >> /scratch/projects/transcriptomics/ben_young/SCTLD/host/loop_scripts/trimming/"$PALPAL"_trimming.sh
echo '#BSUB -e /scratch/projects/transcriptomics/ben_young/SCTLD/host/error_output/trimming/'"$PALPAL"'_trim_e.txt' >> /scratch/projects/transcriptomics/ben_young/SCTLD/host/loop_scripts/trimming/"$PALPAL"_trimming.sh

echo 'module load java/1.8.0_60' >> /scratch/projects/transcriptomics/ben_young/SCTLD/host/loop_scripts/trimming/"$PALPAL"_trimming.sh
echo 'echo "This is the palmata sample being trimmed - '"${PALMATA}"'"' >> /scratch/projects/transcriptomics/ben_young/SCTLD/host/loop_scripts/trimming/"$PALPAL"_trimming.sh
echo 'bbduk.sh -Xmx512m \
in=/scratch/projects/transcriptomics/ben_young/SCTLD/raw_reads/'"${PALPAL}"'.fastq \
out=/scratch/projects/transcriptomics/ben_young/SCTLD/host/trimmed/'"${PALPAL}"'_tr.fastq \
ref=/nethome/bdy8/programs/bbmap/resources/polyA.fa.gz,/nethome/bdy8/programs/bbmap/resources/truseq_rna.fa.gz \
k=13 \
ktrim=r \
useshortkmers=T \
mink=5 \
qtrim=10 \
minlength=20' >> /scratch/projects/transcriptomics/ben_young/SCTLD/host/loop_scripts/trimming/"$PALPAL"_trimming.sh

bsub < /scratch/projects/transcriptomics/ben_young/SCTLD/host/loop_scripts/trimming/"$PALPAL"_trimming.sh
done
