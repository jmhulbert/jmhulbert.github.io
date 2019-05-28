#knitr::purl("index.Rmd") 

#### Load Packages ####
library(tidyverse)

#### Check help file ####
?dplyr

#### Index Data ####
data <- read.csv('Silver Tree Study2.csv')

#### Factor Variables ####
str(data)
data$Days.after.inoculation <- as.factor(data$Days.after.inoculation)
data$Trial <- as.factor(data$Trial)

is.na(data$Photosynthesis)
data.no.na <-na.omit(data)
?na.omit
data.no.na <- data %>% filter(is.na=="TRUE")

#### Dplyr Intro ####

head(data)

#### Pipes ####

summary <- data %>% filter(Photosynthesis<200) %>% group_by(Species) %>% summarize(mean=mean(Photosynthesis)) #more about this later


#### Filter Data ####

levels(data$Species) #we can remind ourselves about the levels of a factor using the levels command

data.filtered <- data %>% filter (Photosynthesis<200 & Species!="Both Pathogens") #note the '!=' means 'does not equal' 
#Here we used & to filter the data by two variables at the same time

levels(data.filtered$Species)
summary(data.filtered$Species)

ggplot(data,aes(Trial,Photosynthesis,fill=Species))+geom_col()

ggplot(data.filtered,aes(Trial,Photosynthesis,fill=Species))+geom_col()

#### Drop Levels ####

data.filtered <- data %>% filter (Photosynthesis<200 & Species!="Both Pathogens") %>% droplevels()

levels(data.filtered$Species) 

#### Recode ####

data.filtered <- data.filtered %>% mutate(Species.new = recode(Species, "Indigenous Pathogen "="P. multivora", "Exotic Pathogen "="P. cinnamomi")) #notice that the original dataset had spaces after the column names..

levels(data.filtered$Species)


#### Summary Stats ####

data.filtered.summary <- data.filtered %>% group_by(treatment) #note this code probably doesn't do anything 

data.filtered.summary <- data.filtered %>% group_by(Treatment) %>% summarize(mean=mean(Photosynthesis))


#### Sample Sizes ####

Plant.Measurements <- data.filtered %>% group_by(Unique.Sample.Number,Days.after.inoculation) %>% summarize(n=n()) #the n=n() is a super nice function in dplyr to calculate the number of rows (measurements in our case).

as.tibble(Plant.Measurements)
Plant.Measurements

Plant.Count <- data.filtered %>% group_by(Treatment,Species) %>% summarize(number.of.plants=n_distinct(Unique.Sample.Number))

ggplot(Plant.Count,aes(Species,number.of.plants,fill=Treatment))+geom_col(position="dodge") +scale_fill_manual(values=c("Orange","Dark Blue")) #note you can pick specific colors you're interested in using the scale_fill_manual. However, anytime you're listing more than one object, you need to use c(). 



#### Mean per plant #####

Plant.Mean.Photo <- data.filtered %>% group_by(Unique.Sample.Number,Trial,Treatment,Species,Days.after.inoculation) %>% summarize(plant.average=mean(Photosynthesis))




as.tibble(Plant.Mean.Photo)

ggplot(Plant.Mean.Photo,aes(Species,plant.average,shape=Treatment,color=Species))+geom_point(position="jitter")

#### Mean per group #####

Group.Mean.Photo <- Plant.Mean.Photo %>% group_by(Treatment,Species,Days.after.inoculation) %>% summarize(n=n(), mean=mean(plant.average),sd=sd(plant.average),se = sd / sqrt(n),lowse = (mean-se),highse = (mean+se)) #notice here we also calculate sd, se, and the low and high values)


left <- ggplot(Plant.Mean.Photo,aes(Species,plant.average,shape=Treatment,color=Species))+geom_point(position="jitter")

right <- ggplot(Group.Mean.Photo,aes(Species,mean,shape=Treatment,color=Species))+geom_point(position="jitter")

gridExtra::grid.arrange(left,right) #note this is calling a the command grid.arrange from the package gridExtra. You will need to install gridExtra if you want to use this package/command


ggplot(Group.Mean.Photo,aes(as.factor(Days.after.inoculation),mean,color=Species))+geom_point()+facet_wrap(~Treatment,ncol=1) #notice we had to factor days after inoculation

#### Error Bars ####

ggplot(Group.Mean.Photo,aes(as.factor(Days.after.inoculation),mean,color=Species))+geom_point(position="dodge")+facet_wrap(~Treatment,nrow=2) +geom_errorbar(aes(ymin=lowse,ymax=highse),position="dodge")
## Warning: Removed 10 rows containing missing values (geom_errorbar).



Last.Week <- Group.Mean.Photo %>% filter(Days.after.inoculation=="35" | Days.after.inoculation=="37") #note that the | in this means 'OR', thus we have effectively asked R to to filter our data to those two days only. 

ggplot(Last.Week,aes(Days.after.inoculation,mean,color=Species))+geom_point(position = position_dodge(width = 1))+facet_wrap(~Treatment,nrow=2)+geom_errorbar(aes(ymin=lowse,ymax=highse),position = position_dodge(width = 1)) +labs(x= "Days after inoculation",y="Mean Photosynthesis") +theme_bw()+ theme(legend.text = element_text(face = "italic"))

#### Add Text ####

ggplot(Last.Week,aes(Days.after.inoculation,mean,color=Species))+geom_point(position = position_dodge(width = 1))+facet_wrap(~Treatment,nrow=2)+geom_errorbar(aes(ymin=lowse,ymax=highse),position = position_dodge(width = 1)) +labs(x= "Days after inoculation",y="Mean Photosynthesis") +theme_bw()+ theme(legend.text = element_text(face = "italic"))+geom_text(aes(label=n),position=position_dodge(width=1))


ggplot(Last.Week,aes(Species,mean,color=Treatment))+geom_point()+facet_wrap(~Days.after.inoculation,nrow=2)+geom_errorbar(aes(ymin=lowse,ymax=highse)) +labs(x= "Days after inoculation",y="Mean Photosynthesis") +theme_bw()+ theme(legend.text = element_text(face = "italic"))+geom_text(aes(label=n),nudge_x=0.1) #note we used the nudge_x command to nudge the text a small distance from the point
names(data.filtered)
summary <- data.filtered %>% group_by(Treatment,Species) %>% summarize(Mean.Photo=mean(Photosynthesis[Days.after.inoculation=="35"]),Mean.Conduct=mean(Conductance[Days.after.inoculation=="35"]))
summary
