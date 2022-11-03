#!/usr/bin/env nextflow
nextflow.enable.dsl=2


process Getinfo {
    output:
    path "chr.fa"
    path "annotation.gtf"

    script:
    """
    wget ftp://ftp.ensembl.org/pub/release-101/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.chromosome.*.fa.gz
    gunzip -c *.fa.gz > chr.fa
    wget ftp://ftp.ensembl.org/pub/release-101/gtf/homo_sapiens/Homo_sapiens.GRCh38.101.chr.gtf.gz
    gunzip -c Homo_sapiens.GRCh38.101.chr.gtf.gz > annotation.gtf
    rm *.gz*
    """
 

process Indexation { 

	input:
	path "*.fastq.gz"
	path "chr.fa"
    	path "annotation.gtf"

	output:
	path "*bam"

	script: 
	""" 
	gunzip -c *.fastq.gz
	
	STAR --runThreadN 2 --outFilterMultimapNmax 1\
	--genomeDir . \
	--outSAMattributes All --outSAMtype BAM SortedByCoordinate \
	--outFileNamePrefix bam \
	--readFilesIn *R1.fastq *R2.fastq
	
			
	"""
}

workflow {

    Getinfo | Indexation 
}
