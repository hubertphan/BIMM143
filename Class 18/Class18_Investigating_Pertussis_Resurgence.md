# Class 18 Mini Project: Investigating Pertussis Resurgence
Hubert Phan (PID: A17663330)

## 1. Investigating pertussis cases by year

> Q1. With the help of the R “addin” package datapasta assign the CDC
> pertussis case number data to a data frame called cdc and use ggplot
> to make a plot of cases numbers over time.

``` r
library(datapasta)
library(ggplot2)

cdc <- data.frame(
                          Year = c(1922L,
                                   1923L,1924L,1925L,1926L,1927L,1928L,
                                   1929L,1930L,1931L,1932L,1933L,1934L,1935L,
                                   1936L,1937L,1938L,1939L,1940L,1941L,
                                   1942L,1943L,1944L,1945L,1946L,1947L,1948L,
                                   1949L,1950L,1951L,1952L,1953L,1954L,
                                   1955L,1956L,1957L,1958L,1959L,1960L,
                                   1961L,1962L,1963L,1964L,1965L,1966L,1967L,
                                   1968L,1969L,1970L,1971L,1972L,1973L,
                                   1974L,1975L,1976L,1977L,1978L,1979L,1980L,
                                   1981L,1982L,1983L,1984L,1985L,1986L,
                                   1987L,1988L,1989L,1990L,1991L,1992L,1993L,
                                   1994L,1995L,1996L,1997L,1998L,1999L,
                                   2000L,2001L,2002L,2003L,2004L,2005L,
                                   2006L,2007L,2008L,2009L,2010L,2011L,2012L,
                                   2013L,2014L,2015L,2016L,2017L,2018L,
                                   2019L,2020L,2021L,2022L,2023L),
  No..Reported.Pertussis.Cases = c(107473,
                                   164191,165418,152003,202210,181411,
                                   161799,197371,166914,172559,215343,179135,
                                   265269,180518,147237,214652,227319,103188,
                                   183866,222202,191383,191890,109873,
                                   133792,109860,156517,74715,69479,120718,
                                   68687,45030,37129,60886,62786,31732,28295,
                                   32148,40005,14809,11468,17749,17135,
                                   13005,6799,7717,9718,4810,3285,4249,
                                   3036,3287,1759,2402,1738,1010,2177,2063,
                                   1623,1730,1248,1895,2463,2276,3589,
                                   4195,2823,3450,4157,4570,2719,4083,6586,
                                   4617,5137,7796,6564,7405,7298,7867,
                                   7580,9771,11647,25827,25616,15632,10454,
                                   13278,16858,27550,18719,48277,28639,
                                   32971,20762,17972,18975,15609,18617,6124,
                                   2116,3044,7063)
)

p <- ggplot(cdc, aes(x = Year, y = `No..Reported.Pertussis.Cases`)) +
  geom_line() +
  geom_point() +
  labs(title = "Number of Reported Pertussis Cases Over Time",
       x = "Year",
       y = "Number of Reported Pertussis Cases") +
  theme_minimal()

p
```

![](Class18_Investigating_Pertussis_Resurgence_files/figure-commonmark/unnamed-chunk-1-1.png)

## 2. A tale of two vaccines (wP & aP)

> Q2. Using the ggplot geom_vline() function add lines to your previous
> plot for the 1946 introduction of the wP vaccine and the 1996 switch
> to aP vaccine (see example in the hint below). What do you notice?

``` r
p + 
  geom_vline(xintercept = 1946, linetype = "dashed", color = "red") +
  geom_vline(xintercept = 1996, linetype = "dashed", color = "blue") +
  annotate("text", x = 1946, y = max(cdc$No..Reported.Pertussis.Cases), label = "wP", angle = 90, vjust = -0.5, color = "red") +
  annotate("text", x = 1996, y = max(cdc$No..Reported.Pertussis.Cases), label = "aP", angle = 90, vjust = -0.5, color = "blue")
```

![](Class18_Investigating_Pertussis_Resurgence_files/figure-commonmark/unnamed-chunk-2-1.png)

> Q3. Describe what happened after the introduction of the aP vaccine?
> Do you have a possible explanation for the observed trend?

