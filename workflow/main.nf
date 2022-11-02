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

process trimmomatic {

    input:
    tuple val(SRAID), path("*_1.fastq.gz"), path("*_2.fastq.gz")

    output:
    tuple val(SRAID), path("*_1U.fastq.gz"), path("*_2U.fastq.gz") #On récupere les sequences U

    script:
    """
    trimmomatic ...
    
    """
}

process mapping {

    input:
    file 

    output:
    file ""

    script:
    """
    ##CREATION INDEX 

    STAR --runThreadN <nb cpus> --runMode genomeGenerate --genomeDir ref/ -- genomeFastaFiles ref.fa  

    ##MAPPING 
    STAR --outSAMstrandField intronMotif \
        --outFilterMismatchNmax 4 \
        --outFilterMultimapNmax 10 \
        --genomeDir ref \
        --readFilesIn <(gunzip -c <fastq1>) <(gunzip -c <fastq2>) \
        --runThreadN <Nb CPUS> \
        --outSAMunmapped None \
        --outSAMtype BAM SortedByCoordinate \
        --outStd BAM_SortedByCoordinate \
        --genomeLoad NoSharedMemory \
        --limitBAMsortRAM <Memory in Bytes> \
        > <sample id>.bam
    samtools index *.bam
    """
}

process count {

    input:
    file 

    output:
    file ""

    script:
    """
    featureCounts -T <CPUS> -t gene -g gene_id -s 0 -a input.gtf -o output.counts input.bam 
    
    """
}

process subread {

    input:
    file 

    output:
    file ""

    script:
    """
    subread ...
    
    """
}

process analyze {

    input:
    file 

    output:
    file ""

    script:
    """
    code R
    library(DESeq2)   ... 
    """
}

workflow {
SRAID = Channel.fromPath("/home/user/identiants_transcriptome.txt") #mettre le bon chemin
fastaFiles = recup_data("identifiant_transcriptome.txt")
trimmomatic_file = trimmomatic(fastaFiles)
mapping_files = mapping(trimmomatic_file)
count_files = count(mapping_files)
subread_file = subread(count_files)
analyze_result = analyze(count_files)

}
