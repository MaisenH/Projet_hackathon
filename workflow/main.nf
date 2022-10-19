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
fastaFiles = Channel.fromPath("/home/user/fasta/*.fasta")
mapping_files = mapping(fastaFiles)
count_files = count(mapping_files)
subread_file = subread(count_files)
analyze_result = analyze(count_files)

}