**Ans:** After the introduction of the aP vaccine, there was an increase
in reported pertussis cases. One possible explanation for this trend is
that the aP vaccine may not provide as long-lasting immunity as the wP
vaccine, leading to an increase in susceptibility to pertussis over
time. Additionally, changes in diagianostic practices and bacterial
evolution could also contribute to the observed increase in cases.

## 3. Exploring CMI-PB data

### The CMI-PB API returns JSON data

Use jsonlite package to read in the CMI-PB data from the API endpoint:

``` r
library(jsonlite)

subject <- read_json("https://www.cmi-pb.org/api/subject", simplifyVector = TRUE) 

head(subject,3)
```

      subject_id infancy_vac biological_sex              ethnicity  race
    1          1          wP         Female Not Hispanic or Latino White
    2          2          wP         Female Not Hispanic or Latino White
    3          3          wP         Female                Unknown White
      year_of_birth date_of_boost      dataset
    1    1986-01-01    2016-09-12 2020_dataset
    2    1968-01-01    2019-01-28 2020_dataset
    3    1983-01-01    2016-10-10 2020_dataset

> Q4. How many aP and wP infancy vaccinated subjects are in the dataset?

``` r
table(subject$infancy_vac)
```


    aP wP 
    87 85 

**Ans:** There are 87 aP infancy vaccinated subjects and 85 wP infancy
vaccinated subjects in the dataset.

> Q5. How many Male and Female subjects/patients are in the dataset?

``` r
table(subject$biological_sex)
```


    Female   Male 
       112     60 

**Ans:** There are 112 female subjects and 60 male subjects in the
dataset.

> Q6. What is the breakdown of race and biological sex (e.g. number of
> Asian females, White males etc…)?

``` r
table(subject$biological_sex, subject$race)
```

            
             American Indian/Alaska Native Asian Black or African American
      Female                             0    32                         2
      Male                               1    12                         3
            
             More Than One Race Native Hawaiian or Other Pacific Islander
      Female                 15                                         1
      Male                    4                                         1
            
             Unknown or Not Reported White
      Female                      14    48
      Male                         7    32

### Side-Note: Working with dates

> Q7. Using this approach determine (i) the average age of wP
> individuals, (ii) the average age of aP individuals; and (iii) are
> they significantly different?

``` r
library(lubridate)
library(dplyr)
# Use todays date to calculate age in days
subject$age <- today() - ymd(subject$year_of_birth)

ap <- subject %>% filter(infancy_vac == "aP")
wp <- subject %>% filter(infancy_vac == "wP")

avg_age_wp <- mean(time_length(wp$age, "years"), na.rm = TRUE)
avg_age_ap <- mean(time_length(ap$age, "years"), na.rm = T)

print(paste("Average wP age:", avg_age_wp))
```

    [1] "Average wP age: 36.8500221443814"

``` r
print(paste("Average aP age:", avg_age_ap))
```

    [1] "Average aP age: 28.0993178975194"

``` r
# Test for statistical significance
t_test_result <- t.test(time_length(wp$age, "years"), time_length(ap$age, "years"), var.equal = TRUE)
print(t_test_result)
```


        Two Sample t-test

    data:  time_length(wp$age, "years") and time_length(ap$age, "years")
    t = 13.036, df = 170, p-value < 2.2e-16
    alternative hypothesis: true difference in means is not equal to 0
    95 percent confidence interval:
      7.425601 10.075807
    sample estimates:
    mean of x mean of y 
     36.85002  28.09932 

> Q8. Determine the age of all individuals at time of boost?

``` r
age_at_boost <- ymd(subject$date_of_boost) - ymd(subject$year_of_birth)
age_at_boost_years <- time_length(age_at_boost, "year")
head(age_at_boost_years)
```

    [1] 30.69678 51.07461 33.77413 28.65982 25.65914 28.77481

> Q9. With the help of a faceted boxplot or histogram (see below), do
> you think these two groups are significantly different?

``` r
ggplot(subject) +
  aes(time_length(age, "year"),
      fill=as.factor(infancy_vac)) +
  geom_histogram(show.legend=FALSE) +
  facet_wrap(vars(infancy_vac), nrow=2) +
  xlab("Age in years")
```

![](Class18_Investigating_Pertussis_Resurgence_files/figure-commonmark/unnamed-chunk-9-1.png)

