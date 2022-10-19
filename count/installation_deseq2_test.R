install.packages("DESeq2",dependencies = TRUE)


if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install("DESeq2")

library(DESeq2)
sessionInfo()
