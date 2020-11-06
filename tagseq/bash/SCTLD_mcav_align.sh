#!/bin/bash
#BSUB -J mcav_align
#BSUB -q general
#BSUB -P transcriptomics
#BSUB -e /scratch/projects/transcriptomics/ben_young/SCTLD/host/error_output/mcav_h_align.e%J
#BSUB -o /scratch/projects/transcriptomics/ben_young/SCTLD/host/error_output/mcav_h_align.o%J

# making folder with only ofav trimmed in
mkdir mkdir /scratch/projects/transcriptomics/ben_young/SCTLD/host/trimmed/mcav
mv /scratch/projects/transcriptomics/ben_young/SCTLD/host/trimmed/Mcav_* /scratch/projects/transcriptomics/ben_young/SCTLD/host/trimmed/mcav/

# making a list of sample names
PALMATA=`ls /scratch/projects/transcriptomics/ben_young/SCTLD/host/trimmed/mcav | sed 's/\(.*\)_tr.fastq/\1/g'`

# the files being processed
echo "samples being aligned"
echo $PALMATA

for PALPAL in $PALMATA
do
mkdir /scratch/projects/transcriptomics/ben_young/SCTLD/host/mcav_align/${PALPAL}
echo "$PALPAL"
echo '#!/bin/bash' > /scratch/projects/transcriptomics/ben_young/SCTLD/host/loop_scripts/mcav_align/"$PALPAL"_h_align.sh
echo '#BSUB -J '"$PALPAL"'_h_align' >> /scratch/projects/transcriptomics/ben_young/SCTLD/host/loop_scripts/mcav_align/"$PALPAL"_h_align.sh
echo '#BSUB -e /scratch/projects/transcriptomics/ben_young/SCTLD/host/error_output/mcav_align/'"$PALPAL"'_he_align.txt' >> /scratch/projects/transcriptomics/ben_young/SCTLD/host/loop_scripts/mcav_align/"$PALPAL"_h_align.sh
echo '#BSUB -o /scratch/projects/transcriptomics/ben_young/SCTLD/host/error_output/mcav_align/'"$PALPAL"'_ho_align.txt' >> /scratch/projects/transcriptomics/ben_young/SCTLD/host/loop_scripts/mcav_align/"$PALPAL"_h_align.sh
echo '#BSUB -q bigmem'  >> /scratch/projects/transcriptomics/ben_young/SCTLD/host/loop_scripts/mcav_align/"$PALPAL"_h_align.sh
echo '#BSUB -n 20' >> /scratch/projects/transcriptomics/ben_young/SCTLD/host/loop_scripts/mcav_align/"$PALPAL"_h_align.sh
echo '#BSUB -R "rusage[mem=10000]"' >> /scratch/projects/transcriptomics/ben_young/SCTLD/host/loop_scripts/mcav_align/"$PALPAL"_h_align.sh

echo '/nethome/bdy8/programs/STAR \
--runThreadN 8 \
--genomeDir /nethome/bdy8/mcav_genome/Mcavernosa_annotation/ \
--readFilesIn /scratch/projects/transcriptomics/ben_young/SCTLD/host/trimmed/mcav/'"${PALPAL}"'_tr.fastq \
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
--outFilterScoreMinOverLread 0.2 \
--outFilterMatchNminOverLread 0.2 \
--twopass1readsN -1 \
--outReadsUnmapped Fastx \
--outFileNamePrefix /scratch/projects/transcriptomics/ben_young/SCTLD/host/mcav_align/'"$PALPAL"'/'"$PALPAL"'_' >> /scratch/projects/transcriptomics/ben_young/SCTLD/host/loop_scripts/mcav_align/"$PALPAL"_h_align.sh
bsub < /scratch/projects/transcriptomics/ben_young/SCTLD/host/loop_scripts/mcav_align/"$PALPAL"_h_align.sh
done

#--outFilterScoreMinOverLread 0.5 \
#--outFilterMatchNminOverLread 0.5 \
