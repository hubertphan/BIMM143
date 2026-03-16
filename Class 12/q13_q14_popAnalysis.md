# HW Class12 Pt.2 (Population analysis) \[Q13 Q14 BoxPlot\]
Hubert Phan (PID: A17663330)

> Q13: Read this file into R and determine the sample size for each
> genotype and their corresponding median expression levels for each of
> these genotypes. Hint: The read.table(), summary() and boxplot()
> functions will likely be useful here. There is an example R script
> online to be used ONLY if you are struggling in vein. Note that you
> can find the medium value from saving the output of the boxplot()
> function to an R object and examining this object. There is also the
> medium() and summary() function that you can use to check your
> understanding.

``` r
library(dplyr)

# Read data
data <- read.table("rs8067378_ENSG00000172057.6.txt", header = TRUE)

# Find occurrence of label (genotype)
table(data$geno)
```


    A/A A/G G/G 
    108 233 121 

``` r
# corresponding median expression level for each genotype
median_expression_level <- data %>%
  group_by(geno) %>%
  summarize(median_value = median(exp, na.rm = TRUE))
median_expression_level
```

    # A tibble: 3 × 2
      geno  median_value
      <chr>        <dbl>
    1 A/A           31.2
    2 A/G           25.1
    3 G/G           20.1

> Q14: Generate a boxplot with a box per genotype, what could you infer
> from the relative expression value between A/A and G/G displayed in
> this plot? Does the SNP effect the expression of ORMDL3? Hint: An
> example boxplot is provided overleaf – yours does not need to be as
> polished as this one.

``` r
library(ggplot2)

# Create Boxplot
ggplot(data, aes(x = geno, y = exp, fill = geno)) + 
  geom_boxplot() + 
  geom_jitter(width = 0.25, alpha = 0.5, size = 1) +
  labs(
    x = "Genotype",
    y = "Expression "
  ) +
  theme_bw()
```

![](q13_q14_popAnalysis_files/figure-commonmark/unnamed-chunk-2-1.png)

**Ans:** The boxplot shows that the relative expression value is greater
for the A/A genotype compared to the G/G genotype. The SNP does seem to
affect the expression of ORMDL3 as expression levels are dependent on
genotype.
