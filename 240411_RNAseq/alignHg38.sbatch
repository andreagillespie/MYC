---
title: "RNAseq_240411"
author: "Andrea"
date: "2024-04-19"
output: html_document
---


```{r setup, include=FALSE}
knitr::opts_chunk$set(eval = FALSE)
```

Project directory: /dawson_genomics/Projects/MYC/240411_RNAseq

fastq dir: /pipeline/Runs/NextSeq/240411_VH01624_86_AACG7NKHV/ProjectFolders/Project_Jesse-Balic/Sample_*/

```{bash}
mkdir scripts
mkdir fastqc
mkdir trimmed_fastqs
mkdir bams
mkdir counts
mkdir tdfs
mkdir logs

for fq in /pipeline/Runs/NextSeq/240411_VH01624_86_AACG7NKHV/ProjectFolders/Project_Jesse-Balic/Sample_*/*_R1_001.fastq.gz
do
sbatch scripts/align_star.sbatch $fq 
done

# when fastqc is finished run multiqc 
module load multiqc/1.8
cd fastqc
multiqc .
cd ..
# and on full dir after all processing finished
multiqc .
```

# load libraries
```{r, eval=TRUE}
library(data.table)
library(RColorBrewer)
library(edgeR)
library(qvalue)
library(ggplot2)
library(ComplexHeatmap)
```

# set up dirs
```{r}
project.dir <- "/dawson_genomics/Projects/MYC/240411_RNAseq"
counts.dir <- file.path(project.dir, "counts")
session.dir <- file.path(project.dir, "session-info")
bam.dir <- file.path(project.dir, "bams")
res.dir <- file.path(project.dir, "results")
plots.dir <- file.path(project.dir, "plots")

dir.create(session.dir)
dir.create(res.dir)
dir.create(plots.dir)
```

# load into edger and filter low counts
```{r}
# get a list of all count files
files <- list.files(counts.dir)
# simplify names to use as sample names
snames <- gsub(".count", "", files)

# make sample annotation 
sample.ann <- data.frame(
  "files" = files, 
  "samples" = snames, 
  "cells" = c(rep("B3", 11), rep("CREBBP_KO", 11), rep("EP300_KO", 11)),
  "dTAG" = c(rep("NEG", 4), rep("V1", 7), rep("NEG", 4), rep("V1", 7), rep("NEG", 4), rep("V1", 7)),
  "time" = rep(c(rep("24h", 8), rep("4h", 3)), 3),
  "replicate" = rep(c(rep(paste0("R", 1:4), 2), paste0("R", 1:3)), 3)
  )
sample.ann$group <- paste(sample.ann$cells, sample.ann$dTAG, sample.ann$time, sep = "_")

dge.counts = readDGE(
  file = sample.ann$files, 
  path = counts.dir,
  group = sample.ann$group
  )

# write out raw counts
write.table(
  dge.counts$counts,
  file.path(res.dir, "raw_counts.txt"),
  sep = "\t",
  row.names = TRUE,
  col.names = NA,
  quote = FALSE
  )

# Filtering out genes with low counts & not useful
noint <- rownames(dge.counts$counts) %in% c("__no_feature", "__ambiguous", "__too_low_aQual", "__not_aligned", "__alignment_not_unique")
counts.cpms <- cpm(dge.counts$counts)
keep <- rowSums(counts.cpms > 1 ) >= 4 & !noint
table(keep)
dge.counts$counts <- dge.counts$counts[keep,]
```
keep
FALSE  TRUE 
42232 18447

# calc TMM norm and write out file
```{r}
dge.counts <- calcNormFactors(dge.counts, method = "TMM")

# multiply counts by norm factors
counts.norm <- as.data.frame(dge.counts$counts%*%diag(dge.counts$samples$norm.factors))
colnames(counts.norm) <- snames
write.table(
  counts.norm,
  file.path(res.dir, "TMMnorm_counts.txt"),
  sep = "\t",
  col.names = NA,
  row.names = TRUE,
  quote = FALSE
  )
```

# add ann info
```{r}
dge.counts$samples$group = sample.ann$group
dge.counts$samples$dTAG = sample.ann$dTAG
dge.counts$samples$cells = sample.ann$cells
dge.counts$samples$replicate = sample.ann$replicate
dge.counts$samples$samples = sample.ann$samples
```

