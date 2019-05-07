#knitr::purl("index.Rmd") 

## Load Packages ####

library(tidyverse)

## Import Data ####

data <- read.csv("Silver Tree Study.csv") #again, for this to work, you need to have the data saved into your working directory. Altneratively, you can set the directory where your data is as your working directory.

## Part 1 Recap ####

## One Variable Plots

### Continuous data

ggplot(data,aes(Photosynthesis,fill=ifelse(Photosynthesis>300,'blue','red')))+geom_histogram()+guides(fill=FALSE) #note that this is only a one variable plot (only x, not x and y). 
#here we used the fill=ifelse() command to change the color of the specific observation.

## Glimpse of dplyr power ####

data.filtered <- data %>% filter(Photosynthesis<300) # we will go over the structure of this after our Session 2 recap. 

ggplot(data.filtered,aes(Photosynthesis))+geom_histogram() #note this time we used 'data.filtered'.

## Two Variable Plots ####

## Discrete x, Continuous y ####

ggplot(data.filtered,aes(Species,Photosynthesis,fill=Treatment))+geom_boxplot(position="dodge") +coord_flip()

## Change integer to factor ####

data.filtered$Days.after.inoculation.factored <- as.factor(data.filtered$Days.after.inoculation) #this time I created a new column rather than save over the other column.

ggplot(data.filtered,aes(Days.after.inoculation.factored,Photosynthesis,fill=Species))+geom_boxplot(position="dodge")+facet_wrap(~Treatment,ncol=1)


## change factor back to numeric ####

data.filtered$Days.after.inoculation <- as.numeric(data.filtered$Days.after.inoculation)

## Continous x, continous y

ggplot(data.filtered,aes(Days.after.inoculation,Photosynthesis,linetype=Treatment,color=Species))+geom_smooth(method=lm)

## Part 2 ####


## ggplot2 Extras ####


## add labels ###

ggplot(data.filtered,aes(Days.after.inoculation,Photosynthesis,linetype=Treatment,color=Species))+geom_smooth(method=lm) +labs(x="Days after inoculation",y=expression(Phyotosnytheic~Response~(µmol~m^{-2}~s^{-1}))) #note the crazy notation for adding superscripts

## Titles ####

ggplot(data.filtered,aes(Days.after.inoculation,Photosynthesis,linetype=Treatment,color=Species))+geom_smooth(method=lm) +labs(x="Days after inoculation",y="Photosynthesis",title="Photosnythetic Response")

## Center title ####

ggplot(data.filtered,aes(Days.after.inoculation,Photosynthesis,linetype=Treatment,color=Species))+geom_smooth(method=lm) +labs(x="Days after inoculation",y="Photosynthesis",title="Photosnythetic Response")+theme(plot.title = element_text(hjust = 0.5))

## Italics####

ggplot(data.filtered,aes(Days.after.inoculation,Photosynthesis,linetype=Treatment,color=Species))+geom_smooth(method=lm) +labs(x="Days after inoculation",y="Photosynthesis",title="Photosnythetic Response") +theme(axis.text.y=element_text(face="italic"), plot.title = element_text(hjust = 0.5,face="italic")) #notice we added italics to the y axis text and the title in this example


## Change Fonts ####


ggplot(data.filtered,aes(Days.after.inoculation,Photosynthesis,linetype=Treatment,color=Species))+geom_smooth(method=lm) +labs(x="Days after inoculation",y="Photosynthesis",title="Photosnythetic Response") +theme(axis.text.y=element_text(face="italic"), plot.title = element_text(hjust = 0.5,face="italic"),text=element_text(family="Times New Roman")) #this time we a command for the text object to specify a font. 

## Themes ####

ggplot(data.filtered,aes(Days.after.inoculation,Photosynthesis,linetype=Treatment,color=Species))+geom_smooth(method=lm) +labs(x="Days after inoculation",y="Photosynthesis",title="Photosnythetic Response")+theme(plot.title = element_text(hjust = 0.5)) +theme_bw()

## Colors ####

ggplot(data.filtered,aes(Days.after.inoculation,Photosynthesis,linetype=Treatment,color=Species))+geom_smooth(method=lm) +labs(x="Days after inoculation",y="Photosynthesis",title="Photosnythetic Response")+theme(plot.title = element_text(hjust = 0.5)) +theme_bw() +scale_color_brewer(palette="Reds")

## Greyscale ####

ggplot(data.filtered,aes(Species,Photosynthesis,fill=Treatment))+geom_boxplot(position="dodge") +coord_flip() +theme_bw()+scale_fill_grey()

## Remove guides ####

names(data.filtered)
ggplot(data.filtered,aes(Species,Photosynthesis,color=as.factor(Trial)))+geom_point(position="jitter") +coord_flip()+facet_wrap(~Treatment) +theme_bw()+guides(color=FALSE)


## Add text ####

ggplot(data.filtered,aes(Species,Photosynthesis,color=as.factor(Trial)))+geom_point(position="jitter") +coord_flip()+facet_wrap(~Treatment) +theme_bw()+guides(color=FALSE)+geom_text(aes(label=Plant.Number),position="jitter") #here we also specify the position="jitter" in the geom_text() command


## ggsave ####

# specify plot

plot <- ggplot(data.filtered,aes(Species,Photosynthesis,fill=Treatment))+geom_boxplot(position="dodge") +coord_flip()+scale_fill_grey()

plot

# specify space parameters

Space <- theme(axis.title.x=element_text(margin=margin(15,0,0,15)),axis.title.y=element_text(margin=margin(0,15,0,0))) # adds space between x axis text and x axis title

# specify theme

Theme <-  theme(axis.title=element_text(size=12),axis.text = element_text(size=12),strip.text.x=element_text(size=12),axis.text.y = element_text(face="italic"),plot.title = element_text(hjust = 0.5)) +theme_bw()

# combine specifications

Plot.for.print <- plot + Space + Theme

# save the plot

## ggsave(filename='Pretty Plot.png', plot = Plot.for.print, width = 225, height = 110,unit="mm",dpi = 300, limitsize = TRUE) # note that you can specify any directory or folder you want to save it by typing the whole path (e.g. './figures/pretty plot.png').
