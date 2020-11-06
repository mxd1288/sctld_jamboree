#!/bin/bash
#BSUB -J STAR_index_mcav
#BSUB -q bigmem
#BSUB -P transcriptomics
#BSUB -n 8
#BSUB -R "rusage[mem=4000]"
#BSUB -e /scratch/projects/transcriptomics/ben_young/SCTLD/host/error_output/STARmcavindex.e%J
#BSUB -o /scratch/projects/transcriptomics/ben_young/SCTLD/host/error_output/STARmcavindex.o%J

########### MAKE SURE TO GET RID OF tRNA FROM THE GFF FILE
## removing the tRNA lines from the gff3 file
awk '$3 != "tRNA" {print $0}' < \
/nethome/bdy8/mcav_genome/Mcavernosa_annotation/Mcavernosa.maker.coding.gff3 > \
/nethome/bdy8/mcav_genome/Mcavernosa_annotation/Mcavernosa.maker.coding.notrna.gff3

/nethome/bdy8/programs/STAR \
--runThreadN 8 \
--runMode genomeGenerate \
--genomeDir /nethome/bdy8/mcav_genome/Mcavernosa_annotation/ \
--genomeFastaFiles /nethome/bdy8/mcav_genome/Mcavernosa_July2018.fasta \
--sjdbGTFfile /nethome/bdy8/mcav_genome/Mcavernosa_annotation/Mcavernosa.maker.coding.notrna.gff3 \
--sjdbOverhang 100 \
--sjdbGTFtagExonParentTranscript Parent
