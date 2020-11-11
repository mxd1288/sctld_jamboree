### PCA plot with custom PC axes----------------------------------------------------------------------------------
plotPCA.custom <-  function(object, intgroup="Treatment", ntop=500, returnData=FALSE, pcs = c(1,2))
{
  stopifnot(length(pcs) == 2)    ### added this to check number of PCs ####
  # calculate the variance for each gene
  rv <- rowVars(assay(object))
  # select the ntop genes by variance
  select <- order(rv, decreasing=TRUE)[seq_len(min(ntop, length(rv)))]
  # perform a PCA on the data in assay(x) for the selected genes
  pca <- prcomp(t(assay(object)[select,]))
  # the contribution to the total variance for each component
  percentVar <- pca$sdev^2 / sum( pca$sdev^2 )
  if (!all(intgroup %in% names(colData(object)))) {
    stop("the argument 'intgroup' should specify columns of colData(dds)")
  }
  intgroup.df <- as.data.frame(colData(object)[, intgroup, drop=FALSE])
  # add the intgroup factors together to create a new grouping factor
  group <- if (length(intgroup) > 1) {
    factor(apply( intgroup.df, 1, paste, collapse=" : "))
  } else {
    colData(object)[[intgroup]]
  }
  # assemble the data for the plot
  ########## Here we just use the pcs object passed by the end user ####
  d <- data.frame(PC1=pca$x[,pcs[1]], PC2=pca$x[,pcs[2]], group=group, intgroup.df, name=colnames(object))
  if (returnData) {
    attr(d, "percentVar") <- percentVar[1:2]
    return(d)
  }
  
  # extract loadings
}

### PCA plot formatted with aesthetics ---------------------------------------------------------------------------
ggPCA <- function(vsd, samples, condcolors, ntop = 500,  pclab = c(1,2)) {
  
  PCAtmtdata <- plotPCA.custom(vsd, intgroup = c("Treatment"), ntop = 500, returnData = TRUE,  pcs = c(pclab[1],pclab[2]))
  #set factor orders 
  # PCAtmtdata$Colony <- factor(PCAtmtdata$Colony, levels = c("HW1", "HW2", "WT1", "WT2"), ordered = TRUE)
  PCAtmtdata$Treatment <- factor(PCAtmtdata$Treatment, levels = c("Control", "Experimental"), ordered = TRUE)
  
  PCAtmtpercentVar <- round(100* attr(PCAtmtdata, "percentVar"))
  
  PCAplot <-  PCAtmtdata %>% ggplot(aes(PC1,PC2)) +
    geom_point(size=4, aes(color = Treatment), stroke = 0.5, show.legend = TRUE) +
    xlab(paste0( "PC", pclab[1], ": ", PCAtmtpercentVar[pclab[1]], "% variance")) + 
    ylab(paste0( "PC", pclab[2], ": ", PCAtmtpercentVar[pclab[2]], "% variance")) + 
    coord_fixed(1) + 
    scale_color_manual(values=c("blue", "red"), name="Treatment") +
    # scale_shape_manual(values=colshapes, name="Colony") +
    theme(legend.position = "right") +
    # guides(fill = guide_legend(override.aes = list(fill = condcolors, shape = 21, alpha = 1, stroke = 0.5))) +
    ggtitle("Principal Component Analysis")
  
  PCAplot
}