# MDS plot norm counts
```{r}
# Setting colours
col.group <- as.factor(dge.counts$samples$group)
levels(col.group) <- brewer.pal(nlevels(col.group), "Set1") 
col.group <- as.character(col.group)

pdf(file.path(plots.dir, "MDS_TMM_norm_counts.pdf"))
MDS = plotMDS(
  dge.counts,
  labels = paste0(dge.counts$samples$group), 
  col = col.group
  )
dev.off()

# colour by dTAG
col.group <- as.factor(dge.counts$samples$dTAG)
levels(col.group) <- brewer.pal(nlevels(col.group), "Set1") 
col.group <- as.character(col.group)

pdf(file.path(plots.dir, "MDS_TMM_norm_counts_dTAG.pdf"))
MDS = plotMDS(
  dge.counts,
  labels = paste0(dge.counts$samples$group), 
  col = col.group
  )
dev.off()

# colour by cells
col.group <- as.factor(dge.counts$samples$cells)
levels(col.group) <- brewer.pal(nlevels(col.group), "Set1") 
col.group <- as.character(col.group)

pdf(file.path(plots.dir, "MDS_TMM_norm_counts_cells.pdf"))
MDS = plotMDS(
  dge.counts,
  labels = paste0(dge.counts$samples$group), 
  col = col.group
  )
dev.off()

# colour by replicate
col.group <- as.factor(dge.counts$samples$replicate)
levels(col.group) <- brewer.pal(nlevels(col.group), "Set1") 
col.group <- as.character(col.group)

pdf(file.path(plots.dir, "MDS_TMM_norm_counts_replicate.pdf"))
MDS = plotMDS(
  dge.counts,
  labels = paste0(dge.counts$samples$samples), 
  col = col.group
  )
dev.off()
```

# look at spike-in counts for norm
```{r}
dm.counts = readDGE(
  file = sample.ann$files, 
  path = file.path(project.dir, "Dm_counts"),
  group = sample.ann$group
  )

dm.counts <- calcNormFactors(dm.counts, method = "TMM")
```

# MDS plots of spike-in norm counts
```{r}
dge.counts$samples$norm.factors <- dm.counts$samples$norm.factors

# Setting colours
col.group <- as.factor(dge.counts$samples$group)
levels(col.group) <- brewer.pal(nlevels(col.group), "Set1") 
col.group <- as.character(col.group)

pdf(file.path(plots.dir, "MDS_spikein_norm_counts.pdf"))
MDS = plotMDS(
  dge.counts,
  labels = paste0(dge.counts$samples$group), 
  col = col.group
  )
dev.off()

# colour by dTAG
col.group <- as.factor(dge.counts$samples$dTAG)
levels(col.group) <- brewer.pal(nlevels(col.group), "Set1") 
col.group <- as.character(col.group)

pdf(file.path(plots.dir, "MDS_spikein_norm_counts_dTAG.pdf"))
MDS = plotMDS(
  dge.counts,
  labels = paste0(dge.counts$samples$group), 
  col = col.group
  )
dev.off()

# colour by cells
col.group <- as.factor(dge.counts$samples$cells)
levels(col.group) <- brewer.pal(nlevels(col.group), "Set1") 
col.group <- as.character(col.group)

pdf(file.path(plots.dir, "MDS_spikein_norm_counts_cells.pdf"))
MDS = plotMDS(
  dge.counts,
  labels = paste0(dge.counts$samples$group), 
  col = col.group
  )
dev.off()
```

### spike-in norm okay in that norm factors are reasonable and quite similar to TMM, but offer no improvement in clustering (TMM very similar, but tighter) so proceeding with TMM
```{r}
dge.counts <- calcNormFactors(dge.counts, method = "TMM")
```

# set design and contrasts for DE
```{r}
# design table
design = model.matrix(~0+group, data = dge.counts$samples)
colnames(design) <- gsub("group", "", colnames(design))
design

contr.matrix <- makeContrasts(
  B3_24h_V1vsNEG = B3_V1_24h-B3_NEG_24h,
  B3_4h_V1vsNEG = B3_V1_4h-B3_NEG_24h,
  CREBBP_KO_24h_V1vsNEG = CREBBP_KO_V1_24h-CREBBP_KO_NEG_24h,
  CREBBP_KO_4h_V1vsNEG = CREBBP_KO_V1_4h-CREBBP_KO_NEG_24h,
  EP300_KO_24h_V1vsNEG = EP300_KO_V1_24h-EP300_KO_NEG_24h,
  EP300_KO_4h_V1vsNEG = EP300_KO_V1_4h-EP300_KO_NEG_24h,
  levels = colnames(design)
  )
contr.matrix
```

