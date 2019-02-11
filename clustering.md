Clustering
================
Pietro Franceschi
January 28, 2018

# Clustering

## On covariance

Before running into clustering, let’s give a look on the meaning of
covariance, a graphical representation is, as usual, useful

``` r
## this library is used to create multivariate clusters of normal shape
library(mvtnorm)

## Generate the two classes for the toy dataset
g1 <- rmvnorm(1000, mean = c(3, 3), sigma = matrix(c(1, 0, 0, 2), nrow = 2))
g2 <- rmvnorm(1000, mean = c(3, 3), sigma = matrix(c(1, 1, 1, 2), nrow = 2))

par(mfrow = c(1,2))
plot(g1)
plot(g2)
```

![](figs/clusteringunnamed-chunk-1-1.png)<!-- -->

## Agglomerative Clustering

### The Toy dataset

We start from an easy two class example in two variables. As usual here
we have more samples than variables, so the picture will be easier
because the space is not really empty.

``` r
## two groups with different covariance shapes ...
g1 <- rmvnorm(20, mean = c(3, 3), sigma = matrix(c(1, 0, 0, 2), nrow = 2))
g2 <- rmvnorm(20, mean = c(8, 8), sigma = matrix(c(1, 1, 1, 2), nrow = 2))

## let's plot the two groups in the 2D plane
toydata <- rbind(g1,g2)
rownames(toydata) <- paste0(rep(1:20, times = 2),rep(c("A","B"),each = 20))
classes <- rep(c(1,2), each = 20)
plot(toydata, pch = classes, col = classes, xlab = "Var 1", ylab = "Var 2")
```

![](figs/clusteringunnamed-chunk-2-1.png)<!-- -->

As discussed in the presentation, to perform clustering it is necessary
to define a distance measure Let’s look to the matrix and is size for
the toy dataset

``` r
## calculate the distance matrix between all the elements
toy.dist <- dist(toydata)
summary(toy.dist)
```

    ##     Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
    ##  0.07405  2.15579  4.75826  5.00268  7.47248 16.18478

``` r
dim(as.matrix(toy.dist))
```

    ## [1] 40 40

``` r
library(factoextra)
```

    ## Loading required package: ggplot2

    ## Welcome! Related Books: `Practical Guide To Cluster Analysis in R` at https://goo.gl/13EFCZ

``` r
fviz_dist(toy.dist)
```

![](figs/clusteringunnamed-chunk-4-1.png)<!-- -->

We have clearly two groups, but this is what we expect

Agglomerative clustering in R can be performed without additional
packages, the results is a dendrogram

``` r
toy.complete <- hclust(toy.dist)

## plot it
fviz_dend(toy.complete,
          cex = 0.5,       ## size of the text
          k = 2,
          rect = TRUE)
```

![](figs/clusteringunnamed-chunk-5-1.png)<!-- -->

As expected, in this easy example, the dendrogram shows two clear
groups, which coincide with the initial classes

This is the effect of a change in linkage

``` r
toy.single <- hclust(toy.dist, method = "single")
## plot it
fviz_dend(toy.single,
          cex = 0.5,       ## size of the text
          k = 2,
          rect = TRUE)
```

![](figs/clusteringunnamed-chunk-6-1.png)<!-- -->

Also in this case the two groups structure is clear, but, another time,
remember that this is a really easy case.

The dendrogram can be cut at different levels. In a “segmentation”
problem the number is fixed (the question is: “I want to divide my
dataset in x groups”), but normally finding the “right” number of
clusters is not at all easy. In R the commands useful to process the
dendrogram are the following

``` r
## to cut the cluster and get the cluster labels ...
mycut <- cutree(toy.complete, h = 8)

## to get a visual feedback ... 
table(mycut,classes)
```

    ##      classes
    ## mycut  1  2
    ##     1 20  0
    ##     2  0 19
    ##     3  0  1

As discussed in the lecture, if he dendrogram gives a good
representation of the distribution of the points in the space, the
cophenetic distance (the on ecalculated on the dendrogram) should be
highly correlated with the “overall” distance

``` r
res.coph <- cophenetic(toy.complete)

cor(toy.dist, res.coph)
```

    ## [1] 0.853719

Which here is indeed the case.

