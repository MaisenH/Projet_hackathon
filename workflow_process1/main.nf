process recup_data {
    publishDir params.resultdir, mode: 'copy'
                                                                           
    input:                                                                                                                  
    val SRAID                                                                                                                                                                                                                                       
    
    output:                                                                                                                 
    tuple val(SRAID), path("*_1.fastq.gz"), path("*_2.fastq.gz")                                                                                                                                                                                    

    script:                                  
    """
    wget https://sra-pub-run-odp.s3.amazonaws.com/sra/${SRAID}/${SRAID} -O ${SRAID}.sra
    fastq-dump-orig.3.0.0 --gzip --split-files ./${SRAID}.sra
    rm ${SRAID}.sra
                                                             
    """                                                                                                                 
}

workflow{

params.resultdir='result'

input = Channel.of("SRR628582","SRR628583","SRR628584","SRR628585","SRR628586","SRR628587") 
tupleoutput = recup_data(input)
}
