#!/usr/bin/env nextflow
nextflow.enable.dsl=2

process Getinfo {
    output:
    file chr
    file annotation
    
    script:
    """
    wget ftp://ftp.ensembl.org/pub/release-101/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.chromosome.*.fa.gz
    gunzip -c *.fa.gz > chr
    wget ftp://ftp.ensembl.org/pub/release-101/gtf/homo_sapiens/Homo_sapiens.GRCh38.101.chr.gtf.gz
    gunzip -c *.gtf.gz > annotation
    
    """ 


} 

process Indexation { 

	input:
	file chr
	file annotation

	output:
	path 'ref/' //renvoie un unique repertoire contenant tous les fichiers de l'index de reference

	script: 
	""" 
	mkdir ref
	chmod +x ref
	STAR --runThreadN 2 --runMode genomeGenerate --genomeDir ref/ --genomeFastaFiles ${chr} --sjdbGTFfile ${annotation}
	
	"""
}

workflow {

    Getinfo | Indexation 
}
