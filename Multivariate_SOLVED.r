
#loading the required libraries
suppressPackageStartupMessages(library(FactoMineR))
suppressPackageStartupMessages(library(factoextra))

#loading the data
load("data/winesmall.RData")

#performing the PCA on all the "numerical" variables
res.pca<-PCA(winesmall[,-1], 
             scale.unit = TRUE,
             graph = FALSE)

fviz_screeplot(res.pca, addlabels = TRUE)

ind <- get_pca_ind(res.pca)
head(ind$coord)

fviz_pca_ind(res.pca, 
             habillage = winesmall$Cultivar,
             #label = "none", # hide individual labels
             repel = TRUE # Avoid text overlapping (slow if many points)
             )

var <- get_pca_var(res.pca)
head(var$coord)

fviz_pca_var(res.pca, col.var = "black")

#you can "beautify" to the plot
fviz_pca_var(res.pca, col.var="contrib",
             gradient.cols = c("gray70", "coral3"),
             repel = TRUE # Avoid text overlapping
             )

fviz_pca_biplot(res.pca, 
                habillage = winesmall$Cultivar,
                #label = "none", # hide individual labels
                repel = TRUE)

res.pca<-PCA(winesmall[,-1], 
             scale.unit = FALSE,
             graph = FALSE)

fviz_pca_biplot(res.pca, 
                habillage = winesmall$Cultivar,
                label = "none", #if you comment this line you will see the name of the features
                repel = TRUE)

rubus<-read.table("data/rubusSmallInfo.txt",header=TRUE, check.names = FALSE,sep="\t")
#str(rubusFilled)
rubus[1:5,1:10]
summary(rubus[,1:9])

rownames(rubus)<-rubus$sampleName #to have labels in the "sample plot"

res.pca<-PCA(rubus[,-c(1:7)],
             scale.unit = TRUE,
            quali.sup = 2:7)

fviz_pca_ind(res.pca, 
                habillage = factor(rubus$color), #other confounding factors can be checked
                label = "none", # hide individual labels
                repel = TRUE)


## how to add extra point... scaling: the tricky part...
summary(rubus$color)

idr<-which(rubus$color=="R")
idy<-which(rubus$color=="Y")

#let's keep 9 sample per class and assume that this is your primary dataset 
sel<-c(idr[1:9],idy[1:9])
#after your analysis is done, you receive a few samples more:  
#now you want to understand how similar they are to your original data 
extra<-c(idr[10:13],idy[10:12])

res.pca<-PCA(rubus[,-1],
             ind.sup = extra, #we are adding samples to a projection computed on the first 9 points of each sample
             scale.unit = TRUE,
             quali.sup = 1:6) #adding qualitative variables (can be plotted)

summary(res.pca)

fviz_pca_ind(res.pca, 
                habillage = grep("color",names(rubus))-1, #other confounding factors can be checked, 
                                                          #just change the name of the column
                label = "none", # hide individual labels
                repel = TRUE)

#we will use k-means.. 
#let's start looking at what the function does
?kmeans

set.seed(20)
cl <- kmeans(winesmall[, -1], centers =  2, nstart = 20)
cl

#Let's give a look at the output
plot(winesmall[,c("Alcohol","Total_Phenols","Color_intensity","Malic_acid","Flavanoids","Proline","OD_ratio")], 
     col=c("aquamarine4","violet")[cl$cluster])

#How good is the clustering?
table(winesmall$Cultivar, cl$cluster)

#how can we choose the number of clusters?
#the "elbow" method
wssplot <- function(data, nc=15, seed=1234){
               wss <- (nrow(data)-1)*sum(apply(data,2,var))
               for (i in 2:nc){
                    set.seed(seed)
                    wss[i] <- sum(kmeans(data, centers=i)$withinss)}
                plot(1:nc, wss, type="b", pch=19, xlab="Number of Clusters",
                     ylab="Within groups sum of squares")}

wssplot(winesmall[,-1])

#another option for choosing the number of clusters: a package with 30 indices (you can choose which distance)
library(NbClust)
?NbClust
#otherwise there is also the fpc package: check the cluster.stats function

set.seed(1234)
nc <- NbClust(winesmall[,-1], min.nc=2, max.nc=15, method="kmeans", distance="euclidean")

#the recommended number of clusters is chosen using 26 criteria provided
table(nc$Best.n[1,])

barplot(table(nc$Best.n[1,]),
          xlab="Numer of Clusters", ylab="Number of Criteria",
          main="Number of Clusters Chosen by 26 Criteria")

#now we will try to understan the meaning of the nstart parameter
#for this reason we will use the complete dataset with three classes
wine<-read.table("data//wine.data.names.txt",header=TRUE)

