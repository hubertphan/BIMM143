# Class 8: Unsupervised Learning Mini-Project
Hubert Phan (PID: A17663330)

- [Exploratory data analysis](#exploratory-data-analysis)
  - [Preparing the data](#preparing-the-data)
  - [Exploratory data analysis](#exploratory-data-analysis-1)
- [Principal Component Analysis](#principal-component-analysis)
  - [Interpreting PCA results](#interpreting-pca-results)
  - [Variance explained](#variance-explained)
  - [Communicating PCA results](#communicating-pca-results)
- [Hierarchical clustering](#hierarchical-clustering)
  - [Results of hierarchical
    clustering](#results-of-hierarchical-clustering)
  - [Selecting number of clusters](#selecting-number-of-clusters)
  - [Using different methods](#using-different-methods)
- [Combining methods](#combining-methods)
  - [Clustering on PCA results](#clustering-on-pca-results)
- [Sensitivity/Specificity](#sensitivityspecificity)
- [Prediction](#prediction)

## Exploratory data analysis

### Preparing the data

``` r
# Save your input data file into your Project directory
fna.data <- "WisconsinCancer.csv"

# Complete the following code to input the data and store as wisc.df
wisc.df <- read.csv(fna.data, row.names=1)

# Examine df
head(wisc.df, 4)

# Remove diagnosis column for clustering
wisc.df <- wisc.df[ , -1]

# Create diagnosis vector for later 
diagnosis <- as.factor(read.csv(fna.data)$diagnosis)
```

### Exploratory data analysis

> **Q1.** How many observations are in this dataset?

``` r
nrow(wisc.df)
```

    [1] 569

> **Q2.** How many of the observations have a malignant diagnosis?

``` r
sum(diagnosis == "M")
```

    [1] 212

> **Q3.** How many variables/features in the data are suffixed with
> \_mean?

``` r
# Check which colname contains "_mean"
mean_cols <- grep("_mean$", colnames(wisc.df))
length(mean_cols)
```

    [1] 10

## Principal Component Analysis

Check the mean and standard deviation of the features (i.e. columns) of
the wisc.data to determine if the data should be scaled.

``` r
# hide results, show CV calculation only
# Check column means and standard deviations
colMeans(wisc.df)

#STANDARD DEVIATION
apply(wisc.df, 2, sd)
```

``` r
#consider applying CV rule to determine if scaling is necessary
#say that the rule is that if most of CV > 0.3, then scaling is necessary
cv <- apply(wisc.df, 2, sd) / colMeans(wisc.df)
cv
```

                radius_mean            texture_mean          perimeter_mean 
                  0.2494497               0.2229712               0.2642083 
                  area_mean         smoothness_mean        compactness_mean 
                  0.5373645               0.1459536               0.5061555 
             concavity_mean     concave.points_mean           symmetry_mean 
                  0.8977525               0.7932036               0.1513248 
     fractal_dimension_mean               radius_se              texture_se 
                  0.1124304               0.6844320               0.4533400 
               perimeter_se                 area_se           smoothness_se 
                  0.7054476               1.1277714               0.4264347 
             compactness_se            concavity_se       concave.points_se 
                  0.7028841               0.9464579               0.5230768 
                symmetry_se    fractal_dimension_se            radius_worst 
                  0.4024073               0.6972696               0.2970794 
              texture_worst         perimeter_worst              area_worst 
                  0.2393661               0.3132777               0.6465681 
           smoothness_worst       compactness_worst         concavity_worst 
                  0.1724913               0.6187893               0.7664699 
       concave.points_worst          symmetry_worst fractal_dimension_worst 
                  0.5735495               0.2132805               0.2151539 

``` r
#look at summary statistics of CV
summary(cv)
```

       Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
     0.1124  0.2419  0.4797  0.4869  0.6941  1.1278 

Based on the results above, the data should be scaled before performing
PCA.

``` r
# perform PCA on the wisc.df data frame, scaling the variables
wisc.pr <- prcomp( wisc.df, center = TRUE, scale. = TRUE)

# Look at summary of results
summary(wisc.pr)
```

    Importance of components:
                              PC1    PC2     PC3     PC4     PC5     PC6     PC7
    Standard deviation     3.6444 2.3857 1.67867 1.40735 1.28403 1.09880 0.82172
    Proportion of Variance 0.4427 0.1897 0.09393 0.06602 0.05496 0.04025 0.02251
    Cumulative Proportion  0.4427 0.6324 0.72636 0.79239 0.84734 0.88759 0.91010
                               PC8    PC9    PC10   PC11    PC12    PC13    PC14
    Standard deviation     0.69037 0.6457 0.59219 0.5421 0.51104 0.49128 0.39624
    Proportion of Variance 0.01589 0.0139 0.01169 0.0098 0.00871 0.00805 0.00523
    Cumulative Proportion  0.92598 0.9399 0.95157 0.9614 0.97007 0.97812 0.98335
                              PC15    PC16    PC17    PC18    PC19    PC20   PC21
    Standard deviation     0.30681 0.28260 0.24372 0.22939 0.22244 0.17652 0.1731
    Proportion of Variance 0.00314 0.00266 0.00198 0.00175 0.00165 0.00104 0.0010
    Cumulative Proportion  0.98649 0.98915 0.99113 0.99288 0.99453 0.99557 0.9966
                              PC22    PC23   PC24    PC25    PC26    PC27    PC28
    Standard deviation     0.16565 0.15602 0.1344 0.12442 0.09043 0.08307 0.03987
    Proportion of Variance 0.00091 0.00081 0.0006 0.00052 0.00027 0.00023 0.00005
    Cumulative Proportion  0.99749 0.99830 0.9989 0.99942 0.99969 0.99992 0.99997
                              PC29    PC30
    Standard deviation     0.02736 0.01153
    Proportion of Variance 0.00002 0.00000
    Cumulative Proportion  1.00000 1.00000

> **Q4.** From your results, what proportion of the original variance is
> captured by the first principal component (PC1)?

**Ans:** Proportion of variance: 0.4427

> **Q5.** How many principal components (PCs) are required to describe
> at least 70% of the original variance in the data?

**Ans:** At least 3 PCs are required to describe at least 70% of the
original variance in the data.

> **Q6.** How many principal components (PCs) are required to describe
> at least 90% of the original variance in the data?

**Ans:** At least 7 PCs are required to describe at least 90% of the
original variance in the data.

### Interpreting PCA results

Create a biplot of the wisc.pr using the biplot() function.

``` r
# Create biplot of PCA results
biplot(wisc.pr, scale = 0)
```

![](Class_8_Unsupervised_Learning_Mini_Project_files/figure-commonmark/unnamed-chunk-8-1.png)

> **Q7.** What stands out to you about this plot? Is it easy or
> difficult to understand? Why?

**Ans:** What stands out is that the plot is quite cluttered with many
points, making it difficult to interpret. I am unsure of where the
points lie and which labels correspond to which points.

Lets generate a more standard scatter plot of each observation along
principal components 1 and 2 (i.e. a plot of PC1 vs PC2 available as the
first two columns of wisc.pr\$x) and color the points by the diagnosis
(available in the diagnosis vector you created earlier).

``` r
# Scatter plot observations by components 1 and 2
library(ggplot2)
```

    Warning: package 'ggplot2' was built under R version 4.5.2

``` r
ggplot(wisc.pr$x) +
  aes(x = PC1, y = PC2, col=diagnosis) +
  geom_point()
```

![](Class_8_Unsupervised_Learning_Mini_Project_files/figure-commonmark/unnamed-chunk-9-1.png)

> **Q8.** Generate a similar plot for principal components 1 and 3. What
> do you notice about these plots?

``` r
# Scatter plot observations by components 1 and 3
library(ggplot2)

ggplot(wisc.pr$x) +
  aes(x = PC1, y = PC3, col=diagnosis) +
  geom_point()
```

![](Class_8_Unsupervised_Learning_Mini_Project_files/figure-commonmark/warning-%20false,%20message-%20false-1.png)

**Ans:** There is greater variability among malignant samples along PC3
compared to PC2. PC3 primarily captures variability within diagnosis
groups rather than separation between benign and malignant samples.
While PC1 shows clear separation between diagnoses, the increased spread
observed in PC3 reflects greater within-class heterogeneity among
malignant samples.

### Variance explained

Calculate the variance of each principal component by squaring the sdev
component of wisc.pr (i.e. wisc.pr\$sdev^2). Save the result as an
object called pr.var.

``` r
# Calculate variance of each component
pr.var <- wisc.pr$sdev^2
head(pr.var)
```

    [1] 13.281608  5.691355  2.817949  1.980640  1.648731  1.207357

Calculate the variance explained by each principal component by dividing
by the total variance explained of all principal components. Assign this
to a variable called pve and create a plot of variance explained for
each principal component.

``` r
# Variance explained by each principal component: pve
pve <- pr.var / sum(pr.var)

# Plot variance explained for each principal component
plot(c(1,pve), xlab = "Principal Component", 
     ylab = "Proportion of Variance Explained", 
     ylim = c(0, 1), type = "o")
```

![](Class_8_Unsupervised_Learning_Mini_Project_files/figure-commonmark/unnamed-chunk-11-1.png)

``` r
# Alternative scree plot of the same data, note data driven y-axis
barplot(pve, ylab = "Percent of Variance Explained",
     names.arg=paste0("PC",1:length(pve)), las=2, axes = FALSE)
axis(2, at=pve, labels=round(pve,2)*100 )
```

![](Class_8_Unsupervised_Learning_Mini_Project_files/figure-commonmark/unnamed-chunk-12-1.png)

### Communicating PCA results

> **Q9.** For the first principal component, what is the component of
> the loading vector (i.e. wisc.pr\$rotation\[,1\]) for the feature
> concave.points_mean? This tells us how much this original feature
> contributes to the first PC. Are there any features with larger
> contributions than this one?

``` r
# Obtain concave.points_mean for PC1 loading vector
wisc.pr$rotation["concave.points_mean",1]
```

    [1] -0.2608538

``` r
# look at largest magnitude point_mean among all PC
# Absolute loadings for concave.points_mean across all PCs
abs_loadings <- abs(wisc.pr$rotation["concave.points_mean", ])

# Find PC with largest absolute contribution
pc_max <- colnames(wisc.pr$rotation)[which.max(abs_loadings)]

# Obtain max 
max_loading <- abs_loadings[pc_max]

pc_max
```

    [1] "PC27"

``` r
max_loading
```

         PC27 
    0.4546994 

**Ans:** Although concave.points_mean has a large loading magnitude on
PC27, PC27 still has very little overall variance. Therefore, PC27 is
biologically less important than PC1, which has substantially more
variance and drives separation between benign and malignant samples.

## Hierarchical clustering

First scale the wisc.data data and assign the result to data.scaled.

``` r
# Scale the wisc.data data using the "scale()" function
data.scaled <- scale(wisc.df)
```

Next, calculate the (Euclidean) distances between all pairs of
observations in the new scaled dataset and assign the result to
data.dist.

``` r
data.dist <- dist(data.scaled, method = "euclidean")
```

Create a hierarchical clustering model using complete linkage. Manually
specify the method argument to hclust() and assign the results to
wisc.hclust.

``` r
wisc.hclust <- hclust(data.dist, method = "complete")
```

### Results of hierarchical clustering

> **Q10.** Using the plot() and abline() functions, what is the height
> at which the clustering model has 4 clusters?

``` r
plot(wisc.hclust)
abline(h = 20, col="red", lty=2)
```

![](Class_8_Unsupervised_Learning_Mini_Project_files/figure-commonmark/unnamed-chunk-18-1.png)

``` r
# Confirm 4 groups with cutree
table(cutree(wisc.hclust, h = 20))
```


      1   2   3   4 
    177   7 383   2 

### Selecting number of clusters

Use cutree() to cut the tree so that it has 4 clusters. Assign the
output to the variable wisc.hclust.clusters.

``` r
wisc.hclust.clusters <- cutree(wisc.hclust, h = 20)
```

We can use the table() function to compare the cluster membership to the
actual diagnoses.

``` r
table(wisc.hclust.clusters, diagnosis)
```

                        diagnosis
    wisc.hclust.clusters   B   M
                       1  12 165
                       2   2   5
                       3 343  40
                       4   0   2

> **Q11.** OPTIONAL: Can you find a better cluster vs diagnoses match by
> cutting into a different number of clusters between 2 and 6? How do
> you judge the quality of your result in each case?

``` r
# Cut into 2 clusters
wisc.hclust.clusters2 <- cutree(wisc.hclust, k = 2)
table(wisc.hclust.clusters2, diagnosis)
```

                         diagnosis
    wisc.hclust.clusters2   B   M
                        1 357 210
                        2   0   2

``` r
# Cut into 6 clusters
wisc.hclust.clusters6 <- cutree(wisc.hclust, k = 6)
table(wisc.hclust.clusters6, diagnosis)
```

                         diagnosis
    wisc.hclust.clusters6   B   M
                        1  12 165
                        2   0   5
                        3 331  39
                        4   2   0
                        5  12   1
                        6   0   2

**Ans:** Based on the known diagnosis classes, clustering quality should
be judged by comparing cluster assignments to known labels, with better
results showing clusters dominated by a certain diagnosis. Furthermore,
increasing the number of clusters should be examined carefully as over
segmentation sometimes doesn’t represent true diagnostic separation.

### Using different methods

> **Q12.** Which method gives your favorite results for the same
> data.dist dataset? Explain your reasoning.

**Ans:** For the data.dist dataset, Ward.D2 is optimal because it forms
compact, low variance clusters that favor the diagnosis class-like
structure of the data. Ward.D2 also produces clusters with higher purity
and clearer interpretability than the other methods which either
over-chain points or do not explicitly optimize variance.

## Combining methods

### Clustering on PCA results

So far we have tried PCA and hierarchical clustering separately. Now
let’s combine them: cluster on the PC scores instead of the original 30
features.

Using the minimum number of principal components required to describe at
least 90% of the variability in the data, create a hierarchical
clustering model with the linkage method=“ward.D2”. We use Ward’s
criterion here because it is based on multidimensional variance like
principal components analysis. Assign the results to wisc.pr.hclust.

``` r
# Create data.pc.dist. Only consider the first 7 PC
data.pc <- wisc.pr$x[, 1:7] # take first 7 PC scores
data.pc.dist <- dist(data.pc) # Euclidean distance on PC scores
# Hierarchal Clustering with ward.D2
wisc.pr.hclust <- hclust(data.pc.dist, method = "ward.D2")
```

``` r
plot(wisc.pr.hclust)
```

![](Class_8_Unsupervised_Learning_Mini_Project_files/figure-commonmark/unnamed-chunk-23-1.png)

Group data, compare cluster assignments to labels, and re-examine PC1
vs. PC2 with new grouping

``` r
wisc.pr.hclust.clusters <- cutree(wisc.pr.hclust, k=2)
table(wisc.pr.hclust.clusters)
```

    wisc.pr.hclust.clusters
      1   2 
    216 353 

``` r
table(wisc.pr.hclust.clusters , diagnosis)
```

                           diagnosis
    wisc.pr.hclust.clusters   B   M
                          1  28 188
                          2 329  24

``` r
ggplot(wisc.pr$x) +
  aes(PC1, PC2) +
  geom_point(col=wisc.pr.hclust.clusters)
```

![](Class_8_Unsupervised_Learning_Mini_Project_files/figure-commonmark/unnamed-chunk-24-1.png)

> **Q13.** How well does the newly created hclust model with two
> clusters separate out the two “M” and “B” diagnoses?

``` r
# Compare to actual diagnoses
table(wisc.pr.hclust.clusters , diagnosis)
```

                           diagnosis
    wisc.pr.hclust.clusters   B   M
                          1  28 188
                          2 329  24

**Ans:** The newly created hclust model produces clusters that are
either dominated by “M” or “B” diagnoses. This indicates improved
alignment with diagnosis class structure.

> **Q14.** How well do the hierarchical clustering models you created in
> the previous sections (i.e. without first doing PCA) do in terms of
> separating the diagnoses? Again, use the table() function to compare
> the output of each model (wisc.hclust.clusters and
> wisc.pr.hclust.clusters) with the vector containing the actual
> diagnoses.

``` r
# compare wisc.hclust.clusters cluster with label
table(wisc.hclust.clusters, diagnosis)
```

                        diagnosis
    wisc.hclust.clusters   B   M
                       1  12 165
                       2   2   5
                       3 343  40
                       4   0   2

``` r
# compare wisc.pr.hclust.clusters clusters with label
table(wisc.pr.hclust.clusters, diagnosis)
```

                           diagnosis
    wisc.pr.hclust.clusters   B   M
                          1  28 188
                          2 329  24

**Ans:** The hierarchical clustering on the original features shows
greater mixing of diagnosis across clusters, indicating weaker
separation by diagnosis. The clustering on the PCA specific data
produces clusters that are dominated by a single diagnosis, indicating
better separation after applying PCA. We can conclude the PCA cleans our
data which allows the clustering to better resemble biological
structure.

## Sensitivity/Specificity

> **Q15.** OPTIONAL: Which of your analysis procedures resulted in a
> clustering model with the best specificity? How about sensitivity?

``` r
#create sensitivity and specificity functions
#create function to determine majority cluster label
#Find TP,FN,TN,FP
#compare PCA approach vs original features

sensitivity <- function(TP, FN) {
  if ((TP + FN) == 0) return(NA_real_)
  TP / (TP + FN)
}

specificity <- function(TN, FP) {
  if ((TN + FP) == 0) return(NA_real_)
  TN / (TN + FP)
}

# Function to assign cluster labels by majority class
assign_cluster_labels <- function(clusters, true_labels) {
  # Create contingency table
  tab <- table(clusters, true_labels)
  
  # Assign each cluster the label with the highest count
  cluster_labels <- apply(tab, 1, function(x) {
    names(which.max(x))
  })
  
  return(cluster_labels)
}
evaluate_clustering <- function(clusters, true_labels) {
  # Assign cluster labels by majority vote
  cluster_labels <- assign_cluster_labels(clusters, true_labels)
  
  # Predicted label for each observation
  predicted_labels <- cluster_labels[as.character(clusters)]
  
  # Confusion matrix
  conf_mat <- table(Predicted = predicted_labels, Actual = true_labels)
  
  # Extract confusion matrix components
  TP <- conf_mat["M", "M"]
  FN <- conf_mat["B", "M"]
  TN <- conf_mat["B", "B"]
  FP <- conf_mat["M", "B"]
  
  # Compute metrics
  sens <- sensitivity(TP, FN)
  spec <- specificity(TN, FP)
  
  # Return results
  list(
    confusion_matrix = conf_mat,
    sensitivity = sens,
    specificity = spec
  )
}
```

``` r
# Do analysis on pca approach
results_pca <- evaluate_clustering(
  clusters = wisc.pr.hclust.clusters,
  true_labels = diagnosis
)

results_pca$confusion_matrix
```

             Actual
    Predicted   B   M
            B 329  24
            M  28 188

``` r
results_pca$sensitivity
```

    [1] 0.8867925

``` r
results_pca$specificity
```

    [1] 0.9215686

``` r
#do analysis on original features
results_original <- evaluate_clustering(
  clusters = wisc.hclust.clusters,
  true_labels = diagnosis
)

results_original$confusion_matrix
```

             Actual
    Predicted   B   M
            B 343  40
            M  14 172

``` r
results_original$sensitivity
```

    [1] 0.8113208

``` r
results_original$specificity
```

    [1] 0.9607843

**Ans:** Hierarchical clustering on PCA scores improved sensitivity
(0.8867925 vs 0.8113208), indicating better grouping of malignant
samples, while clustering on the original features showed slightly
higher specificity (0.9607843 vs 0.9215686).

## Prediction

We will use the predict() function that will take our PCA model from
before and new cancer cell data and project that data onto our PCA
space.

``` r
#url <- "new_samples.csv"
url <- "https://tinyurl.com/new-samples-CSV"
new <- read.csv(url)
npc <- predict(wisc.pr, newdata=new)
npc
```

               PC1       PC2        PC3        PC4       PC5        PC6        PC7
    [1,]  2.576616 -3.135913  1.3990492 -0.7631950  2.781648 -0.8150185 -0.3959098
    [2,] -4.754928 -3.009033 -0.1660946 -0.6052952 -1.140698 -1.2189945  0.8193031
                PC8       PC9       PC10      PC11      PC12      PC13     PC14
    [1,] -0.2307350 0.1029569 -0.9272861 0.3411457  0.375921 0.1610764 1.187882
    [2,] -0.3307423 0.5281896 -0.4855301 0.7173233 -1.185917 0.5893856 0.303029
              PC15       PC16        PC17        PC18        PC19       PC20
    [1,] 0.3216974 -0.1743616 -0.07875393 -0.11207028 -0.08802955 -0.2495216
    [2,] 0.1299153  0.1448061 -0.40509706  0.06565549  0.25591230 -0.4289500
               PC21       PC22       PC23       PC24        PC25         PC26
    [1,]  0.1228233 0.09358453 0.08347651  0.1223396  0.02124121  0.078884581
    [2,] -0.1224776 0.01732146 0.06316631 -0.2338618 -0.20755948 -0.009833238
                 PC27        PC28         PC29         PC30
    [1,]  0.220199544 -0.02946023 -0.015620933  0.005269029
    [2,] -0.001134152  0.09638361  0.002795349 -0.019015820

``` r
plot(wisc.pr$x[,1:2], col=wisc.pr.hclust.clusters)
points(npc[,1], npc[,2], col="blue", pch=16, cex=3)
text(npc[,1], npc[,2], c(1,2), col="white")
```

![](Class_8_Unsupervised_Learning_Mini_Project_files/figure-commonmark/unnamed-chunk-31-1.png)

> **Q16.** Which of these new patients should we prioritize for follow
> up based on your results?

**Ans:** Patient 2 should be prioritized as their PCA projection aligns
with malignant samples while patient 1 aligns with benign samples.
