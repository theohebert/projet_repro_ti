#!/usr/bin/env Rscript
# crowdstorming analyses ullrich (with glenz, schlÃ¼ter, & spÃ¶rlein)
# refCountry: 3= Spain, 8 = Germany, 44 = England, France = 7
require(car)
require(lme4)

data<-read.csv("./CrowdstormingDataJuly1st.csv")

# player-referee combo variable
data$p_ref <- paste(data$playerShort,data$refNum,sep=".")

# average skintone rating
data$avgrate <- apply(cbind(data$rater1,data$rater2),1,FUN=function(x) mean(x,na.rm=TRUE)) 

#Adding this for suiting with the dataset used
data$avgrate = data$avgrate*4 + 1 #Maybe it wasn't the same dataset ?

# repeat rows for each game
data.games <- as.data.frame(matrix(ncol=ncol(data),nrow=sum(data$games)))
names(data.games) <- names(data)

for (col in 1:ncol(data)){
  data.games[,col] <- rep(data[,col],data$games)
}

#data.games$games <- 1

# build vector of redCards per game
redCards.games <- c()

for (i in 1:nrow(data)){
  x <- c(rep(1,data$redCards[i]),rep(0,data$games[i]-data$redCards[i]))
  redCards.games <- c(redCards.games,x)
  if (i%%10000 == 0){
    print(paste(i/10000, "/", nrow(data)/10000))
  }
}

data.games$redCards <- redCards.games

# exclude cases with missing values
data.games.nona<-subset(data.games,!is.na(avgrate)&!is.na(meanIAT))

# rescale skin-tone-rating to range 0,1
data.games.nona$avgrate01 <- (data.games.nona$avgrate-1)/4

# use redcard-games only for plot of expected and observed frequencies
data.red <- data.games.nona[data.games.nona$redCards > 0,]

# save frequencies
x <- table(as.integer(data.games.nona$avgrate))
y <- table(as.integer(data.red$avgrate))

# Chi-Square test: Compare observed frequencies with expected probability
null.probs <- x/sum(x)
chi <- chisq.test(y,p=null.probs)
print(chi)
print(data.frame(ratings=as.numeric(names(x)),expected=round(as.vector(chi$expected),1),observed=as.vector(chi$observed)))

png("results/barplot_Red_cards_and_skin-tones.png") #Added

cols <- c("grey20","grey70")
b <- barplot(t(cbind(chi$expected / chi$expected * 100,chi$observed / chi$expected * 100)),
             beside=TRUE,
             col=cols,
             xlab="Skin-tone ratings (mean)",
             ylab="Percent",
             ylim=c(0,150),
             main=paste("Red cards and skin-tones (n=",sum(chi$observed),").",sep=""))

legend("topright",legend=c("expected","observed"),fill=cols)

dev.off()

# glmer fits for research question 1 (gm3 best model): 

if(FALSE){

print("Calculating gm0")
gm0 <- glmer(redCards ~ 1+(1 |playerShort) + (1|refNum), 
             family = binomial, data = data.games.nona,nAGQ=0)
print(summary(gm0))

print("Calculating gm1")
gm1 <- glmer(redCards ~ 1+avgrate01+(1 |playerShort) + (1|refNum), 
             family = binomial, data = data.games.nona,nAGQ=0) 
print(summary(gm1))

print("Calculating gm2")
gm2 <- glmer(redCards ~ 1+avgrate01+(1 |playerShort) + (1+avgrate01|refNum), 
             family = binomial, data = data.games.nona,nAGQ=0) 
print(summary(gm2))
}

print("Calculating gm3")
gm3 <- glmer(redCards ~ 1+avgrate01+(1 |playerShort) + (1|refNum) + (1+avgrate01|refCountry), 
             family = binomial, data = data.games.nona,nAGQ=0) 
print(summary(gm3))

# Research Question 2a: 
# scatterplot of meanIAT and random effects of avgrate01 at the level of refCountry:
refag<-aggregate(data.games.nona$meanIAT,list(data.games.nona$refCountry),mean)
colnames(refag)<-c("refCountry","meanIAT")

refag$ranefavgrate01 = NA
refag$ranefavgrate01<-ranef(gm3,drop=FALSE)$refCountry[,2] 

png("results/scatter_random_effects_with_meanIAT.png")
scatter.smooth(refag$meanIAT,refag$ranefavgrate01,xlab="meanIAT",ylab="Random Efects Avgrate01 from gm3")
dev.off()

print("Calculating gm4")
#gm4 <- glmer(redCards ~ 1+avgrate01*meanIAT+(1 |playerShort) + (1|refNum) + (1+avgrate01|refCountry), 
#             family = binomial, data = data.games.nona,nAGQ=0)

#print(summary(gm4))

# Research Question 2b: / # scatterplot of meanIAT and random effects of avgrate01 at the level of refCountry:

refag<-aggregate(data.games.nona$meanIAT,list(data.games.nona$refCountry),mean) 
colnames(refag)<-c("refCountry","meanExp")

refag$ranefavgrate01 = NA
refag$ranefavgrate01<-ranef(gm3,drop=FALSE)$refCountry[,2]

png("results/scatter_random_effects_with_meanExp.png")
scatter.smooth(refag$meanExp,refag$ranefavgrate01,xlab="meanExp",ylab="Random Effects Avgrate01 from gm3")
dev.off()


print("Calculating gm5")
#gm5 <- glmer(redCards ~ 1+avgrate01*meanExp+(1 |playerShort) + (1|refNum) + (1+avgrate01|refCountry), 
#                                              family = binomial, data = data.games.nona,nAGQ=0) 
#print(summary(gm5))
