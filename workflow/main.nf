process recup_data {

    input:
    val SRAID

    output:
    file "*.fastq.gz"

    script:
    """ 
    wget https://sra-pub-run-odp.s3.amazonaws.com/sra/${SRAID}/${SRAID} -O ${SRAID}.sra
    fastq-dump --gzip --split-files ${SRAID}.sra
    #rm ${SRAID}.sra
    
    """
}


workflow {

SRAID = Channel.from('SRR628582')
recup_data(SRAID)
}
