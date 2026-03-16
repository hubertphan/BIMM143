# Class 05: Data Visualization with GGPLOT
Hubert Phan (PID: A17663330)

- [Background](#background)
- [Common Plot Types](#common-plot-types)
- [Creating Scatter Plots](#creating-scatter-plots)
- [Gene Expression Plot](#gene-expression-plot)
- [Going Further](#going-further)

## Background

There are two ways to create visualizations in R: using base R functions
or using the ggplot2 package. Data visualizations created with ggplot2
are often more aesthetically pleasing and easier to customize than those
created with base R functions.

This is an example of making a scatter plot of the cars dataset using
base R functions and ggplot2:

``` r
head(cars,3)
```

      speed dist
    1     4    2
    2     4   10
    3     7    4

**Base R:**

``` r
plot(cars)
```

![Base R plot of the cars
dataset](class05_files/figure-commonmark/Base%20R%20plot-1.png)

**ggplot2:**

``` r
#install.packages("ggplot2")
library(ggplot2)
ggplot(cars)
```

![example ggplot2 without setting
dataset](class05_files/figure-commonmark/ggplot2%20plot%20without%20dataset-1.png)

Every ggplot needs atleast 3 things:

- A dataset
- Aesthetic mappings (aes)
- Geometric objects (geoms)

``` r
library(ggplot2)
ggplot(data = cars, aes(x = speed, y = dist)) +
  geom_point()
```

![ggplot2 scatter plot
example](class05_files/figure-commonmark/ggplot2%20plot%20with%20dataset,%20aes,%20and%20geom-1.png)

> Q1. For which phases is data visualization important in our scientific
> workflows?

**Ans:** Communication of Results, Exploratory Data Analysis (EDA), and
Detection of outliers.

> Q2. True of False? The ggplot2 package comes already installed with R?

**Ans:** False

## Common Plot Types

> Q. Which plot types are typically NOT used to compare distributions of
> numeric variables?

**Ans:** Network graphs

> Q. Which statement about data visualization with ggplot2 is incorrect?

**Ans:** ggplot2 is the only way to create plots in R

## Creating Scatter Plots

> Q. Which geometric layer should be used to create scatter plots in
> ggplot2?

**Ans:** geom_point()

Note: These next questions refer to the ggplot scatter plot created from
the cars dataset above.

> Q. In your own RStudio can you add a trend line layer to help show the
> relationship between the plot variables with the geom_smooth()
> function?

``` r
ggplot(data = cars, aes(x = speed, y = dist)) +
  geom_point() +
  geom_smooth()
```

![ggplot2 scatter plot with trend
line](class05_files/figure-commonmark/ggplot2%20scatter%20plot%20with%20trend%20line-1.png)

> Q. Argue with geom_smooth() to add a straight line from a linear model
> without the shaded standard error region?

``` r
ggplot(data = cars, aes(x = speed, y = dist)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE)
```

![ggplot2 scatter plot with linear trend
line](class05_files/figure-commonmark/ggplot2%20scatter%20plot%20with%20linear%20trend%20line-1.png)

> Q. Can you finish this plot by adding various label annotations with
> the labs() function and changing the plot look to a more conservative
> “black & white” theme by adding the theme_bw() function?

``` r
ggplot(data = cars, aes(x = speed, y = dist)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  labs(title = "Stopping Distance vs. Speed of Cars",
       x = "Speed (mph)",
       y = "Stopping Distance (ft)") +
  theme_bw()
```

![ggplot2 scatter plot with labels and black & white
theme](class05_files/figure-commonmark/ggplot2%20scatter%20plot%20with%20labels%20and%20theme-1.png)

## Gene Expression Plot

Read the expression data from the class website:

``` r
url <- "https://bioboot.github.io/bimm143_S20/class-material/up_down_expression.txt"
genes <- read.delim(url)
head(genes)
```

            Gene Condition1 Condition2      State
    1      A4GNT -3.6808610 -3.4401355 unchanging
    2       AAAS  4.5479580  4.3864126 unchanging
    3      AASDH  3.7190695  3.4787276 unchanging
    4       AATF  5.0784720  5.0151916 unchanging
    5       AATK  0.4711421  0.5598642 unchanging
    6 AB015752.4 -3.6808610 -3.5921390 unchanging

> Q. Use the nrow() function to find out how many genes are in this
> dataset. What is your answer?

``` r
nrow(genes)
```

    [1] 5196

> Q. Use the colnames() function and the ncol() function on the genes
> data frame to find out what the column names are (we will need these
> later) and how many columns there are. How many columns did you find?

``` r
colnames(genes)
```

    [1] "Gene"       "Condition1" "Condition2" "State"     

``` r
ncol(genes)
```

    [1] 4

> Q. Use the table() function on the State column of this data.frame to
> find out how many ‘up’ regulated genes there are. What is your answer?

``` r
table(genes$State)
```


          down unchanging         up 
            72       4997        127 

> Q. Using your values above and 2 significant figures. What fraction of
> total genes is up-regulated in this dataset?

``` r
total_upreg <- table(genes$State)["up"]
total_genes <- nrow(genes)
fraction_upreg <- round(total_upreg / total_genes, 2)
fraction_upreg
```

      up 
    0.02 

<u>First Expression Scatter Plot</u>

``` r
ggplot(genes, aes(x = Condition1, y = Condition2)) +
  geom_point()
```

![Gene expression scatter
plot](class05_files/figure-commonmark/First%20gene%20expression%20scatter%20plot-1.png)

<u>Second Expression Scatter Plot</u>

``` r
ggplot(genes, aes(x = Condition1, y = Condition2, color = State)) + 
  geom_point()
```

![Gene expression scatter plot colored by
State](class05_files/figure-commonmark/Second%20gene%20expression%20scatter%20plot-1.png)

<u>Third Expression Scatter Plot</u>

``` r
ggplot(genes, aes(x = Condition1, y = Condition2, color = State)) + 
  geom_point() +
  scale_color_manual(values = c("blue", "gray", "red")) +
  labs(title = "Gene Expression Changes Upon Drug Treatment",
       x = "Control (no drug)",
       y = "Drug Treatment") +
  theme_bw()
```

![Gene expression scatter plot with labels and
theme](class05_files/figure-commonmark/Third%20gene%20expression%20scatter%20plot-1.png)

## Going Further

Read the gapminder dataset:

``` r
# File location online
url <- "https://raw.githubusercontent.com/jennybc/gapminder/master/inst/extdata/gapminder.tsv"
gapminder <- read.delim(url)
head(gapminder)
```

          country continent year lifeExp      pop gdpPercap
    1 Afghanistan      Asia 1952  28.801  8425333  779.4453
    2 Afghanistan      Asia 1957  30.332  9240934  820.8530
    3 Afghanistan      Asia 1962  31.997 10267083  853.1007
    4 Afghanistan      Asia 1967  34.020 11537966  836.1971
    5 Afghanistan      Asia 1972  36.088 13079460  739.9811
    6 Afghanistan      Asia 1977  38.438 14880372  786.1134

Use dplyr to filter for the year 2007:

``` r
library(dplyr)
gapminder2007 <- gapminder %>% filter(year == 2007)
head(gapminder2007)
```

          country continent year lifeExp      pop  gdpPercap
    1 Afghanistan      Asia 2007  43.828 31889923   974.5803
    2     Albania    Europe 2007  76.423  3600523  5937.0295
    3     Algeria    Africa 2007  72.301 33333216  6223.3675
    4      Angola    Africa 2007  42.731 12420476  4797.2313
    5   Argentina  Americas 2007  75.320 40301927 12779.3796
    6   Australia   Oceania 2007  81.235 20434176 34435.3674

> Q. Complete the code below to produce a first basic scater plot of
> this gapminder_2007 dataset:

``` r
ggplot(gapminder2007, aes(x = gdpPercap, y = lifeExp)) +
  geom_point()
```

![Gapminder 2007 scatter plot of GDP per capita vs Life
Expectancy](class05_files/figure-commonmark/Basic%20gapminder%20scatter%20plot-1.png)

> Q. Can you adapt the code you have learned thus far to reproduce our
> gapminder scatter plot for the year 1957? What do you notice about
> this plot is it easy to compare with the one for 2007?

``` r
gapminder_1957 <- gapminder %>% filter(year == 1957)
ggplot(gapminder_1957, aes(x = gdpPercap, y = lifeExp)) +
  geom_point(aes(color = continent, size = pop), alpha = 0.7) + 
  scale_size_area(max_size = 15) 
```

![Gapminder scatter plot for
1957](class05_files/figure-commonmark/1957%20gapminder%20scatter%20plot-1.png)

> Q. Do the same steps above but include 1957 and 2007 in your input
> dataset for ggplot(). You should now include the layer
> facet_wrap(~year) to produce the following plot:

``` r
gapminder_5707 <- gapminder %>% filter(year == 1957 | year == 2007)
ggplot(gapminder_5707, aes(x = gdpPercap, y = lifeExp)) +
  geom_point(aes(color = continent, size = pop), alpha = 0.7) + 
  scale_size_area(max_size = 8) +
  facet_wrap(~year)
```

![Gapminder scatter plot faceted by
year](class05_files/figure-commonmark/Faceted%20gapminder%20scatter%20plot-1.png)
