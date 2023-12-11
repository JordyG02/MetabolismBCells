#Load these packages, if they don't load use install.packages("name") or BiocManager::install("name")
library(clusterProfiler)
library(org.Hs.eg.db)
library(enrichplot)
library(GOSemSim)
library(DOSE)
library(readxl)
library(openxlsx)

#Select data
gene_data <- read_xlsx("/Users/savec/Documents/Internship/BCell2.xlsx")

## feature 1: numeric vector
geneList = gene_data[,10]

print(geneList)


## feature 2: named vector
names(geneList) = as.character(gene_data[,1])

str(geneList)
## feature 3: decreasing orde
geneList = sort(geneList, decreasing = TRUE)

# set the seed to gain consistent results
set.seed(1234)

#perform GO enrichment analysis
gsea_result <- gseGO(gene = geneList, 
                          OrgDb = org.Hs.eg.db,
                          keyType = "ENSEMBL",
                          ont = "BP",
                          minGSSize    = 100,
                          maxGSSize    = 500,
                          seed = TRUE,
                          pvalueCutoff = 0.05,)
#Check if it worked
print(gsea_result)

#Create network figure
x <- cnetplot(gsea_result)
x <- pairwise_termsim(x, method = "JC")
emapplot(x)
cowplot::plot_grid(x, ncol=1, labels = LETTERS, max.overlaps = 232)

#Extract excel file
write.xlsx(gsea_result, file = "gseago_naive.xlsx")
