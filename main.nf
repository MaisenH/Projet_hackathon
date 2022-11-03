process recup_data {
                                                                                                        
    input:                                                                                                                  
    val SRAID                                                                                                                                                                                                                                       
    
    output:                                                                                                                 
    tuple val(SRAID), path("*_1.fastq.gz"), path("*_2.fastq.gz")                                                                                                                                                                                    

    script:                                  
    """
    wget https://sra-pub-run-odp.s3.amazonaws.com/sra/${SRAID}/${SRAID} -O ${SRAID}.sra
    fastq-dump-orig.3.0.0 --gzip --split-files ${SRAID}.sra                                                             
    """                                                                                                                 
}

workflow{
input = Channel
    .fromPath('/home/ubuntu/Projet_hackathon/Fastq_file/identiants_transcriptome.txt')
    .splitText().map{it -> it.trim()}
tupleoutput = recup_data(input)
}