## The Iris dataset

Let’s move to the Iris dataset

``` r
data("iris")
```

now we look to the dendrogram obtained by HC

``` r
iris.complete <- hclust(dist(iris[,1:4]))
## plot it
fviz_dend(iris.complete,
          cex = 0.5,       ## size of the text
          k = 2,
          rect = TRUE)
```

    ## Warning in data.frame(xmin = unlist(xleft), ymin = unlist(ybottom), xmax =
    ## unlist(xright), : row names were found from a short variable and have been
    ## discarded

![](figs/clusteringunnamed-chunk-10-1.png)<!-- -->

Beyond aesthetics, we already see that here the situation is less clear
than before. How many groups? In addition the scaling of the variables
could also make a difference …

``` r
iris.complete.s <- hclust(dist(scale(iris[,1:4])))
## plot it
fviz_dend(iris.complete.s,
          cex = 0.5,       ## size of the text
          k = 2,
          rect = TRUE)
```

    ## Warning in data.frame(xmin = unlist(xleft), ymin = unlist(ybottom), xmax =
    ## unlist(xright), : row names were found from a short variable and have been
    ## discarded

![](figs/clusteringunnamed-chunk-11-1.png)<!-- -->

Is this what you expect? In this case we do know the “label” of the
different samples so we can visualiza them quite easily …

``` r
iris.complete.s$labels <- as.character(iris$Species)

fviz_dend(iris.complete.s,
          cex = 0.5,       ## size of the text
          k = 3,           ## three groups
          rect = TRUE, 
          show_labels = TRUE,
          k_colors = c("#1B9E77", "#D95F02", "#7570B3"),      ## colors for the branches
          label_cols =  as.numeric(iris$Species)[iris.complete.s$order])    ## color for the labels
```

![](figs/clusteringunnamed-chunk-12-1.png)<!-- -->

## Partitional Clustering

In the case of partitional clustering we will follow the same path.
Starting from the toy data, down to the iris data. To visualize some of
the results, the `facroextra` package can be also used.

## The Toy dataset

As a first step let’s use **k-mens** on the toy data, and suppose that
we have more than two clusters …

``` r
## perform k-means ...
toy.km  <- kmeans(toydata, centers = 3)

## non graphical output
table(classes, toy.km$cluster)
```

    ##        
    ## classes  1  2  3
    ##       1  7  0 13
    ##       2  0 19  1

If you run it several times, the result of the clustering is
different\!\!

``` r
## plot the output
plot(toydata, col = toy.km$cluster, pch = classes)
```

![](figs/clusteringunnamed-chunk-14-1.png)<!-- -->

As you can see a third cluster is identified … but this is not
unexpected since we are not asking ourselves which is the optimal number
of clusters, but we are only dividing the data in three groups.

  - OK, but how many clusters?
  - … if I run it several times I’ll not always get the same answer …
  - Do you really have groups? Think, another time, to the “course of
    dimensionality”

## The Iris dataset

``` r
# Data preparation
# +++++++++++++++
data("iris")
head(iris)
```

    ##   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
    ## 1          5.1         3.5          1.4         0.2  setosa
    ## 2          4.9         3.0          1.4         0.2  setosa
    ## 3          4.7         3.2          1.3         0.2  setosa
    ## 4          4.6         3.1          1.5         0.2  setosa
    ## 5          5.0         3.6          1.4         0.2  setosa
    ## 6          5.4         3.9          1.7         0.4  setosa

``` r
iris.scaled <- scale(iris[, -5])
```

This we already know. The results of **k-mens** cannot be visualized in
the n dimensional space, but a clever way to look at the output could be
to use a PCA to project the data and show the clusters on the top of
that

``` r
# K-means clustering
# +++++++++++++++++++++
km.res <- kmeans(iris.scaled, 3, nstart = 50)

# Visualize kmeans clustering
# use repel = TRUE to avoid overplotting
fviz_cluster(km.res, iris[, -5], palette = "Set2",
            ellipse.type = "euclid", # Concentration ellipse
             star.plot = TRUE, # Add segments from centroids to items
             repel = TRUE # Avoid label overplotting (slow)
            ) + 
  theme_minimal() + 
  theme(aspect.ratio = 1)
```

