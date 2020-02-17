False Positives
================
Pietro Franceschi
4 February 2019

This first demo deals with “random organization”. Asw we discussed in
the lecture, an experiment is always performed on a subset of the
population, so a measured “organization”

  - can mirror a population level characteristics
  - can be the result of a “unlucky” sampling

To undertand the second point, just consider an hypothetic sampling of
the human population made by an extraterrestrial entity. If he random
sample a couple of humans, it will likely conclude that we are all
chinese\!

Let’s make a more scientific example. Let’s create a fake proteomics
experiment where I’m measuring the concentration of 1000 proteins on a
group of 20 samples. And let’s suppose that I want to study the
correlation between the different proteins to infer new regulatory
networks …

To simulate a dummy experiment I will fill my expression matrix with
random numbers …

``` r
## Random expression data matrix

DM <- matrix(rnorm(20000), nrow = 20)
dim(DM)
```

    ## [1]   20 1000

That’s the data matrix. Is there true organization there? NO\!

Let’s calculate the correlation among the different proteins …

``` r
mycorr <- cor(DM)
dim(mycorr)
```

    ## [1] 1000 1000

Now we get only the upper triangle of the matrix and we look to the
distribution of the correlation coefficients

``` r
hist(mycorr[upper.tri(mycorr)], 
     col = "steelblue", 
     breaks = 100,
     main = "Random Correlations")
```

![](figs/falseposunnamed-chunk-2-1.png)<!-- -->

Unexpectedly ( ;-) ) … we also have high correlation variables\! The
code below gives you the indices of the variables showing high
correlation, excluding the 1s

``` r
highcorrid <- which(mycorr > 0.8 & mycorr != 1, arr.ind = TRUE)
highcorrid
```

    ##       row col
    ##  [1,] 454  35
    ##  [2,] 438  41
    ##  [3,] 818  55
    ##  [4,] 808  67
    ##  [5,] 899  82
    ##  [6,] 117  90
    ##  [7,]  90 117
    ##  [8,] 783 206
    ##  [9,] 711 273
    ## [10,] 468 376
    ## [11,] 941 391
    ## [12,]  41 438
    ## [13,]  35 454
    ## [14,] 376 468
    ## [15,] 604 495
    ## [16,] 847 535
    ## [17,] 495 604
    ## [18,] 934 658
    ## [19,] 273 711
    ## [20,] 800 746
    ## [21,] 206 783
    ## [22,] 746 800
    ## [23,]  67 808
    ## [24,]  55 818
    ## [25,] 535 847
    ## [26,]  82 899
    ## [27,] 658 934
    ## [28,] 391 941

``` r
plot(DM[,highcorrid[1,1]],DM[,highcorrid[1,2]], col = "darkred", pch = 19, cex = 2)
```

![](figs/falseposunnamed-chunk-4-1.png)<!-- -->

Here the presence of high correlation is clear\!\!\! But this
correlation does not have a “biological” origin … so it does not
represent a truly scientific result …
