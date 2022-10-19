
install.packages("RCurl")
if (!require("BiocManager", quietly = TRUE)) 
    install.packages("BiocManager")
BiocManager::install("")
BiocManager::install("GenomicRanges")
BiocManager::install("SummarizedExperiment")
BiocManager::install("AnnotationDbi")
BiocManager::install("annotate")
BiocManager::install("DESeq2")
BiocManager::install("genefilter")
BiocManager::install("geneplotter")
library(DESeq2)

