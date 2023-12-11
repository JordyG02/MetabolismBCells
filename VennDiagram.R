install.packages("VennDiagram")
library(VennDiagram)
library(openxlsx)
shush <- read.xlsx("/Users/savec/documents/internship/GeneID_naive_memory.xlsx")

naive_genes <- shush$Ensembl[shush$naive == 1]

memory_genes <- shush$Ensembl[shush$memory == 1]

venn.plot <- venn.diagram(list(Naive = naive_genes, Memory = memory_genes),
                       category.names = c("Naive", "Memory"),
                       filename = NULL,
                       output = TRUE)
# Create a Venn diagram

# Display the Venn diagram
grid.draw(venn.plot)