### Volcano plot for differential gene expression -----------------------------------------------------------------
volcanoplot <- function(res) {
  
  ##Highlight genes that have a padj < 0.05
  res$threshold <- ifelse(res$padj < 0.05 & res$log2FoldChange > 0, "Upregulated", ifelse(res$padj < 0.05 & res$log2FoldChange < 0, "Downregulated", "NA"))
  res$log10padj <- -log10(res$padj)
  dat_genes <- data.frame(cbind(res$log2FoldChange, res$log10padj, res$threshold), stringsAsFactors = FALSE)
  colnames(dat_genes) <- c("log2FoldChange", "log10padj", "threshold")
  row.names(dat_genes) <- res$IDGeneInfo
  #dat_genes <- dat_genes[order(dat_genes$log2FoldChange, decreasing = TRUE),]
  dat_genes$log2FoldChange <- as.numeric(dat_genes$log2FoldChange)
  dat_genes$log10padj <- as.numeric(dat_genes$log10padj)
  dat_genes$threshold <- factor(dat_genes$threshold, levels = c("Upregulated", "Downregulated", "NA"), ordered = TRUE)
  #Create volcanoplot
  gVolcano <- dat_genes %>% 
    ggplot(aes(log2FoldChange, log10padj)) + 
    geom_point(aes(color = threshold), alpha=0.7, size=2) +
    scale_color_manual(values = DEGcolors) +
    scale_x_continuous(limits = c(-6,6), breaks = seq(-10,10,2)) + 
    ylim(c(0, 10)) +
    xlab("log2 fold change") +
    ylab("-log10 p-value") + 
    #geom_text_repel(data = dat_genes_LPS_ctrl[1:15, ], aes(label = rownames(dat_genes_LPS_ctrl[1:15, ])), color = "black", size = 2.5, box.padding = unit(0.35, "lines")) +
    theme_bw() +
    theme(legend.position = "none", 
          plot.title = element_text(size = 12, hjust = 0, vjust = 1),
          axis.text = element_text(size = 10),
          axis.title = element_text(size = 10))
  print(gVolcano)
}

### Gene expression boxplot functions ------------------------------------------------------------------------------------
ggboxplot <- function(gene) {
  plotTitle <- gene_annotation %>% filter(ID == gene) %>% select(Gene_Info)
  subTitle <- gene
  df <- plotCounts(dds, gene = gene, intgroup = "Treatment", returnData = TRUE)
  df$Treatment <- factor(df$Treatment, levels = c("control", "Heat", "Antibiotics", "Antibiotics.Heat"), ordered = TRUE)
  gbplot <- df %>% ggplot(aes(x = Treatment, y = count, color = Treatment, fill = Treatment)) +
    geom_boxplot(show.legend = FALSE) + 
    geom_point(aes(shape = samples$Colony), size = 2, show.legend = FALSE) +
    scale_color_manual(values = condcolors_AxH) +
    scale_fill_manual(values = condfillcolors_AxH) +
    scale_shape_manual(values = colshapes) +
    scale_y_continuous(trans = log2_trans(),
                       breaks = trans_breaks("log2", function(x) 2^x),
                       labels = trans_format("log2", math_format(2^.x))) +
    ggtitle(plotTitle, subtitle = subTitle)
  print(gbplot)
}


genoboxplot <- function(gene) {
  plotTitle <- gene_annotation %>% filter(ID == gene) %>% select(Gene_Info)
  subTitle <- gene
  df <- plotCounts(dds, gene = gene, intgroup = "Treatment", returnData = TRUE)
  df$Treatment <- factor(df$Treatment, levels = c("control", "Heat", "Antibiotics", "Antibiotics.Heat"), ordered = TRUE)
  gbplot <- df %>% ggplot(aes(x = Treatment, y = count, color = Treatment)) +
    geom_boxplot(aes(fill = Treatment), show.legend = FALSE) + 
    geom_point(aes(shape = samples$Colony), size = 2, show.legend = FALSE) +
    facet_grid(.~samples$Colony) +
    ### add interaction line between genotypes
    stat_summary(fun=mean, geom="path", colour="black", size=0.8, aes(group = samples$Colony)) +
    stat_summary(fun=mean, geom="point", colour="black", size=3, aes(shape = samples$Colony, group = samples$Colony), show.legend = FALSE) +
    ###
    scale_color_manual(values = condcolors_AxH) +
    scale_fill_manual(values = condfillcolors_AxH) +
    scale_shape_manual(values = colshapes) +
    scale_y_continuous(trans = log2_trans(),
                       breaks = trans_breaks("log2", function(x) 2^x),
                       labels = trans_format("log2", math_format(2^.x))) +
    ggtitle(plotTitle, subtitle = subTitle)
  print(gbplot)
  ###
  g_bplot <- ggplot_gtable(ggplot_build(gbplot))
  strip_both <- which(grepl('strip-', g_bplot$layout$name))
  k <- 1
  for (i in strip_both) {
    j <- which(grepl('rect', g_bplot$grobs[[i]]$grobs[[1]]$childrenOrder))
    g_bplot$grobs[[i]]$grobs[[1]]$children[[j]]$gp$fill <- colcolors[k]
    k <- k+1
  }
  gbp <- grid.draw(g_bplot)
  print(gbp)
}
