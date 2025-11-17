##########################################################################################
##   CrowdStorming Data Analysis - FINAL APPROACH
##
##		Alicia Hofelich Mohr & Thomas Lindsay, University of Minnesota
##
##########################################################################################

#Research Question 1: Are soccer referees more likely to give red cards to dark skin toned players than light skin toned players?

#Research Question 2: Are soccer referees from countries high in skintone prejudice more likely to award red cards to dark skin toned players?

#Import the data
setwd("../Data")

#data = read.csv(file="~/Documents/StatsAnalysis/Crowdstorming/1. Crowdstorming Dataset 05.10.14.csv")

library(lme4)
library(ggplot2)
library(lmerTest)

data = read.csv(file="./CrowdstormingDataJuly1st.csv", header=T)

#looking at the data
head(data)
summary(data)
str(data)

data$refNum = factor(data$refNum)
levels(data$refNum)

#by(data$player, data$refNum, summary)
by(data, data$refNum, nrow)
by(data$redCards, data$refNum, sum)

#Preparing for Analysis 
#Look at skin tone ratings - interrater reliability?
cor.test(data[,18], data[,19]) 

data$rater1skincolor = ifelse(data$rater1 < .5, "light skin", ifelse(data$rater1 > .5, "dark skin", NA))
data$rater2skincolor = ifelse(data$rater2 < .5, "light skin", ifelse(data$rater2 > .5, "dark skin", NA))


ckappa(data[,28:29])

#merge the ratings into a single score 
data$skinrating = rowMeans(data[,18:19])

summary(data$skinrating)
hist(data$skinrating)
	#not normally distributed, more light than dark skined players

#RESEARCH QUESTION 1: Are soccer refs more likely to give red cards to dark skinned versus light skinned players?

#make it a dichotomous variable based on < or > .5 (leaving out the ones with neutral or ambiguous skin color) Raters rate all the pics - how they percieve the 4 versus 5 (or 2 versus 1) may change over ratings. Only 2 raters.

hist(data$redCards)
#Red cards are an infrequent events, best suited to poisson distribution
mean(data$redCards)
var(data$redCards) 
	#mean and variance are about the same 

#need to take red cards relative to number of games played in the model, as probability of getting a red card increases with the number of games played. Also seems to be difference due to position (for example, goalkeeper may be much less likely to get a red card than offensive players)

posglmer2 = glmer(redCards ~ skinrating + position + (1|refNum) + (1|player), data=data, offset=log(games), family="poisson", verbose=TRUE, nAGQ = 0)	
	#need to change the nAGQ variable to 1 and run overnight
summary(posglmer2)




## Question 2
#Research Question 2: Are soccer referees from countries high in skintone prejudice more likely to award red cards to dark skin toned players?


posglmer4 = glmer(redCards ~ skinrating*meanIAT + position + (1|refNum) + (1|player), data=data, offset=log(games), family="poisson", verbose=TRUE, nAGQ=0)
	#need to change nAGQ to 1
summary(posglmer4)

posglmer5 = glmer(redCards ~ skinrating*meanExp + position + (1|refNum) + (1|player), data=data, offset=log(games), family="poisson", verbose=TRUE, nAGQ=0)
	#need to change nAGQ to 1
summary(posglmer5)




### TO RUN AT NIGHT (longer to estimate, more accurate than above) - THESE ARE THE ANALYSES REPORTED

posglmer2 = glmer(redCards ~ skinrating + position + (1|refNum) + (1|player), data=data, offset=log(games), family="poisson", verbose=TRUE, nAGQ = 1)	
	#need to change the nAGQ variable to 1 and run overnight
summary(posglmer2)
#95% CI
a =  0.110496*1.96
(l.ci = exp(attr(posglmer2, "beta")[2] - a))
(h.ci = exp(attr(posglmer2, "beta")[2] + a))

posglmer4 = glmer(redCards ~ skinrating*meanIAT + position + (1|refNum) + (1|player), data=data, offset=log(games), family="poisson", verbose=TRUE, nAGQ=1)
	#need to change nAGQ to 1
summary(posglmer4)
#95% CI
a =  3.21355*1.96
(l.ci = exp(attr(posglmer4, "beta")[15] - a))
(h.ci = exp(attr(posglmer4, "beta")[15] + a))




posglmer5 = glmer(redCards ~ skinrating*meanExp + position + (1|refNum) + (1|player), data=data, offset=log(games), family="poisson", verbose=TRUE, nAGQ=1)
	#need to change nAGQ to 1
summary(posglmer5)
a =  0.48832*1.96
(l.ci = exp(attr(posglmer5, "beta")[15] - a))
(h.ci = exp(attr(posglmer5, "beta")[15] + a))

