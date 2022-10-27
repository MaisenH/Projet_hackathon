process recup_data {

    input:
    val identifiant

    output:
    file "*.sra"

    script:limitBAMsortRAM
    """
    SRAID=identifiant
    wget https://sra-pub-run-odp.s3.amazonaws.com/sra/${ligne}/${ligne}
    fastq-dump --gzip --split-files ${ligne}.sra

    """
}

process trimmomatic {

    input:
    file identifiant

    output:
    file 

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
fastaFiles = recup_data("identifiant_transcriptome.txt")
trimmomatic_file = trimmomatic(fastaFiles)
mapping_files = mapping(trimmomatic_file)
count_files = count(mapping_files)
subread_file = subread(count_files)
analyze_result = analyze(count_files)

}