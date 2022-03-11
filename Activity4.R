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

#Creates an empty list named final_list
final_list = list()

# Creates a list named flower containing only the data for iris versicolor
flower <- iris[iris$Species=='versicolor',]

# Creates a list of data to be used in the linear models in the following for loop
list_data = list(flower$Sepal.Length, flower$Sepal.Width, flower$Petal.Length,
                 flower$Petal.Width, flower$Sepal.Length, flower$Petal.Length)

for (i in 1:3){
  
  # takes the data from list_data two at a time and assigns them to DataSet1 and DataSet2
  DataSet1 = unlist(list_data[((i*2)-1)])
  DataSet2 = unlist(list_data[(i*2)])
  
  # Uses DataSet1 and DataSet2 and finds the linear model, adds result to final_list
  final_list[[i]] <- lm(DataSet1 ~ DataSet2)
}


#####################################
##### Part 2: data in dplyr     #####
#####################################

#use dplyr to join data of maximum height
#to a new iris data frame
height <- data.frame(Species = c("virginica","setosa","versicolor"),
                     Height.cm = c(60,100,11.8))

# joins iris and height based on species, saves result to irisNew
irisNew <- full_join(iris, height, by ='Species')



#####################################
##### Part 3: plots in ggplot2  #####
#####################################

#look at base R scatter plot
plot(iris$Sepal.Length,iris$Sepal.Width)

#3a. now make the same plot in ggplot
NewPlot1 <- ggplot(iris, aes(Sepal.Length, Sepal.Width)) + geom_point()
# Prints NewPlot1
NewPlot1


#3b. make a scatter plot with ggplot and get rid of busy grid lines
NewPlot2 <- NewPlot1 + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
                             axis.line = element_line(colour = "black"))
# Prints NewPlot2
NewPlot2


#3c. make a scatter plot with ggplot, remove grid lines, add a title and axis labels, 
#    show species by color, and make the point size proportional to petal length
NewPlot3 <- ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species, size = Petal.Length)) +
            geom_point() + 
            theme_classic() + 
            scale_color_manual(values = c("setosa" = "red",
                              "versicolor"="yellow","virginica"="steelblue")) +
            labs(x = "Sepal Length (mm)", y = "Sepal Width (mm)",
                title = "Sepal Size based on Length and Width")
# Prints NewPlot3
NewPlot3

#####################################
##### Question: how did         #####
##### arguments differ between  #####
##### plot and ggplot?          #####
#####################################	