**Ans:** The histogram does show that the two groups are significantly
different. Group aP is centered at a younger age than group wP, and
group aP has a lower spread than group wP. Furthermore, the plot shows
there is almost no overlap between the two groups.

### Joining multiple tables

Read the specimen and ab_titer tables into R and store the data as
specimen and titer named data frames.

``` r
# Complete the API URLs...
specimen <- read_json("https://www.cmi-pb.org/api/specimen", simplifyVector = TRUE) 
titer <- read_json("https://www.cmi-pb.org/api/plasma_ab_titer", simplifyVector = TRUE) 
```

> Q9. Complete the code to join specimen and subject tables to make a
> new merged data frame containing all specimen records along with their
> associated subject details:

``` r
meta <- inner_join(specimen, subject)
dim(meta)
```

    [1] 1503   14

``` r
head(meta)
```

      specimen_id subject_id actual_day_relative_to_boost
    1           1          1                           -3
    2           2          1                            1
    3           3          1                            3
    4           4          1                            7
    5           5          1                           11
    6           6          1                           32
      planned_day_relative_to_boost specimen_type visit infancy_vac biological_sex
    1                             0         Blood     1          wP         Female
    2                             1         Blood     2          wP         Female
    3                             3         Blood     3          wP         Female
    4                             7         Blood     4          wP         Female
    5                            14         Blood     5          wP         Female
    6                            30         Blood     6          wP         Female
                   ethnicity  race year_of_birth date_of_boost      dataset
    1 Not Hispanic or Latino White    1986-01-01    2016-09-12 2020_dataset
    2 Not Hispanic or Latino White    1986-01-01    2016-09-12 2020_dataset
    3 Not Hispanic or Latino White    1986-01-01    2016-09-12 2020_dataset
    4 Not Hispanic or Latino White    1986-01-01    2016-09-12 2020_dataset
    5 Not Hispanic or Latino White    1986-01-01    2016-09-12 2020_dataset
    6 Not Hispanic or Latino White    1986-01-01    2016-09-12 2020_dataset
             age
    1 14684 days
    2 14684 days
    3 14684 days
    4 14684 days
    5 14684 days
    6 14684 days

> Q10. Now using the same procedure join meta with titer data so we can
> further analyze this data in terms of time of visit aP/wP, male/female
> etc.

``` r
abdata <- inner_join(titer, meta)
dim(abdata)
```

    [1] 52576    21

> Q11. How many specimens (i.e. entries in abdata) do we have for each
> isotype?

``` r
table(abdata$isotype)
```


      IgE   IgG  IgG1  IgG2  IgG3  IgG4 
     6698  5389 10117 10124 10124 10124 

> Q12. What are the different \$dataset values in abdata and what do you
> notice about the number of rows for the most “recent” dataset?

``` r
table(abdata$dataset)
```


    2020_dataset 2021_dataset 2022_dataset 2023_dataset 
           31520         8085         7301         5670 

**Ans:** There are four different datasets. The most recent dataset has
the fewest rows. This may be due to incomplete data reporting, or
changes in data reporting. Thus, the decrease in rows does not
definitively conclude that there is a true decrease in vaccinations.

## 4. Examine IgG Ab titer levels

Now using our joined/merged/linked abdata dataset filter() for IgG
isotype.

``` r
igg <- abdata %>% filter(isotype == "IgG")
head(igg)
```

      specimen_id isotype is_antigen_specific antigen        MFI MFI_normalised
    1           1     IgG                TRUE      PT   68.56614       3.736992
    2           1     IgG                TRUE     PRN  332.12718       2.602350
    3           1     IgG                TRUE     FHA 1887.12263      34.050956
    4          19     IgG                TRUE      PT   20.11607       1.096366
    5          19     IgG                TRUE     PRN  976.67419       7.652635
    6          19     IgG                TRUE     FHA   60.76626       1.096457
       unit lower_limit_of_detection subject_id actual_day_relative_to_boost
    1 IU/ML                 0.530000          1                           -3
    2 IU/ML                 6.205949          1                           -3
    3 IU/ML                 4.679535          1                           -3
    4 IU/ML                 0.530000          3                           -3
    5 IU/ML                 6.205949          3                           -3
    6 IU/ML                 4.679535          3                           -3
      planned_day_relative_to_boost specimen_type visit infancy_vac biological_sex
    1                             0         Blood     1          wP         Female
    2                             0         Blood     1          wP         Female
    3                             0         Blood     1          wP         Female
    4                             0         Blood     1          wP         Female
    5                             0         Blood     1          wP         Female
    6                             0         Blood     1          wP         Female
                   ethnicity  race year_of_birth date_of_boost      dataset
    1 Not Hispanic or Latino White    1986-01-01    2016-09-12 2020_dataset
    2 Not Hispanic or Latino White    1986-01-01    2016-09-12 2020_dataset
    3 Not Hispanic or Latino White    1986-01-01    2016-09-12 2020_dataset
    4                Unknown White    1983-01-01    2016-10-10 2020_dataset
    5                Unknown White    1983-01-01    2016-10-10 2020_dataset
    6                Unknown White    1983-01-01    2016-10-10 2020_dataset
             age
    1 14684 days
    2 14684 days
    3 14684 days
    4 15780 days
    5 15780 days
    6 15780 days

