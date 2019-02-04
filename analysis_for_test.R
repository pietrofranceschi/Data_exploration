library(mlbench)
library(FactoMineR)
library(factoextra)


data("Glass")


glass.PCA.scaled <- PCA(Glass[,1:9],
                       scale.unit = TRUE,
                       graph = FALSE)
fviz_pca_biplot(glass.PCA.scaled, 
                habillage = Glass$Type,
                label = "var", # show variable names
                repel = TRUE, invisible="quali", pointsize = 2) 


## Correlated Variables

X <- seq(1,10,length.out = 20)
Y <- 2*X + rnorm(20,0,3)
plot(X,Y, xlim = c(0,10), pch = 19, col = "steelblue", cex = 2)


##Clustering
# Compute distances and hierarchical clustering
dd <- dist(scale(Glass[,1:9]), method = "euclidean")
hc <- hclust(dd, method = "ward.D2")

fviz_dend(hc, cex = 0.5, 
          main = "Dendrogram - ward.D2",
          xlab = "Objects", ylab = "Distance", sub = "",  label_cols = Glass$Type)