#the layout command is useful for putting more than one plot close together
nf <- layout(mat = matrix(c(1,2,3),1,3, byrow=TRUE), height=c(0.5))
#avoids extra space around the plot
par(mar=c(3.1, 3.1, 1.1, 2.1))

plot(wine[,c("Flavanoids","Proline")], 
     col=c("aquamarine4","violet","cyan1")[as.numeric(wine$Cultivar)])

set.seed(100)
cl <- kmeans(wine[, -1], centers =  3, nstart = 1)
table(wine$Cultivar, cl$cluster)

plot(wine[,c("Flavanoids","Proline")], 
     col=c("aquamarine4","violet","cyan1")[cl$cluster])

set.seed(100)
cl <- kmeans(wine[, -1], centers =  3, nstart = 5)
table(wine$Cultivar, cl$cluster)

plot(wine[,c("Flavanoids","Proline")], 
     col=c("aquamarine4","violet","cyan1")[cl$cluster])


set.seed(20)
ws<-scale(wine[,-1])
cl2 <- kmeans(ws, centers =  3, nstart = 20)

table(cl$cluster,wine$Cultivar)
table(cl2$cluster,wine$Cultivar)

nf <- layout(mat = matrix(c(1,2,3),1,3, byrow=TRUE))
plot(wine[,c("Proline","Magnesium")], 
     col=c("aquamarine4","violet","cyan1")[as.numeric(wine$Cultivar)])

plot(wine[,c("Proline","Magnesium")], 
     col=c("aquamarine4","violet","cyan1")[as.numeric(cl$cluster)])

plot(wine[,c("Proline","Magnesium")], 
     col=c("aquamarine4","violet","cyan1")[as.numeric(cl2$cluster)])


?hclust

cl <- hclust(dist(scale(winesmall[,-1])))
plot(cl)

#how can we decide which is the best number of clusters? look at the plot
#let's cut the dendrogram in order to define th,e clusters:
plot(cl)
rect.hclust(cl, 2) #we can use here the result of k-means for cutting


#create the vector with the cluster membership information
clusterCut <- cutree(cl, 2)

#we can use the distance for cutting the dendrogram
plot(cl)
rect.hclust(cl, h=9) 

#in this special case we have the info about the class... 
#we can check how it compares with the structure detected by hclust

table(clusterCut,winesmall$Cultivar)

#Single linkage has a tendency to chain observations: most common case is
#to fuse a single observation to an existing class: the single link is the nearest
#neighbour, and a close neighbour is more probably in a large group than in a
#small group or a lonely point. Complete linkage has a tendency to produce
#compact bunches: complete link minimizes the spread within the cluster. The
#average linkage is between these two extremes.

d<-dist(scale(winesmall[,-1]),method="euclidean")

ccom <- hclust(d, method="complete")
caver <- hclust(d, method="average")
csin <- hclust(d, method="single")

nf<-layout(matrix(c(1:3),nrow=3))
plot(ccom, hang=-1)
rect.hclust(ccom, k=2)
plot(caver, hang=-1)
rect.hclust(caver, k=2)
plot(csin, hang=-1)
rect.hclust(csin, k=2)


clusterCut <- cutree(ccom, 2)
table(clusterCut,winesmall$Cultivar)

clusterCut <- cutree(caver, 2)
table(clusterCut,winesmall$Cultivar)

clusterCut <- cutree(csin, 2)
table(clusterCut,winesmall$Cultivar)


#?dist
#pick a subset so that it is easier to understand what is happening
id1<-which(winesmall$Cultivar==1)
id3<-which(winesmall$Cultivar==3)
sel<-c(id1[1:10],id3[1:10])

de<-dist(scale(winesmall[sel,-1]),method="euclidean")
dm<-dist(scale(winesmall[sel,-1]),method="manhattan")

summary(de)
summary(dm)

he<-hclust(de,method="average")
hm<-hclust(dm,method="average")

##looking at the two trees
nf<-layout(matrix(c(1,2),nrow=2))
plot(he, main="Euclidean Distance")
rect.hclust(he, k=2)
plot(hm, main="Manhattan Distance")
rect.hclust(hm, k=2)


rubush<-hclust(dist(scale(rubus[,-c(1:7)])))
plot(rubush)
rect.hclust(rubush,k=4) #or using h=height

#let's try with kmeans
wssplot(scale(rubus[,-c(1:7)]))

km<-kmeans(scale(rubus[,-c(1:7)]),centers = 2,nstart = 20)
table(km$cluster,rubus$color)

km<-kmeans(scale(rubus[,-c(1:7)]),centers = 4,nstart = 20)
table(km$cluster,rubus$color)




