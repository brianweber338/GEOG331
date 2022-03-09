#use built in iris dataset
#take a look at it 
head(iris)
#load in some tidyverse packages
library(dplyr)
library(ggplot2)

#####################################
##### Part 1: for loops         #####
#####################################

#Using only data for iris versicolor
#write a for loop
#that produces a regression table
#for each of the following relationships
#1. iris  sepal length x width
#2. iris  petal length x width
#3. iris sepal length x petal length

# hint: consider using a list, and also new vectors for regression variables

final_list = list()

flower <- iris[iris$Species=='versicolor',]

list_data = list(flower$Sepal.Length, flower$Sepal.Width, flower$Petal.Length,
                 flower$Petal.Width, flower$Sepal.Length, flower$Petal.Length)


for (i in 1:3){
  
  DataSet1 = unlist(list_data[((i*2)-1)])
  DataSet2 = unlist(list_data[(i*2)])
  
  final_list[[i]] <- lm(DataSet1 ~ DataSet2)
}


#####################################
##### Part 2: data in dplyr     #####
#####################################

#use dplyr to join data of maximum height
#to a new iris data frame
height <- data.frame(Species = c("virginica","setosa","versicolor"),
                     Height.cm = c(60,100,11.8))

irisNew <- iris

irisNew <- full_join(irisNew, height, by ='Species')



#####################################
##### Part 3: plots in ggplot2  #####
#####################################

#look at base R scatter plot
plot(iris$Sepal.Length,iris$Sepal.Width)

#3a. now make the same plot in ggplot
NewPlot1 <- ggplot(iris, aes(Sepal.Length, Sepal.Width)) + geom_point()
NewPlot1

#3b. make a scatter plot with ggplot and get rid of  busy grid lines
NewPlot2 <- NewPlot1 + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
NewPlot2

#3c. make a scatter plot with ggplot, remove grid lines, add a title and axis labels, 
#    show species by color, and make the point size proportional to petal length
NewPlot3 <- ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species, size = Petal.Length)) +
            geom_point() + 
            theme_classic() + 
            scale_color_manual(values = c("setosa" = "purple",
                              "versicolor"="orange","virginica"="steelblue")) +
            labs(x = "Sepal Length (mm)", y = "Sepal Width (mm)",
                title = "Sepal Size based on Length and Width")
NewPlot3

#####################################
##### Question: how did         #####
##### arguments differ between  #####
##### plot and ggplot?          #####
#####################################	