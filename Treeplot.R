#Load these packages, if they don't load use install.packages("name") or BiocManager::install("name")
installed.packages()
library(clusterProfiler)
library(org.Hs.eg.db)
library(enrichplot)
library(GOSemSim)
library(DOSE)
library(readxl)

#Select data
gene_data <- read_xlsx("C:/Users/Jordy.G/Downloads/memory_genes_log.xlsx")
#Select gene identifiers from data
gene <- gene_data$Gene
#perform GO enrichment analysis
enrich_result <- enrichGO(gene = gene, 
                          OrgDb = org.Hs.eg.db,
                          keyType = "ENSEMBL",
                          ont = "BP",
                          pvalueCutoff = 0.05,
                          qvalueCutoff = 0.2)
#Check if it worked
print(enrich_result)

#Not exactly sure what they do here, I found this online and it worked (Can ask Tina)
d <- godata('org.Hs.eg.db', ont="BP")
ego2 <- pairwise_termsim(enrich_result, method = "Wang", semData = d)
treeplot(ego2, showCategory = 30)

#After running, should create a treeplot on the bottom right corner