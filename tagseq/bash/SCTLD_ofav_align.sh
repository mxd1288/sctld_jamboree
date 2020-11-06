#!/bin/bash
#BSUB -J ofav_align
#BSUB -q general
#BSUB -P transcriptomics
#BSUB -e /scratch/projects/transcriptomics/ben_young/SCTLD/host/error_output/ofav_h_align.e%J
#BSUB -o /scratch/projects/transcriptomics/ben_young/SCTLD/host/error_output/ofav_h_align.o%J

# making folder with only ofav trimmed in
mkdir mkdir /scratch/projects/transcriptomics/ben_young/SCTLD/host/trimmed/ofav
mv /scratch/projects/transcriptomics/ben_young/SCTLD/host/trimmed/Ofav_* /scratch/projects/transcriptomics/ben_young/SCTLD/host/trimmed/ofav/

# making a list of sample names
PALMATA=`ls /scratch/projects/transcriptomics/ben_young/SCTLD/host/trimmed/ofav | sed 's/\(.*\)_tr.fastq/\1/g'`

# the files being processed
echo "samples being aligned"
echo $PALMATA

for PALPAL in $PALMATA
do
mkdir /scratch/projects/transcriptomics/ben_young/SCTLD/host/ofav_align/${PALPAL}
echo "$PALPAL"
echo '#!/bin/bash' > /scratch/projects/transcriptomics/ben_young/SCTLD/host/loop_scripts/ofav_align/"$PALPAL"_h_align.sh
echo '#BSUB -J '"$PALPAL"'_h_align' >> /scratch/projects/transcriptomics/ben_young/SCTLD/host/loop_scripts/ofav_align/"$PALPAL"_h_align.sh
echo '#BSUB -e /scratch/projects/transcriptomics/ben_young/SCTLD/host/error_output/ofav_align/'"$PALPAL"'_he_align.txt' >> /scratch/projects/transcriptomics/ben_young/SCTLD/host/loop_scripts/ofav_align/"$PALPAL"_h_align.sh
echo '#BSUB -o /scratch/projects/transcriptomics/ben_young/SCTLD/host/error_output/ofav_align/'"$PALPAL"'_ho_align.txt' >> /scratch/projects/transcriptomics/ben_young/SCTLD/host/loop_scripts/ofav_align/"$PALPAL"_h_align.sh
echo '#BSUB -q bigmem'  >> /scratch/projects/transcriptomics/ben_young/SCTLD/host/loop_scripts/ofav_align/"$PALPAL"_h_align.sh
echo '#BSUB -n 20' >> /scratch/projects/transcriptomics/ben_young/SCTLD/host/loop_scripts/ofav_align/"$PALPAL"_h_align.sh
echo '#BSUB -R "rusage[mem=10000]"' >> /scratch/projects/transcriptomics/ben_young/SCTLD/host/loop_scripts/ofav_align/"$PALPAL"_h_align.sh

echo '/nethome/bdy8/programs/STAR \
--runThreadN 8 \
--genomeDir /nethome/bdy8/ofav_genome/ \
--readFilesIn /scratch/projects/transcriptomics/ben_young/SCTLD/host/trimmed/ofav/'"${PALPAL}"'_tr.fastq \
--outFilterType BySJout \
--outFilterMultimapNmax 20 \
--outFilterMismatchNoverLmax 0.1 \
--alignIntronMin 20 \
--alignIntronMax 1000000 \
--alignMatesGapMax 1000000 \
--outSAMtype BAM SortedByCoordinate \
--quantMode TranscriptomeSAM GeneCounts \
--outSAMstrandField intronMotif \
--twopassMode Basic \
--twopass1readsN -1 \
--outFilterScoreMinOverLread 0.2 \
--outFilterMatchNminOverLread 0.2 \
--outReadsUnmapped Fastx \
--outFileNamePrefix /scratch/projects/transcriptomics/ben_young/SCTLD/host/ofav_align/'"$PALPAL"'/'"$PALPAL"'_' >> /scratch/projects/transcriptomics/ben_young/SCTLD/host/loop_scripts/ofav_align/"$PALPAL"_h_align.sh
bsub < /scratch/projects/transcriptomics/ben_young/SCTLD/host/loop_scripts/ofav_align/"$PALPAL"_h_align.sh
done

#--outFilterScoreMinOverLread 0.5 \
#--outFilterMatchNminOverLread 0.5 \
