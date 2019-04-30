# Install Packages ####
install.packages("tidyverse")

# Load Packages ####
library(tidyverse)

# Index Data ####
data <- read.csv("Silver Tree Study.csv")
#data <- read.csv("Silver Tree Study.csv",sep=";")

# Explore and Adjust Data ####
str(data) #note that Trial is listed as an 'int'
data$Trial <- as.factor(data$Trial) #this tells R to recognize Trial as a 'factor'
str(data$Trial) #note that this time we can specify the column using $ to keep things shorter. 
names(data)
summary(data$Photosynthesis)
summary(data$Treatment)

?ggplot

# Data Visulization ####

# *One Variable Plots ####

# **Continuous Data ####
summary(data$Photosynthesis)
names(data)

# ****Histograms ####
ggplot(data,aes(Photosynthesis))+geom_histogram() #note that this is only a one variable plot (only x, not x and y). 

# *****Glimpse into dplyr ####
data <- data %>% filter(Photosynthesis<300) # lots more about this next week :)

# *****Filtered Data Plot ####
ggplot(data,aes(Photosynthesis))+geom_histogram()
ggplot(data,aes(Conductance))+geom_histogram()

# ****Density Plot ####
ggplot(data,aes(Photosynthesis))+geom_density()

# ****Group Comparisons ####
ggplot(data,aes(Photosynthesis,fill=Trial))+geom_histogram() # note we added the fill argument

ggplot(data,aes(Photosynthesis,fill=Trial))+geom_density()

ggplot(data,aes(Photosynthesis,fill=Trial))+geom_histogram(position="dodge") 

# **Discrete Data ####
summary(data$Trial)
summary(data$Treatment)
summary(data$Species)

# ***Bar Plots####
ggplot(data,aes(Species))+geom_bar()
# ****Flip Axis####
ggplot(data,aes(Species))+geom_bar() +coord_flip()

ggplot(data,aes(Species,fill=Treatment))+geom_bar(position="dodge") +coord_flip() #add fill and position

# *Two Variable Plots ####

# **Continuous x, Continous y####

# ***Point Plots ####
ggplot(data,aes(Photosynthesis,Conductance))+geom_point()

ggplot(data,aes(Photosynthesis,Conductance,color=Trial))+geom_point()

# ***Line Plots ####
ggplot(data,aes(Photosynthesis,Conductance))+geom_line()

?geom_smooth()

ggplot(data,aes(Photosynthesis,Conductance))+geom_smooth()

ggplot(data,aes(Photosynthesis,Conductance))+geom_smooth(method=lm)

# ****Group Comparisons ####
ggplot(data,aes(Photosynthesis,Conductance,linetype=Treatment))+geom_smooth(method=lm) #note that we define a linetype in this.

ggplot(data,aes(Photosynthesis,Conductance,linetype=Treatment,color=Species))+geom_smooth(method=lm) #note that we add color and linetype commands

# *****Facet Wrapping####
ggplot(data,aes(Photosynthesis,Conductance,color=Species))+geom_smooth(method=lm) +facet_wrap(~Treatment)#note that add Treatment as a facet_wrap argument rather than as a linetype.

ggplot(data,aes(Photosynthesis,Conductance,color=Treatment))+geom_smooth(method=lm) +facet_wrap(~Species) #here we switched treatment and species

ggplot(data,aes(Photosynthesis,Conductance,color=Treatment))+geom_smooth(method=lm) +facet_wrap(~Species,nrow=1) #here we define nrow=1

# **Discrete  x, Continous y####

# ***Boxplots ####
ggplot(data,aes(Species,Photosynthesis))+geom_boxplot()

ggplot(data,aes(Species,Photosynthesis))+geom_boxplot() +coord_flip()

ggplot(data,aes(Species,Photosynthesis,fill=Treatment))+geom_boxplot(position="dodge") +coord_flip()

names(data)

str(data$Days.after.inoculation)

ggplot(data,aes(Days.after.inoculation,Photosynthesis,fill=Species))+geom_boxplot(position="dodge")+facet_wrap(~Treatment)

data$Days.after.inoculation <- as.factor(data$Days.after.inoculation)

ggplot(data,aes(Days.after.inoculation,Photosynthesis,fill=Species))+geom_boxplot(position="dodge")+facet_wrap(~Treatment,ncol=1)