> Q13. Complete the following code to make a summary boxplot of Ab titer
> levels (MFI) for all antigens:

``` r
ggplot(igg) +
  aes(MFI_normalised, antigen) +
  geom_boxplot() + 
    xlim(0,75) +
  facet_wrap(vars(visit), nrow=2)
```

![](Class18_Investigating_Pertussis_Resurgence_files/figure-commonmark/unnamed-chunk-16-1.png)

> Q14. What antigens show differences in the level of IgG antibody
> titers recognizing them over time? Why these and not others?

**Ans:** The antigens that show the clearest differences are FIM2/3 and
FHA. These antigens show clear shifts in antibody levels across visits,
suggesting a measurable recall response after vaccination. Antigens such
as OVA and PT show less clear differences, with more overlap between
visits. This may be because these antigens are not included in the
vaccines, and thus do not elicit a strong recall response after
vaccination or already have more consistent baseline antibody levels.

> Q15. Filter to pull out only two specific antigens for analysis and
> create a boxplot for each. You can chose any you like. Below I picked
> a “control” antigen (“OVA”, that is not in our vaccines) and a clear
> antigen of interest (“PT”, Pertussis Toxin, one of the key virulence
> factors produced by the bacterium B. pertussis).

``` r
filter(igg, antigen=="OVA") %>%
  ggplot() +
  aes(MFI_normalised, col=infancy_vac) +
  geom_boxplot(show.legend = F) +
  facet_wrap(vars(visit)) +
  theme_bw()
```

![](Class18_Investigating_Pertussis_Resurgence_files/figure-commonmark/unnamed-chunk-17-1.png)

> The same for antigen==“FIM2/3”

``` r
filter(igg, antigen=="FIM2/3") %>%
  ggplot() +
  aes(MFI_normalised, col=infancy_vac) +
  geom_boxplot(show.legend = FALSE) +
  facet_wrap(vars(visit)) +
  theme_bw()
```

![](Class18_Investigating_Pertussis_Resurgence_files/figure-commonmark/unnamed-chunk-18-1.png)

> The same for antigen==“PT”

``` r
filter(igg, antigen=="PT") %>%
  ggplot() +
  aes(MFI_normalised, col=infancy_vac) +
  geom_boxplot(show.legend = FALSE) +
  facet_wrap(vars(visit)) +
  theme_bw()
```

![](Class18_Investigating_Pertussis_Resurgence_files/figure-commonmark/unnamed-chunk-19-1.png)

> Q16. What do you notice about these two antigens time courses and the
> PT data in particular?

**Ans:** The OVA antigen shows steady antibody levels over time. There
is a lot of overlap between the aP and wP groups, with no strong time
dependent trend. On the other hand, the PT data shows a pattern of
clearer booster response: low antibody levels to start (apart from a few
outliers) marked with an increase of antibody levels overtime, and then
a decrease. This suggests PT is strongly affected by vaccination, while
OVA is not.

> Q17. Do you see any clear difference in aP vs. wP responses?

**Ans:** In the OVA data, aP and wP responses are very similar and
overlap across visits. It it only until the last few visits that the wP
responses appear to be higher than the aP responses. In the PT data, aP
and wP responses again overlap across visits, with some visits where wP
response are higher than aP responses.

