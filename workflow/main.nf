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
    path '*.bam'

    script:
    """
    STAR --outSAMstrandField intronMotif --outFilterMismatchNmax 4 --outFilterMultimapNmax 10 --genomeDir ref/ --readFilesIn \$*_1.fastq \$*_2.fastq --runThreadN 16 --outSAMunmapped None --outSAMtype BAM SortedByCoordinate --outStd BAM_SortedByCoordinate --genomeLoad NoSharedMemory > ${SRAID}.bam
    """
}

process Samtools {
    publishDir params.resultdir, mode: 'copy'

    input:
    file bam
    output:
    path '*.bai'
    script:
    """
    samtools index ${bam}
    """
}

process Featurecount {
    publishDir params.resultdir, mode: 'copy'
    
    input:
    file bam
    path 'chr.fa'
    path 'annot.gtf'
    output:
    path 'output.countsT1'

    script:
    """
    featureCounts -T 16 -F GTF -t gene -s 0 -a annot.gtf -p -o output.countsT1 ${bam}
    """
}

process AnalyseStat {
    
    publishDir params.resultdir, mode: 'copy'
    
    input:
    path 'output.countsT1'

    
    output:
    path '*.pdf'
    file 'Gene_DE.Rda'
    script:
    """
    Rscript ./ScriptR1.R
    """
}

process AnalyseStat2 {
    
    publishDir params.resultdir, mode: 'copy'
    
    input:
    path '*.pdf'
    file 'Gene_DE.Rda'
    
    output:
    
    file 'list_Gene_DE.Rda'

    script:
    """
    Rscript ./ScriptR2.R
    """
}

workflow {
fastqinput = Channel.of("SRR628582","SRR628583","SRR628584","SRR628585","SRR628586","SRR628587","SRR628588","SRR628589")
params.resultdir='result-T'
fastqoutput = Recup_data(fastqinput)
getinfooutput = Getinfo()
indexationoutput = Indexation(getinfooutput)
mappingoutput = Mapping(fastqoutput,indexationoutput)
samtoolsoutput = Samtools(mappingoutput)
gffoutput = Getgff()
featurecountsinput = mappingoutput.collect()
featurecoutput = Featurecount(featurecountsinput,getinfooutput)
analysestatouput = AnalyseStat(featurecoutput)
analysesat2output = AnalyseStat2(analysestatouput)
}
