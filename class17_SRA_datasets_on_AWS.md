# Class 17: Obtaining and processing SRA datasets on AWS
Hubert Phan (PID: A17663330)

## The Sequence Read Archive (SRA)

### A mini example: from a given paper to raw reads

> Q. What shell command can you use to view the top few files of your
> FASTQ file?

**Ans:** You can use ‘head SRR600956.fastq’.

> Q. What length are these sequence reads?

**Ans:** The length of these sequence read is 38 bp.

> Q. Can you use the grep command to determine how many total reads are
> in this file?

**Ans:** Yes you can use ‘grep -c “^@SRR600956” SRR600956.fastq’ to
determine the total number of reads in the file.

> Q. Does you number of reads from grep match the name of the last read
> in the file? If not why not?

**Ans:** Yes, using ‘grep -c “^@SRR600956” SRR600956.fastq’ gives us
25849655 reads and the last read in the file is labeled as
‘@SRR600956.25849655’, so they match. This shows that the dataset is set
up sequentially so that the final identifier corresponds to the total
number of reads in the file.

## Working with RNA-Seq data

> Q. How would you check that these files with extension ‘.fastq’
> actually look like what we expect for a FASTQ file? You could try
> printing the first few lines to the shell standard output:

**Ans:** Use ‘head SRR2156848_1.fastq’ and also ‘head
SRR2156848_2.fastq’ to check the first few lines of the mate file.

> Q. How could you check the number of sequences in each file?

**Ans:** Use ‘grep -c “^@SRR2156848” SRR2156848_1.fastq’ and ‘grep -c
“^@SRR2156848” SRR2156848_2.fastq’ to check the number of sequences in
each file.

> Q. Check your answer with the bottom of the file using the tail
> command and also check the matching mate pair FASTQ file. Do these
> numbers match? If so why or why not?

**Ans:** Use ‘tail SRR2156848_1.fastq’ and ‘tail SRR2156848_2.fastq’ to
check the bottom of the file. The last read in both files is labeled as
‘@SRR2156848.25849655’, so they match. This shows that the dataset is
set up sequentially so that the final identifier corresponds to the
total number of reads in the file.

> Q. Download the other 3 datasets (SRR2156849, SRR2156850 and
> SRR2156851) we need for our analysis, first with prefetch and then
> process with fasterq-dump

**Ans:** Use ‘prefetch SRR2156849’, ‘prefetch SRR2156850’, and ‘prefetch
SRR2156851’ to download the datasets. Then use ‘fasterq-dump
SRR2156849’, ‘fasterq-dump SRR2156850’, and ‘fasterq-dump SRR2156851’ to
process the datasets into FASTQ files.

> Q. Check you have pairs of FASTQ files for all four datasets and that
> they have the same number of counts in each pair?

**Ans:** Use ’ls *.fastq’ to check that you have pairs of FASTQ files
for all four datasets. Then use grep -c “^@SRR21568”* .fastq to check
the number of counts in each pair.

## Transcript quantification via pseudoalignment

> Q. Can you run kallisto to print out its citation information?

**Ans:** Yes, just call ‘kallisto’. Ensure that ‘export
PATH=$PATH:$PWD/kallisto_linux-v0.44.0’ is set in the environment
variables to access the kallisto executable.

### Quantifying transcripts

> Q. Now run the quantification calculation for the remaining samples:

**Ans:** Steps to complete:

kallisto quant -i hg19.ensembl -o SRR2156849_quant SRR2156849_1.fastq
SRR2156849_2.fastq

kallisto quant -i hg19.ensembl -o SRR2156850_quant RR2156850_1
SRR2156850_2.fastq

kallisto quant -i hg19.ensembl -o SRR2156851_quant SRR2156851_1.fastq
SRR2156851_2.fastq

### Check your results

> Q. Have a look at the TSV format versions of these files to understand
> their structure. What do you notice about these files contents?

**Ans:** The TSV files contain the following columns: target_id, length,
eff_length, est_counts, and tpm. Many of the transcripts have 0 counts
and 0 TPM, while some have measurable expression levels. Overall these
files show processed transcript-level abundance summaries that can be
used for downstream expression analysis.

## Downstream analysis

``` r
library(tximport)
```

    Warning: package 'tximport' was built under R version 4.5.2

``` r
# base folder containing the *_quant directories
base_dir <- "C:/Users/huber/Downloads/quant_results"

# setup the folder and file-names to read
folders <- dir(path = base_dir, pattern = "^SRR21568.*_quant$", full.names = TRUE)
samples <- sub("_quant$", "", basename(folders))
files <- file.path(folders, "abundance.h5")
names(files) <- samples

txi.kallisto <- tximport(files, type = "kallisto", txOut = TRUE)
```

    1 2 3 4 

