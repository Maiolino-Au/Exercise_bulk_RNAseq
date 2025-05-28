# https://github.com/malina-dva/RNA-seq-Data-normalization-and-clustering

# Load stuff
# if (!require("BiocManager", quietly = TRUE))
#   install.packages("BiocManager")
# BiocManager::install("DESeq2")
require(DESeq2)
require(ggplot2)

setwd("/sharedFolder")

name_new_dir_results <- paste(getwd(), "/Results", sep = "")
if (!dir.exists(name_new_dir_results)) {
    dir.create(name_new_dir_results)
}

name_new_dir_partial <- paste(getwd(), "/Partial", sep = "")
if (!dir.exists(name_new_dir_partial)) {
    dir.create(name_new_dir_partial)
}

# Import the data
# row.names=1 specifies that the first column refers to the name of the genes
just.raw.counts = read.delim("Raw_counts_input.txt", row.names=1)  
head(just.raw.counts)
dim(just.raw.counts)

# Import metadata
meta.data <- read.delim("meta_data.txt", row.names=1) 

# Create a DEseq matrix 
  # 'countData' argument requires the table with the counts and the names of the genes
  # 
  # 'colData' argument requires the metadata file
  # 
  # 'design' requires the column of the metadata that holds the information for the relationships between replicates and conditions (e.g the 'condition' column from the metadata in our case)

count.data.set <- DESeqDataSetFromMatrix(countData=just.raw.counts, 
                                         colData=meta.data, design= ~ condition) 

# Create DEseq object
count.data.set.object <- DESeq(count.data.set)

# Normalize with Variance Stabilizing Transformation
# rlog() could also be used
vsd <- vst(count.data.set.object)

norm.data = assay(vsd)
head(norm.data)

# Create a file with a table of the normalized data
write.table(norm.data, sep="\t",file="Norm_data_all_genes_NO_counts_cut_off.tsv", row.names=TRUE,col.names=NA,quote=FALSE)

# HIERARCHICAL CLUSTERING

# Calculate euclidean distances
# "t" is transponse: it reverses row and colums in the table
sampleDists <- dist(t(norm.data),  method = "euclidean")

reversed_rows_columns = (t(norm.data))

clusters=hclust(sampleDists)
plot(clusters)
print("clusters")
# PCA
# We have to specify that the column "condition" from the metadata has to be taken as a information for replicates grouping
# plotPCA(vsd, intgroup=c("condition")) 

# PCA plot but with the groups organized by increasing developmental stage
plotPCA(vsd, intgroup=c("condition")) +
  scale_colour_hue(breaks = c("E14.5","E14.5","Neonatal","Neonatal","Adult","Adult","TAC","TAC"))

print("pca")