# estimate dispersion and get DE
```{r}
bm.ann <- fread("/data/reference/dawson_labs/biomart_annotations/Hsapiens/ensembl_hgnc_entrez.txt")

dge.counts = estimateDisp(dge.counts, design)
gfit <- glmQLFit(dge.counts, design)

ftest.list <- list()

for(con.i in 1:length(colnames(contr.matrix))){

  ftest.list[[con.i]] <- glmQLFTest(gfit, contrast = contr.matrix[, con.i])
  ftest.list[[con.i]]$table$ensg <- rownames(ftest.list[[con.i]]$table)
  ftest.list[[con.i]]$table <- merge(ftest.list[[con.i]]$table, bm.ann, by.x = "ensg", by.y = "ensembl_gene_id")
  # add qvalues to table, order by that and write out
  qv <- qvalue(ftest.list[[con.i]]$table$PValue)
  ftest.list[[con.i]]$table$QValue <- qv$qvalues
  ftest.list[[con.i]]$table <- ftest.list[[con.i]]$table[order(ftest.list[[con.i]]$table$QValue, decreasing = FALSE),]
  write.table(
    ftest.list[[con.i]]$table,
    file.path(res.dir, paste0(colnames(contr.matrix)[con.i], "_ftest_table.txt")),
    sep = "\t",
    quote = FALSE,
    col.names = TRUE,
    row.names = FALSE
  )
}
names(ftest.list) <- colnames(contr.matrix)
```

# make a violin plot of LFCs
```{r}
# make df of LFCs for each comparison
de.lfc <- data.frame(
  "LFC" = c(ftest.list[[1]]$table$logFC, ftest.list[[2]]$table$logFC, ftest.list[[3]]$table$logFC, ftest.list[[4]]$table$logFC, ftest.list[[5]]$table$logFC, ftest.list[[6]]$table$logFC),
  "comp" = c(
    rep(names(ftest.list)[[1]], nrow(ftest.list[[1]]$table)), 
    rep(names(ftest.list)[[2]], nrow(ftest.list[[2]]$table)), 
    rep(names(ftest.list)[[3]], nrow(ftest.list[[3]]$table)), 
    rep(names(ftest.list)[[4]], nrow(ftest.list[[4]]$table)), 
    rep(names(ftest.list)[[5]], nrow(ftest.list[[5]]$table)), 
    rep(names(ftest.list)[[6]], nrow(ftest.list[[6]]$table))
    )
)

pdf(file.path(plots.dir, "violin_DE_LFC.pdf"))
ggplot(de.lfc, aes(x = comp, y = LFC, fill = comp)) +
  geom_violin() +
  ggtitle("LFC expression") +
  ylim(-2, 2) +
  theme_minimal()
dev.off()
```

# make a heatmap of top de genes
```{r}
# get 100 most sig in each comp
top.de <- NULL

for(comp.i in 1:length(ftest.list)){
  comp.top <- ftest.list[[comp.i]]$table$ensg[1:100]
  top.de <- c(top.de, comp.top)
}
# only need each gene once
top.de <- unique(top.de)

# make heatmap of expression z-score at these genes
heat.de <- as.matrix(counts.norm[top.de, ])
heat.de <- t(scale(t(heat.de)))
# annotate with gene names
#heat.de <- cbind(heat.de, "ensg" = rownames(heat.de))
#heat.de.genes <- merge(heat.de, bm.ann, by.x = "ensg", by.y = "ensembl_gene_id")
#heat.de.genes$hgnc_symbol[which(heat.de.genes$hgnc_symbol == "")] <- heat.de.genes$ensg[which(heat.de.genes$hgnc_symbol == "")]
#heat.de.genes$hgnc_symbol[which(duplicated(heat.de.genes$hgnc_symbol))] <- paste0(heat.de.genes$hgnc_symbol[which(duplicated(heat.de.genes$hgnc_symbol))], "_2")
#rownames(heat.de.genes) <- heat.de.genes$hgnc_symbol
#heat.de.genes <- as.matrix(as.numeric(heat.de.genes[, 2:34]))

pdf(file.path(plots.dir, "Heatmap_topDEgenes.pdf"))
Heatmap(heat.de, name = "z-score(normCounts)", show_row_names = FALSE, column_names_gp = gpar(fontsize = 6))
dev.off()
```

# also make heatmap of all genes
```{r}
heat.all <- as.matrix(counts.norm)
heat.all <- t(scale(t(heat.all)))

pdf(file.path(plots.dir, "Heatmap_allGenes.pdf"))
Heatmap(heat.all, name = "z-score(normCounts)", show_row_names = FALSE, column_names_gp = gpar(fontsize = 6))
dev.off()
```

# since spike-in looked reasonable, run fastq screen to look at dros percentages
```{bash}
for fq in /pipeline/Runs/NextSeq/240411_VH01624_86_AACG7NKHV/ProjectFolders/Project_Jesse-Balic/Sample_*/*_R1_001.fastq.gz
do
sbatch scripts/fastq_screen.sbatch $fq 
done

module load multiqc/1.8
multiqc .
```



# save session info
```{r}
sesh.info <- capture.output(sessionInfo())
writeLines(
  sesh.info,
  file.path(session.dir, paste0(Sys.Date(), "_RNAseq_240411.txt"))
)
```
