process recup_data {
        
    input:
    val SRAID

    output:
    file "SRR628583_1.fastq.gz"

    script:
    """ 
    wget https://sra-pub-run-odp.s3.amazonaws.com/sra/${SRAID}/${SRAID} -O ${SRAID}.sra
    /usr/local/bin/fastq-dump-orig.3.0.0 --gzip --split-files ./${SRAID}.sra
    # fastq-dump --gzip --split-files ./${SRAID}.sra
    rm ${SRAID}.sra
    
    """
}


workflow {
recup_data("SRR628583")
}
