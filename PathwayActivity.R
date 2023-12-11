if(!"tidyr" %in% installed.packages()) BiocManager::install("tidyr", update=FALSE)


#Load these packages, if they don't load use install.packages("name") or BiocManager::install("name")
library(clusterProfiler)
library(org.Hs.eg.db)
library(enrichplot)
library(GOSemSim)
library(DOSE)
library(readxl)
library(openxlsx)
library(tidyr)

options(stringsAsFactors = F)

# TODO
#setwd(...)

#load data
bcell.data <- read_excel("BCell2.xlsx")

#change gene ID type to EntrezID
mapping <- bitr(bcell.data$Gene, fromType = "ENSEMBL",toType = "ENTREZID", OrgDb = org.Hs.eg.db)
bcell.data.id <- merge(bcell.data, mapping, by.x="Gene", by.y="ENSEMBL")

# remove all rows with NA in ENTREZID
bcell.data.id <- bcell.data.id[complete.cases(bcell.data.id$ENTREZID), ]

#----------------------------------------------------
# Retrieve pathway collection from WikiPathways
#----------------------------------------------------
gmt <- rWikiPathways::downloadPathwayArchive(date="20231210", organism="Homo sapiens", format = "gmt")
wp <- clusterProfiler::read.gmt(gmt)
colnames(wp)[c(1,2)] <- c("pathway", "entrezgene")

# number of genes in pathway
wp.count <- wp %>% group_by(pathway) %>% mutate(count = n())
wp.count <- wp.count[,c(1,3)]
wp.count <- unique(wp.count)

wp.filt <- wp[wp$entrezgene %in% bcell.data.id$ENTREZID,]
bcell.data.id$ENTREZID <- as.character(bcell.data.id$ENTREZID)
wp.filt <- merge(wp.filt, bcell.data.id, by.x="entrezgene", by.y="ENTREZID", all.x=TRUE)
wp.filt <- merge(wp.filt, wp.count, by = "pathway")
wp.filt <- tidyr::separate(data = wp.filt, col = pathway, into = c("name", "version", "id", "species"), sep = "%")

met.pathways <- read.table("metabolic-pathways.tsv")


wp.filt <- subset(wp.filt, id %in% met.pathways$V1)
wp.filt <- subset(wp.filt, count>10)

# pathway activity analysis
medExpr <- data.frame(WPID = character(0), Name = character(0), Naive = numeric(0), Memory = numeric(0), Diff = numeric(0))
i <- 1
for (p in unique(wp.filt$id)) {
  data.selected <- wp.filt[wp.filt$id==p,]
  med.memory <- median(data.selected$nTPM_memory)
  med.naive <- median(data.selected$nTPM_naive)
  name <- data.selected[1,1]
  medExpr[i,] <- c(p,name, med.naive, med.memory, med.naive-med.memory)
  i <- i+1
}

medExpr[,3] <- as.numeric(medExpr[,3])
medExpr[,4] <- as.numeric(medExpr[,4])
medExpr[,5] <- as.numeric(medExpr[,5])

# Plot Pathway Activity
plot(medExpr[,3], medExpr[,4], xlim=c(0,250), ylim=c(0,250), xlab = "Naive B cells", ylab = "Memory B cells", main="Median Pathway Activity")
abline(a = 1, b = 1, col = "red")
