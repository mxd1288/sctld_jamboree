#!/bin/bash
#BSUB -J STAR_index_ofav
#BSUB -q bigmem
#BSUB -P transcriptomics
#BSUB -n 8
#BSUB -R "rusage[mem=4000]"
#BSUB -e /scratch/projects/transcriptomics/ben_young/SCTLD/host/error_output/STARofavindex.e%J
#BSUB -o /scratch/projects/transcriptomics/ben_young/SCTLD/host/error_output/STARofavindex.o%J

########### MAKE SURE TO GET RID OF tRNA FROM THE GFF FILE
## removing the tRNA lines from the gff3 file
awk '$3 != "tRNA" {print $0}' < \
/nethome/bdy8/ofav_genome/GCF_002042975.1_ofav_dov_v1_genomic.gff > \
/nethome/bdy8/ofav_genome/GCF_002042975.1_ofav_dov_v1_notrna_genomic.gff

/nethome/bdy8/programs/STAR \
--runThreadN 8 \
--runMode genomeGenerate \
--genomeDir /nethome/bdy8/ofav_genome/ \
--genomeFastaFiles /nethome/bdy8/ofav_genome/GCF_002042975.1_ofav_dov_v1_genomic.fna \
--sjdbGTFfile /nethome/bdy8/ofav_genome/GCF_002042975.1_ofav_dov_v1_notrna_genomic.gff \
--sjdbOverhang 100 \
--sjdbGTFtagExonParentTranscript Parent
