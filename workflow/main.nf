process recup_data {
    publishDir params.resultdir1, mode: 'copy'
                                                                           
    input:                                                                                                                  
    val SRAID                                                                                                                                                                                                                                       
    
    output:                                                                                                                 
    tuple val(SRAID), path("*_1.fastq.gz"), path("*_2.fastq.gz")                                                                                                                                                                                    

    script:                                  
    """
    wget -O ${SRAID}.sra https://sra-pub-run-odp.s3.amazonaws.com/sra/${SRAID}/${SRAID}
    fastq-dump-orig.3.0.0 --gzip --split-files ${SRAID}.sra
    rm ${SRAID}.sra
                                                             
    """                                                                                                                 
}

nextflow.enable.dsl=2
process Getinfo {
    publishDir params.resultdir2, mode: 'copy'
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
    publishDir params.resultdir2, mode: 'copy'
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

workflow{
params.resultdir1='result_fastq'
fastqinput = Channel.of("SRR628582","SRR628583","SRR628584","SRR628585","SRR628586","SRR628587") 
fastqoutput=recup_data(fastqinput)
params.resultdir2='result'
Getinfo | Indexation
}
