process recup_data {
    publishDir params.resultdir, mode: 'copy'
                                                                           
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

process trimmomatic {
    publishDir params.resultdir2, mode: 'copy'

    input:
    tuple val(SRAID), path("*_1.fastq.gz"), path("*_2.fastq.gz")

    output:
    tuple val(SRAID), path("*_1U.fastq.gz"), path("*_2U.fastq.gz")

    script:
    """
    
    trimmomatic PE path{"*_1.fastq.gz"} path{"*_2.fastq.gz"} -baseout ${SRAID}.fastq  LEADING:20 TRAILING:20 MINLEN:50
    
    """
}
workflow{
params.resultdir='result_fastq'
params.resultdir2='result_trimmo'
fastqinput = Channel.of("SRR628582","SRR628583","SRR628584","SRR628585","SRR628586","SRR628587") 
fastqoutput = recup_data(fastqinput)
trimmooutput = trimmomatic(fastqoutput) 
}
