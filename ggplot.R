library(readxl)
library(ggplot2)


#Load in data
p <- read.xlsx("/Users/savec/Documents/Internship/gseago_naive_normalized_metabolic.xlsx")

#Order processes based on normalized enrichment score
p$Description <- factor(p$Description, levels = p$Description[order(p$`NES`, decreasing = FALSE)])

#Create dotplot
ggplot(p, aes(x = Description, y = `NES`, color = pvalue)) +
  geom_point() +
  scale_color_gradientn(colors = c("red","blue")) +  
  theme(axis.text.x = element_text(angle = 75, hjust = 1)) +
  labs(x = "Metabolic Processes", y = "Normalized Enrichment Score", title = "GSEA Naive B Cells Metabolic Processes")