Lets finish this section by looking at the 2021 dataset IgG PT antigen
levels time-course:

``` r
abdata.21 <- abdata %>% filter(dataset == "2021_dataset")

abdata.21 %>% 
  filter(isotype == "IgG",  antigen == "PT") %>%
  ggplot() +
    aes(x=planned_day_relative_to_boost,
        y=MFI_normalised,
        col=infancy_vac,
        group=subject_id) +
    geom_point() +
    geom_line() +
    geom_vline(xintercept=0, linetype="dashed") +
    geom_vline(xintercept=14, linetype="dashed") +
  labs(title="2021 dataset IgG PT",
       subtitle = "Dashed lines indicate day 0 (pre-boost) and 14 (apparent peak levels)")
```

![](Class18_Investigating_Pertussis_Resurgence_files/figure-commonmark/unnamed-chunk-20-1.png)

> Q18. Does this trend look similar for the 2020 dataset?

``` r
abdata.20 <- abdata %>% filter(dataset == "2020_dataset")

abdata.20 %>% 
  filter(isotype == "IgG",  antigen == "PT") %>%
  ggplot() +
    aes(x=planned_day_relative_to_boost,
        y=MFI_normalised,
        col=infancy_vac,
        group=subject_id) +
    geom_point() +
    geom_line() +
    geom_vline(xintercept=0, linetype="dashed") +
    geom_vline(xintercept=14, linetype="dashed") +
  labs(title="2020 dataset IgG PT",
       subtitle = "Dashed lines indicate day 0 (pre-boost) and 14 (apparent peak levels)")
```

![](Class18_Investigating_Pertussis_Resurgence_files/figure-commonmark/unnamed-chunk-21-1.png)

**Ans:** Comparing the 2020 and 2021 datasets, there is an extended
follow up period in the 2020 dataset. In addition, the PT signals appear
visually higher in the 2020 datasetfor both aP and wP groups overall.

## 5. Obtaining CMI-PB RNASeq data

``` r
url <- "https://www.cmi-pb.org/api/v2/rnaseq?versioned_ensembl_gene_id=eq.ENSG00000211896.7"

rna <- read_json(url, simplifyVector = TRUE) 
```

``` r
#meta <- inner_join(specimen, subject)
ssrna <- inner_join(rna, meta)
```

    Joining with `by = join_by(specimen_id)`

> Q19. Make a plot of the time course of gene expression for IGHG1 gene
> (i.e. a plot of visit vs. tpm).

``` r
ggplot(ssrna) +
  aes(visit, tpm, group=subject_id) +
  geom_point() +
  geom_line(alpha=0.2)
```

![](Class18_Investigating_Pertussis_Resurgence_files/figure-commonmark/unnamed-chunk-24-1.png)

> Q20.: What do you notice about the expression of this gene (i.e. when
> is it at it’s maximum level)?

**Ans:** The peak expression is found is found on visit 4. While visits
5 and 8 show spikes, these are driven by only a few outliers, while the
expression on visit 4 shows consistently high expression across most
data points.

> Q21. Does this pattern in time match the trend of antibody titer data?
> If not, why not?

**Ans:** Compared to the antibody titer data, the trend does not really
the OVA and FIM2/3 antibody trends. IGHG1 expression peaks earlier
(around visit 4), while antibody titers peak later and persist longer.
This makes sense as gene expression changes can occur more rapidly after
vaccination, while antibody production and accumulation in the blood can
take longer to reach peak levels (expression captures genes turning on,
antibody levels reflect the accumulation of antibodies/proteins over
time).

We can dig deeper and color and/or facet by infancy_vac status:

``` r
ggplot(ssrna) +
  aes(tpm, col=infancy_vac) +
  geom_boxplot() +
  facet_wrap(vars(visit))
```

![](Class18_Investigating_Pertussis_Resurgence_files/figure-commonmark/unnamed-chunk-25-1.png)

There is however no obvious wP vs. aP differences here even if we focus
in on a particular visit:

``` r
ssrna %>%  
  filter(visit==4) %>% 
  ggplot() +
    aes(tpm, col=infancy_vac) + geom_density() + 
    geom_rug() 
```

![](Class18_Investigating_Pertussis_Resurgence_files/figure-commonmark/unnamed-chunk-26-1.png)