![](figs/clusteringunnamed-chunk-16-1.png)<!-- -->

This is nice, but better would be to have the initial labels … in
textual form this can be seen like this

``` r
table(iris$Species,km.res$cluster)
```

    ##             
    ##               1  2  3
    ##   setosa      0 50  0
    ##   versicolor 11  0 39
    ##   virginica  36  0 14

# Assessing cluster tendency and finding the number of clusters …

``` r
library(cluster)
library(fpc)
library(NbClust)
library(clustertend)
```

## Visual methods

Basically here the idea is to inspect the distance matrix looking for
structures …

``` r
df <- iris[, -5]
# Random data generated from the iris data set
random_df <- apply(df, 2,
function(x){runif(length(x), min(x), (max(x)))})
random_df <- as.data.frame(random_df)
# Standardize the data sets
df <- iris.scaled <- scale(df)
random_df <- scale(random_df)
```

And then plot the distance matrices …

``` r
fviz_dist(dist(as.matrix(df)))
```

![](figs/clusteringunnamed-chunk-20-1.png)<!-- -->

``` r
fviz_dist(dist(as.matrix(random_df)))
```

![](figs/clusteringunnamed-chunk-21-1.png)<!-- -->

## Hopkins Statistics

Hopkins statistics can be calculated with a function provided in the
**clustertend** package …

``` r
hopkins(df, n=nrow(df)-1)
```

    ## $H
    ## [1] 0.1995403

``` r
hopkins(random_df, n=nrow(random_df)-1)
```

    ## $H
    ## [1] 0.5351593

A value near 0.5 suggests that the distribution of the data is not
different from a random one.

## Sum of Squares

To find the best number of groups a reasonable idea is to calculate the
within group sum of squares. If the number of clusters is optimal this
should give a good representation of the samples, so this sum should be
minimal.

``` r
wSS <- rep(0,9)
for (i in 1:9){
  pippo  <- kmeans(toydata, centers = i, nstart = 100)
  wSS[i]  <- pippo$tot.withinss
}

plot(seq(1,9), wSS, type = "b")
```

![](figs/clusteringunnamed-chunk-24-1.png)<!-- -->

  - The `nstart` argument used before is a way to find the “best”
    solution for a given number of clusters (we know that different
    starting points can give different results also for the same number
    of clusters)
  - The wSS drops from one to two and then it stays almost constant …
    this is a good indication of the presence of two clusters, but
    remember that here we have only two variables …

In the case of he iris data …

``` r
fviz_nbclust(df, kmeans, method = "wss") +
geom_vline(xintercept = 3, linetype = 2)
```

![](figs/clusteringunnamed-chunk-25-1.png)<!-- -->

As you see here the plot is less informative. It is less easy to decide
how many clusters we see. Three seems to be the best choice, as also our
previous analysis was indicating.

## Silhouette

K menas clustering on the iris dataset …

``` r
km.res <- eclust(df, "kmeans", k = 2, nstart = 25, graph = FALSE)
```

Silhoutte

``` r
fviz_silhouette(km.res, palette = "jco") + theme_minimal()
```

    ##   cluster size ave.sil.width
    ## 1       1   50          0.68
    ## 2       2  100          0.53

![](figs/clusteringunnamed-chunk-27-1.png)<!-- -->

## Dunn Index

When I cluster the iris data … to see what happens try with two and
three clusters …

``` r
# Statistics for k-means clustering on iris data
km_stats <- cluster.stats(dist(df), km.res$cluster)
# Dunn index
km_stats$dunn
```

    ## [1] 0.2674261

when I cluster the random data
…

``` r
km.res2 <- eclust(random_df, "kmeans", k = 2, nstart = 25, graph = FALSE)
# Statistics for k-means clustering on iris data
km_stats_rnd <- cluster.stats(dist(random_df), km.res2$cluster)
# Dunn index
km_stats_rnd$dunn
```

    ## [1] 0.1297505

## DIY assignments

  - Get the `wines.RData` and cluster the wines (HC and k-means)
  - Try to find the “optimal” number of groups by looking to the wSS
  - look how the picture is changing if you change the scaling of the
    data.
  - ADVANCED: try to visualize the clusters in the PCA plane. To do that
    you have to “manually” construct your plot ;-)
