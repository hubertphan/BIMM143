# BIMM 143 Bioinformatics Lab Portfolio

GitHub Pages portfolio for BIMM 143 lab work.

Website: [https://hubertphan.github.io/BIMM143/](https://hubertphan.github.io/BIMM143/)

## Site structure

This repo uses a Quarto website configuration:

- `_quarto.yml` configures the GitHub Pages site
- `index.qmd` is the homepage
- `reports.qmd` is the class report index
- rendered site files are written to `docs/`

## Class reports

- [Class 4: Bioinformatics data analysis with R](class04/class04.html)
- [Class 5: Data exploration and visualization in R](class05/class05.html)
- [Class 6: R functions and R packages from CRAN and BioConductor](class06/class06.html)
- [Class 6 homework](class06/homework06.html)
- [Class 7: Introduction to machine learning for Bioinformatics](class07/class07.html)
- [Class 8: Unsupervised Learning Mini-Project](class08/Class_8_Unsupervised_Learning_Mini_Project.html)
- [Class 9: Candy Mini-Project](Class%209/Class_9_Halloween_Mini_Project.html)
- [Class 10: Structural bioinformatics](Structural_Bioinformatics/lab10_Structural_Bioinformatics.html)
- [Class 11: Structural bioinformatics - Focus on AlphaFold](class11/Class11AlphaFold.html)
- [Class 12: Population analysis](Class%2012/q13_q14_popAnalysis.html)
- [Class 13: Transcriptomics and the analysis of RNA-Seq data](Class%2013/lab13.html)
- [Class 14: RNA-Seq analysis mini-project](class%2014/class14_rnaSeqMiniProject.html)
- [Class 17: Obtaining and processing SRA datasets on AWS](Class17/class17_SRA_datasets_on_AWS.html)
- [Class 18: Investigating Pertussis Resurgence](Class%2018/Class18_Investigating_Pertussis_Resurgence.html)
- [Find-a-Gene Project](FIND_A_GENE_PROJECT/Find_a_Gene_Assignment.html)

## GitHub Pages setup

In the repository settings, publish GitHub Pages from the `main` branch and the `/docs` folder. After running `quarto render`, GitHub Pages will serve the Quarto website from `docs/index.html`.
