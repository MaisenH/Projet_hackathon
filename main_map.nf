#!/usr/bin/env nextflow
nextflow.enable.dsl=2
process Recup_data {
    publishDir params.resultdir, mode: 'copy'
                                                                           
    input:                                                                                                                  
    val SRAID                                                                                                                                                                                                                                       
    
    output:                                                                                                                 
    tuple val(SRAID), path("*_1.fastq"), path("*_2.fastq")                                                                                                                                                                                   

    script:                                  
    """
    wget -O ${SRAID}.sra https://sra-pub-run-odp.s3.amazonaws.com/sra/${SRAID}/${SRAID}
    fastq-dump-orig.3.0.0 --split-files ${SRAID}.sra
    rm ${SRAID}.sra

                                                             
    """                                                                                                                 
}

process Getinfo {
    publishDir params.resultdir, mode: 'copy'
    output:
    path 'chr.fa'
    path 'annot.gtf'
    script:
    """
    wget ftp://ftp.ensembl.org/pub/release-101/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.chromosome.*.fa.gz
    gunzip -c *.fa.gz > chr.fa
    wget ftp://ftp.ensembl.org/pub/release-101/gtf/homo_sapiens/Homo_sapiens.GRCh38.101.chr.gtf.gz
    gunzip -c *.gtf.gz > annot.gtf
    rm *.gz 
    """ 


} 

process Indexation {
    publishDir params.resultdir, mode: 'copy'
	input:
	path 'chr.fa'
	path 'annot.gtf'

	output:
	path 'ref/' //renvoie un repertoire ref qui contient tous les fichiers de l'index de reference

	script: 
	"""
	mkdir ref
	chmod +x ref
	STAR --runThreadN 16 --runMode genomeGenerate --genomeDir ref/ --genomeFastaFiles chr.fa --sjdbGTFfile annot.gtf
	"""
}

process Mapping {
    publishDir params.resultdir, mode: 'copy'
    
    input:
    tuple val(SRAID), path("_1.fastq"), path("_2.fastq")
    path ref
    
    output:
    tuple val(SRAID), path("*.bam")

    script:
    """
    STAR --outSAMstrandField intronMotif --outFilterMismatchNmax 4 --outFilterMultimapNmax 10 --genomeDir ref/ --readFilesIn <(gunzip -c \$*_1.fastq) <(gunzip -c \$*_2.fastq) --runThreadN 16 --outSAMunmapped None --outSAMtype BAM SortedByCoordinate --outStd BAM_SortedByCoordinate --genomeLoad NoSharedMemory > ${SRAID}.bam
    """
}

workflow {
fastqinput = Channel.of("SRR628583")
params.resultdir='result_map'
fastqoutput = Recup_data(fastqinput) 
getinfooutput = Getinfo()
indexationoutput = Indexation(getinfooutput)
mappingoutput = Mapping(fastqoutput,indexationoutput)
}
