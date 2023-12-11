#Load these packages, if they don't load use install.packages("name") or BiocManager::install("name")
library(clusterProfiler)
library(org.Hs.eg.db)
library(enrichplot)
library(GOSemSim)
library(DOSE)
library(readxl)
library(openxlsx)

#load data
memory_genes_log <- read_excel("/Users/savec/Documents/Internship/BCell2.xlsx")

df <- as.data.frame(memory_genes_log)

#change gene ID type to EntrezID
mapping <- bitr(df$Gene,fromType = "ENSEMBL",toType = "ENTREZID",OrgDb = org.Hs.eg.db)
x <- merge(df, mapping, by.x="Gene", by.y="ENSEMBL")

#change - remove all rows with NA in ENTREZID
x <- x[complete.cases(x$ENTREZID), ]

#assign numeric and named vector
df.data <- x[,9]
names(df.data) <- x$ENTREZID

#order gene list
geneList = sort(df.data, decreasing = TRUE)

#perform gseWP
res <- gseWP(gene = geneList, organism = "Homo sapiens",
             minGSSize    = 10,
             maxGSSize    = 500,
             pvalueCutoff = 0.05,)

res.df <- as.data.frame(res)
print(df)
#extract table
write.xlsx(res, file="GSEWP_correct.xlsx")

