process recup_data {

    input:
    val SRAID

    output:
    file "*.sra"

    script:
    """
    echo ${SRAID} 
    wget https://sra-pub-run-odp.s3.amazonaws.com/sra/${SRAID}/${SRAID} -O ${SRAID}.sra
    fastq-dump --gzip --split-files ${SRAID}.sra
    #rm ${SRAID}.sra
    
    """
}


workflow {

fastaFiles = recup_data("SRR628582")
}
