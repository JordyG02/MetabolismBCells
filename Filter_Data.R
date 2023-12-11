library(openxlsx)
Bcell <- read.xlsx("/Users/savec/Desktop/BCell.xlsx")
L <- read.xlsx("/Users/savec/Desktop/MBdataset.xlsx")
ringdingding <- subset(Bcell, GeneName %in% L$Gene)
# subset(excel_data, Gene_name %in% csv_data$Gene)
print(ringdingding)
# Assuming ringdingding is your data frame
write.xlsx(ringdingding, file = "memory_naive_genes.xlsx")


browseVignettes(package = "clusterProfiler")
