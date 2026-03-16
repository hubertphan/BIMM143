# Structural Bioinformatics (Pt. 1)
Hubert Phan (PID: A17663330)

- [Introduction to the RCSB Protein Data Bank
  (PDB)](#introduction-to-the-rcsb-protein-data-bank-pdb)
  - [PDB statistics](#pdb-statistics)
  - [The PDB format](#the-pdb-format)
- [Visualizing the HIV-1 protease
  structure](#visualizing-the-hiv-1-protease-structure)
  - [Using Mol\*](#using-mol)
  - [Getting to know HIV-Pr](#getting-to-know-hiv-pr)
  - [Delving deeper](#delving-deeper)
- [Introduction to Bio3D in R](#introduction-to-bio3d-in-r)
  - [Reading PDB file data into R](#reading-pdb-file-data-into-r)
  - [Quick PDB visualization in R](#quick-pdb-visualization-in-r)
  - [Predicting functional motions of a single
    structure](#predicting-functional-motions-of-a-single-structure)
- [Comparative structure analysis of Adenylate
  Kinase](#comparative-structure-analysis-of-adenylate-kinase)
  - [Setup](#setup)
  - [Search and retrieve ADK
    structures](#search-and-retrieve-adk-structures)
  - [Align and superpose structures](#align-and-superpose-structures)
  - [Annotate collected PDB
    structures](#annotate-collected-pdb-structures)
  - [Principal component analysis](#principal-component-analysis)
- [Optional further visualization](#optional-further-visualization)
- [Normal mode analysis \[optional\]](#normal-mode-analysis-optional)

## Introduction to the RCSB Protein Data Bank (PDB)

### PDB statistics

``` r
library(tidyverse)

# Read in the PDB csv
pdb_data <- read.csv("Data Export Summary.csv")

summary(pdb_data)
```

     Molecular.Type        X.ray                EM                NMR           
     Length:6           Length:6           Length:6           Length:6          
     Class :character   Class :character   Class :character   Class :character  
     Mode  :character   Mode  :character   Mode  :character   Mode  :character  
                                                                                
                                                                                
                                                                                
      Integrative     Multiple.methods    Neutron          Other       
     Min.   :  0.00   Min.   :  0.00   Min.   : 0.00   Min.   : 0.000  
     1st Qu.:  3.25   1st Qu.:  2.50   1st Qu.: 0.00   1st Qu.: 0.000  
     Median :  6.00   Median :  9.00   Median : 0.50   Median : 0.500  
     Mean   : 63.67   Mean   : 43.33   Mean   :14.67   Mean   : 6.167  
     3rd Qu.: 20.00   3rd Qu.: 14.00   3rd Qu.: 2.50   3rd Qu.: 3.250  
     Max.   :343.00   Max.   :226.00   Max.   :84.00   Max.   :32.000  
        Total          
     Length:6          
     Class :character  
     Mode  :character  
                       
                       
                       

> **Q1:** What percentage of structures in the PDB are solved by X-Ray
> and Electron Microscopy.

``` r
# Convert relevant columns to numeric and remove commas
pdb_data$X.ray <- as.numeric(gsub(",", "", pdb_data$X.ray))
pdb_data$EM    <- as.numeric(gsub(",", "", pdb_data$EM))
pdb_data$Total <- as.numeric(gsub(",", "", pdb_data$Total))

# Sum columns
sum_xray <- sum(pdb_data$X.ray, na.rm = TRUE)
sum_EM <- sum(pdb_data$EM, na.rm = TRUE)
grandTotal <- sum(pdb_data$Total, na.rm = TRUE)

propotion_xray <- (sum_xray/grandTotal) * 100
proportion_EM <- (sum_EM/grandTotal) * 100

propotion_xray
```

    [1] 80.95077

``` r
proportion_EM
```

    [1] 12.83843

> **Q2:** What proportion of structures in the PDB are protein?

``` r
# get protein only total
protein_only <- pdb_data[pdb_data$Molecular.Type == "Protein (only)", "Total"]

proportion_protein <- protein_only / grandTotal * 100
proportion_protein
```

    [1] 85.96889

> **Q3:** Type HIV in the PDB website search box on the home page and
> determine how many HIV-1 protease structures are in the current PDB?

**Ans:** There are 756 HIV-1 protease structures in the current PDB.

### The PDB format

Download the “PDB File” for the HIV-1 protease structure with the PDB
identifier 1HSG.

## Visualizing the HIV-1 protease structure

### Using Mol\*

![HIV-1 without ligand and water
components](C:/Users/huber/Downloads/BIMM%20143/Structural%20Bioinformatics/1HSG_no_ligandwater.png)

### Getting to know HIV-Pr

Let’s temporally toggle OFF/ON the display of water molecules and change
the display representation of the Ligand to Spacefill (a.k.a VdW
spheres).

![HIV-1 with: ligand spacefill, secondary structure coloring; without:
water
component](C:/Users/huber/Downloads/BIMM%20143/Structural%20Bioinformatics/1HSG_ligandspace_2ndStrucColoring.png)

### Delving deeper

#### Cleaning up the display

Turn off the display of these positions by clicking the eye” icon for
the “Focus Surroundings (5A)” Components entry in the right side control
panel.

Now we can highlight a subset of the most important positions:

- Using the top Sequence display select position Asp 25 (D25) in one of
  the chains.
- Now activate so-called “Selection Mode” by clicking the Arrow icon
  (red box to the right side of the 3D viewer panel in the figure
  below).
- Then select the two Asp 25 positions in the 3D structure.
- Finally click the cube icon (blue box in below figure) and from the
  drop-down menu that appears select Representation Spacefill or Ball &
  Stick (whatever you prefer), then click +Create Component.

![D25 A & B
Chain](C:/Users/huber/Downloads/BIMM%20143/Structural%20Bioinformatics/1HSG_D25.png)

#### The important role of water

> **Q4:** Water molecules normally have 3 atoms. Why do we see just one
> atom per water molecule in this structure?

**Ans:** In molecular visualization software like Mol\*, water is seen
as one atom to simplify the complex molecule scene. The goal is to focus
on the overall position and how water interacts with the biological
molecule. Another reason could be that Hydrogen atoms are often
invisible in X-ray crystallography data, resulting in water being
represented as an oxygen atom.

> **Q5:** There is a critical “conserved” water molecule in the binding
> site. Can you identify this water molecule? What residue number does
> this water molecule have

There is a conserved water molecule in the binding site labeled HOH 308,
and it corresponds to residue number 308 (HOH 308).

> **Q6:** Generate and save a figure clearly showing the two distinct
> chains of HIV-protease along with the ligand. You might also consider
> showing the catalytic residues ASP 25 in each chain and the critical
> water (we recommend “Ball & Stick” for these side-chains). Add this
> figure to your Quarto document.

![D25 chains and critical water with
labels](C:/Users/huber/Downloads/BIMM%20143/Structural%20Bioinformatics/1HSG_withd25Water_labels.png)

## Introduction to Bio3D in R

### Reading PDB file data into R

Read and inspect the on-line file with PDB ID 1HSG:

``` r
library(bio3d)

pdb <- read.pdb("1hsg")
```

      Note: Accessing on-line PDB file

To get a quick summary of the contents of the pdb object you just
created you can issue the command print(pdb) or simply type pdb (which
is equivalent in this case):

``` r
pdb
```


     Call:  read.pdb(file = "1hsg")

       Total Models#: 1
         Total Atoms#: 1686,  XYZs#: 5058  Chains#: 2  (values: A B)

         Protein Atoms#: 1514  (residues/Calpha atoms#: 198)
         Nucleic acid Atoms#: 0  (residues/phosphate atoms#: 0)

         Non-protein/nucleic Atoms#: 172  (residues: 128)
         Non-protein/nucleic resid values: [ HOH (127), MK1 (1) ]

       Protein sequence:
          PQITLWQRPLVTIKIGGQLKEALLDTGADDTVLEEMSLPGRWKPKMIGGIGGFIKVRQYD
          QILIEICGHKAIGTVLVGPTPVNIIGRNLLTQIGCTLNFPQITLWQRPLVTIKIGGQLKE
          ALLDTGADDTVLEEMSLPGRWKPKMIGGIGGFIKVRQYDQILIEICGHKAIGTVLVGPTP
          VNIIGRNLLTQIGCTLNF

    + attr: atom, xyz, seqres, helix, sheet,
            calpha, remark, call

> **Q7:** How many amino acid residues are there in this pdb object?

**Ans:** There are 198 amino acid residues.

> **Q8:** Name one of the two non-protein residues?

**Ans:** HOH. This is water and there are 127 of these molecules.

> **Q9:** How many protein chains are in this structure?

**Ans:** There are two protein chains, A and B.

### Quick PDB visualization in R

Install bio3dview and NGLVieweR packages. Load the respective packages
and generate a quick NGL (webGL based) structure overview of a bio3d pdb
class object with a number of simple defaults.

``` r
library(bio3dview)
library(NGLVieweR)
```

    Warning: package 'NGLVieweR' was built under R version 4.5.2

``` r
# visualization will not generate in pdf
#view.pdb(pdb) |>
#  setSpin()
```

You can also customize the display in many ways with minimal code. For
example, lets custom color the chains and highlight some key residues as
spacefill/vdw:

``` r
# Select the important ASP 25 residue
sele <- atom.select(pdb, resno=25)


# visualization will not generate in pdf
# and highlight them in spacefill representation
#view.pdb(pdb, cols=c("navy","teal"), 
#         highlight = sele,
#         highlight.style = "spacefill") |>
#  setRock()
```

### Predicting functional motions of a single structure

Let’s read a new PDB structure of Adenylate Kinase and perform Normal
mode analysis.

``` r
adk <- read.pdb("6s36")
```

      Note: Accessing on-line PDB file
       PDB has ALT records, taking A only, rm.alt=TRUE

``` r
adk
```


     Call:  read.pdb(file = "6s36")

       Total Models#: 1
         Total Atoms#: 1898,  XYZs#: 5694  Chains#: 1  (values: A)

         Protein Atoms#: 1654  (residues/Calpha atoms#: 214)
         Nucleic acid Atoms#: 0  (residues/phosphate atoms#: 0)

         Non-protein/nucleic Atoms#: 244  (residues: 244)
         Non-protein/nucleic resid values: [ CL (3), HOH (238), MG (2), NA (1) ]

       Protein sequence:
          MRIILLGAPGAGKGTQAQFIMEKYGIPQISTGDMLRAAVKSGSELGKQAKDIMDAGKLVT
          DELVIALVKERIAQEDCRNGFLLDGFPRTIPQADAMKEAGINVDYVLEFDVPDELIVDKI
          VGRRVHAPSGRVYHVKFNPPKVEGKDDVTGEELTTRKDDQEETVRKRLVEYHQMTAPLIG
          YYSKEAEAGNTKYAKVDGTKPVAEVRADLEKILG

    + attr: atom, xyz, seqres, helix, sheet,
            calpha, remark, call

Normal mode analysis (NMA) is a structural bioinformatics method to
predict protein flexibility and potential functional motions (a.k.a.
conformational changes).

``` r
# Perform flexiblity prediction
m <- nma(adk)
```

     Building Hessian...        Done in 0.02 seconds.
     Diagonalizing Hessian...   Done in 0.16 seconds.

``` r
plot(m)
```

![](lab10_Structural_Bioinformatics_files/figure-commonmark/unnamed-chunk-9-1.png)

To view a “movie” of these predicted motions we can generate a molecular
“trajectory” with the mktrj() function.

``` r
mktrj(m, file="adk_m7.pdb")
```

## Comparative structure analysis of Adenylate Kinase

### Setup

> **Q10.** Which of the packages above is found only on BioConductor and
> not CRAN?

**Ans:** The msa package is found only in BioConductor and not CRAN.

> **Q11.** Which of the above packages is not found on BioConductor or
> CRAN?:

**Ans:** The package that is not found on BioConductor or CRAN is
bio3dview since we install it from Github.

> **Q12.** True or False? Functions from the pak package can be used to
> install packages from GitHub and BitBucket?

**Ans:** TRUE

### Search and retrieve ADK structures

``` r
library(bio3d)
aa <- get.seq("1ake_A")
```

    Fetching... Please wait. Done.

``` r
aa
```

                 1        .         .         .         .         .         60 
    pdb|1AKE|A   MRIILLGAPGAGKGTQAQFIMEKYGIPQISTGDMLRAAVKSGSELGKQAKDIMDAGKLVT
                 1        .         .         .         .         .         60 

                61        .         .         .         .         .         120 
    pdb|1AKE|A   DELVIALVKERIAQEDCRNGFLLDGFPRTIPQADAMKEAGINVDYVLEFDVPDELIVDRI
                61        .         .         .         .         .         120 

               121        .         .         .         .         .         180 
    pdb|1AKE|A   VGRRVHAPSGRVYHVKFNPPKVEGKDDVTGEELTTRKDDQEETVRKRLVEYHQMTAPLIG
               121        .         .         .         .         .         180 

               181        .         .         .   214 
    pdb|1AKE|A   YYSKEAEAGNTKYAKVDGTKPVAEVRADLEKILG
               181        .         .         .   214 

    Call:
      read.fasta(file = outfile)

    Class:
      fasta

    Alignment dimensions:
      1 sequence rows; 214 position columns (214 non-gap, 0 gap) 

    + attr: id, ali, call

> **Q13.** How many amino acids are in this sequence, i.e. how long is
> this sequence?

**Ans:** There are 214 amino acids in the sequence.

Now we can use this sequence as a query to BLAST search the PDB to find
similar sequences and structures. The function plot.blast() facilitates
the visualization and filtering of the Blast results. It will attempt to
set a seed position to the point of largest drop-off in normalized
scores (i.e. the biggest jump in E-values).

``` r
# Blast or hmmer search 
#b <- blast.pdb(aa)
# Plot a summary of search results
#hits <- plot.blast(b)
# List out some 'top hits'
#head(hits$pdb.id)

hits <- NULL
hits$pdb.id <- c('1AKE_A','6S36_A','6RZE_A','3HPR_A','1E4V_A',
                 '5EJE_A','1E4Y_A','3X2S_A','6HAP_A','6HAM_A',
                 '4K46_A','3GMT_A','4PZL_A')
```

We can now use function get.pdb() and pdbslit() to fetch and parse the
identified structures.

### Align and superpose structures

### Annotate collected PDB structures

``` r
# Vector containing PDB database codes
ids <- basename.pdb(pdbs$id)

anno <- pdb.annotate(ids)
unique(anno$source)
```

    [1] "Escherichia coli"                                
    [2] "Escherichia coli K-12"                           
    [3] "Escherichia coli O139:H28 str. E24377A"          
    [4] "Escherichia coli str. K-12 substr. MDS42"        
    [5] "Photobacterium profundum"                        
    [6] "Burkholderia pseudomallei 1710b"                 
    [7] "Francisella tularensis subsp. tularensis SCHU S4"

### Principal component analysis

``` r
# Perform PCA
pc.xray <- pca(pdbs)
plot(pc.xray)
```

![](lab10_Structural_Bioinformatics_files/figure-commonmark/unnamed-chunk-16-1.png)

``` r
# Calculate RMSD
rd <- rmsd(pdbs)
```

    Warning in rmsd(pdbs): No indices provided, using the 204 non NA positions

``` r
# Structure-based clustering
hc.rd <- hclust(dist(rd))
grps.rd <- cutree(hc.rd, k=3)

plot(pc.xray, 1:2, col="grey50", bg=grps.rd, pch=21, cex=1)
```

![](lab10_Structural_Bioinformatics_files/figure-commonmark/unnamed-chunk-17-1.png)

## Optional further visualization

To visualize the major structural variations in the ensemble the
function mktrj() can be used to generate a trajectory PDB file by
interpolating along a give PC (eigenvector):

``` r
# Visualize first principal component
pc1 <- mktrj(pc.xray, pc=1, file="pc_1.pdb")
```

View these results in Mol\*. We can also plot our main PCA results with
ggplot:

``` r
#Plotting results with ggplot2
library(ggplot2)
library(ggrepel)
```

    Warning: package 'ggrepel' was built under R version 4.5.2

``` r
df <- data.frame(PC1=pc.xray$z[,1], 
                 PC2=pc.xray$z[,2], 
                 col=as.factor(grps.rd),
                 ids=ids)

p <- ggplot(df) + 
  aes(PC1, PC2, col=col, label=ids) +
  geom_point(size=2) +
  geom_text_repel(max.overlaps = 20) +
  theme(legend.position = "none")
p
```

![](lab10_Structural_Bioinformatics_files/figure-commonmark/unnamed-chunk-19-1.png)

## Normal mode analysis \[optional\]

Function nma() provides normal mode analysis (NMA) on both single
structures (if given a singe PDB input object) or the complete structure
ensemble (if provided with a PDBS input object). This facilitates
characterizing and comparing flexibility profiles of related protein
structures.

``` r
# NMA of all structures
modes <- nma(pdbs)
```


    Details of Scheduled Calculation:
      ... 13 input structures 
      ... storing 606 eigenvectors for each structure 
      ... dimension of x$U.subspace: ( 612x606x13 )
      ... coordinate superposition prior to NM calculation 
      ... aligned eigenvectors (gap containing positions removed)  
      ... estimated memory usage of final 'eNMA' object: 36.9 Mb 


      |                                                                            
      |                                                                      |   0%
      |                                                                            
      |=====                                                                 |   8%
      |                                                                            
      |===========                                                           |  15%
      |                                                                            
      |================                                                      |  23%
      |                                                                            
      |======================                                                |  31%
      |                                                                            
      |===========================                                           |  38%
      |                                                                            
      |================================                                      |  46%
      |                                                                            
      |======================================                                |  54%
      |                                                                            
      |===========================================                           |  62%
      |                                                                            
      |================================================                      |  69%
      |                                                                            
      |======================================================                |  77%
      |                                                                            
      |===========================================================           |  85%
      |                                                                            
      |=================================================================     |  92%
      |                                                                            
      |======================================================================| 100%

``` r
plot(modes, pdbs, col=grps.rd)
```

    Extracting SSE from pdbs$sse attribute

![](lab10_Structural_Bioinformatics_files/figure-commonmark/unnamed-chunk-20-1.png)

> **Q14.** What do you note about this plot? Are the black and colored
> lines similar or different? Where do you think they differ most and
> why?

Overall, the black and colored lines are generally similar. This
suggests that the proteins share similar structure and dynamics. The
lines differ the most around the 40-60 and 130-160 residue regions.
These regions most likely correspond to flexible surface loops that are
not essential to maintaining general protein functionality.
