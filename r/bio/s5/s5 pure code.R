
library(tidyverse)


### Index our data

data <- read.csv('Silver Tree Study.csv')


### Filter

data.filtered <- data %>% filter(Photosynthesis<300)

nrow(data)
nrow(data.filtered)


### Mutate


data.filtered.new.column <- data %>% mutate(new.column = Photosynthesis/Conductance)

ncol(data.filtered)
ncol(data.filtered.new.column)


### Summarize


Treatment.mean <- data.filtered %>% group_by(Treatment,Species) %>% summarize(n=n(), mean=mean(Photosynthesis),sd=sd(Photosynthesis),se = sd / sqrt(n),lowse = (mean-se),highse = (mean+se))


knitr::kable(Treatment.mean,align="c") ## note the kniter:: is telling r to look for the kable command in the knitter package. If you index(load) the knittr package at the beginning of your session, you can just write kable()

### Merge datasets


Total.plants.per.day <- data.filtered %>% group_by(Days.after.inoculation) %>% summarize(Total=n_distinct(Unique.Sample.Number))


Plants.per.treatment.per.day <- data.filtered %>% group_by(Treatment,Days.after.inoculation) %>% summarize(Number.of.Plants=n_distinct(Unique.Sample.Number))

Plants.overall <- left_join(Plants.per.treatment.per.day,Total.plants.per.day,by="Days.after.inoculation") #join matching values from total.plants.per.day to plants.per.treatment.per.day)

Plants.overall <- Plants.overall %>% mutate(Proportion=Number.of.Plants/Total)
kable(Plants.overall,align="c")

Plants.overall <- Plants.overall %>% mutate(Proportion=round(Number.of.Plants/Total,2))
kable(Plants.overall,align="c")


### Other handy packages in tidyverse

#### Stringr

data.with.new.column <- data.filtered %>% mutate(and.and.and = "one & two & three") #and.and.and is the name of the new column, which is just a 'string' of text copied in every row.
levels(data.with.new.column$and.and.and)

data.new.rows <-separate_rows(data.with.new.column, and.and.and, sep = "&")
levels(data.new.rows$and.and.and)