``` r
head(txi.kallisto$counts)
```

                    SRR2156848 SRR2156849 SRR2156850 SRR2156851
    ENST00000539570          0          0    0.00000          0
    ENST00000576455          0          0    2.62037          0
    ENST00000510508          0          0    0.00000          0
    ENST00000474471          0          1    1.00000          0
    ENST00000381700          0          0    0.00000          0
    ENST00000445946          0          0    0.00000          0

``` r
colSums(txi.kallisto$counts)
```

    SRR2156848 SRR2156849 SRR2156850 SRR2156851 
       2563611    2600800    2372309    2111474 

``` r
sum(rowSums(txi.kallisto$counts)>0)
```

    [1] 94561

``` r
to.keep <- rowSums(txi.kallisto$counts) > 0
kset.nonzero <- txi.kallisto$counts[to.keep,]

keep2 <- apply(kset.nonzero,1,sd)>0
x <- kset.nonzero[keep2,]
```

### Principal Component Analysis

``` r
pca <- prcomp(t(x), scale=TRUE)
summary(pca)
```

    Importance of components:
                                PC1      PC2      PC3   PC4
    Standard deviation     183.6379 177.3605 171.3020 1e+00
    Proportion of Variance   0.3568   0.3328   0.3104 1e-05
    Cumulative Proportion    0.3568   0.6895   1.0000 1e+00

Now we can use the first two principal components as a co-ordinate
system for visualizing the summarized transcriptomic profiles of each
sample:

``` r
plot(pca$x[,1], pca$x[,2],
     col=c("blue","blue","red","red"),
     xlab="PC1", ylab="PC2", pch=16)
```

![](class17_SRA_datasets_on_AWS_files/figure-commonmark/unnamed-chunk-3-1.png)

> Q. Use ggplot to make a similar figure of PC1 vs PC2 and a separate
> figure PC1 vs PC3 and PC2 vs PC3.

``` r
library(ggplot2)
```

    Warning: package 'ggplot2' was built under R version 4.5.2

``` r
library(ggrepel)
```

    Warning: package 'ggrepel' was built under R version 4.5.2

``` r
mycols <- c("blue","blue","red","red")

p1v2 <- ggplot(pca$x) +
  aes(PC1, PC2, label=rownames(pca$x)) +
  geom_point(col = mycols) +
  geom_text_repel(col = mycols) +
  labs(title = "PCA: PC1 vs PC2") +
  theme_bw()

p1v3 <- ggplot(pca$x) +
  aes(PC1, PC3, label=rownames(pca$x)) +
  geom_point(col = mycols) +
  geom_text_repel(col = mycols) +
  labs(title = "PCA: PC1 vs PC3") +
  theme_bw()

p2v3 <- ggplot(pca$x) +
  aes(PC2, PC3, label=rownames(pca$x)) +
  geom_point(col = mycols) +
  geom_text_repel(col = mycols) +
  labs(title = "PCA: PC2 vs PC3") +
  theme_bw()

p1v2
```

![](class17_SRA_datasets_on_AWS_files/figure-commonmark/unnamed-chunk-4-1.png)

``` r
p1v3
```

![](class17_SRA_datasets_on_AWS_files/figure-commonmark/unnamed-chunk-4-2.png)

``` r
p2v3
```

![](class17_SRA_datasets_on_AWS_files/figure-commonmark/unnamed-chunk-4-3.png)

### OPTIONAL: Differential-expression analysis

We can use DESeq2 to complete the differential-expression analysis that
we are already familiar with:

An example of creating a DESeqDataSet for use with DESeq2:

``` r
library(DESeq2)

sampleTable <- data.frame(condition = factor(rep(c("control", "treatment"), each = 2)))
rownames(sampleTable) <- colnames(txi.kallisto$counts)

dds <- DESeqDataSetFromTximport(txi.kallisto,
                                sampleTable, 
                                ~condition)

dds <- DESeq(dds)
res <- results(dds)
head(res)
```

    log2 fold change (MLE): condition treatment vs control 
    Wald test p-value: condition treatment vs control 
    DataFrame with 6 rows and 6 columns
                     baseMean log2FoldChange     lfcSE      stat    pvalue
                    <numeric>      <numeric> <numeric> <numeric> <numeric>
    ENST00000539570  0.000000             NA        NA        NA        NA
    ENST00000576455  0.761453       3.155061   4.86052 0.6491203  0.516261
    ENST00000510508  0.000000             NA        NA        NA        NA
    ENST00000474471  0.484938       0.181923   4.24871 0.0428185  0.965846
    ENST00000381700  0.000000             NA        NA        NA        NA
    ENST00000445946  0.000000             NA        NA        NA        NA
                         padj
                    <numeric>
    ENST00000539570        NA
    ENST00000576455        NA
    ENST00000510508        NA
    ENST00000474471        NA
    ENST00000381700        NA
    ENST00000445946        NA
