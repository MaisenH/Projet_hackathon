process recup_data {
    publishDir params.resultdir, mode: 'copy'
                                                                           
    input:                                                                                                                  
    val SRAID                                                                                                                                                                                                                                       
    
    output:                                                                                                                 
    tuple val(SRAID), path("*_1.fastq.gz"), path("*_2.fastq.gz")                                                                                                                                                                                    

    script:                                  
    """
    mkdir result_fastq
    wget https://sra-pub-run-odp.s3.amazonaws.com/sra/${SRAID}/${SRAID} -O ${SRAID}.sra
    fastq-dump-orig.3.0.0 --gzip --split-files ${SRAID}.sra                                                             
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
    mkdir result_trimmo
    trimmomatic PE path{"*_1.fastq.gz"} path{"*_2.fastq.gz"} -baseout ${SRAID}.fastq  LEADING:20 TRAILING:20 MINLEN:50
    
    """
}
workflow{
params.resultdir='result_fastq'
params.resultdir2='result_trimmo'
fastqinput = Channel
    .fromPath('./Projet_hackathon/Fastq_file/identiants_transcriptome.txt')
    .splitText().map{it -> it.trim()}
fastqoutput = recup_data(fastqinput)
fastqoutput.view()
trimmoinput = fastqoutput
trimmooutput = trimmomatic(trimmoinput) 
}  
