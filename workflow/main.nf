process recup_data {

    input:
    val SRAID

    output:
    tuple val(SRAID), path("*_1.fastq.gz"), path("*_2.fastq.gz")

    script:
    """
    wget https://sra-pub-run-odp.s3.amazonaws.com/sra/${SRAID}/${SRAID} -O ${SRAID}.sra
    fastq-dump --gzip --split-files ${SRAID}.sra
    rm ${SRAID}.sra
    
    """
}


workflow {
SRAID = Channel.fromPath("/home/user/identiants_transcriptome.txt") #mettre le bon chemin
fastaFiles = recup_data("identifiant_transcriptome.txt")
}
