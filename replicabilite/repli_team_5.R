#!/usr/bin/env Rscript
# crowdstorming analyses ullrich (with glenz, schlÃ¼ter, & spÃ¶rlein)
# refCountry: 3= Spain, 8 = Germany, 44 = England, France = 7
require(car)
require(lme4)

data<-read.csv("../DATA/CrowdstormingDataJuly1st.csv")

# player-referee combo variable
data$p_ref <- paste(data$playerShort,data$refNum,sep=".")

# average skintone rating
data$avgrate <- apply(cbind(data$rater1,data$rater2),1,FUN=function(x) mean(x,na.rm=TRUE)) 

#Adding this for suiting with the dataset used
data$avgrate = data$avgrate*4 + 1

# repeat rows for each game
data.games <- as.data.frame(matrix(ncol=ncol(data),nrow=sum(data$games)))
names(data.games) <- names(data)

for (col in 1:ncol(data)){
  data.games[,col] <- rep(data[,col],data$games)
}

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


print("Calculating gm3")
gm3 <- glmer(redCards ~ 1+avgrate01+(1 |playerShort) + (1|refNum) + (1+avgrate01|refCountry), 
             family = binomial, data = data.games.nona,nAGQ=0) 
print(summary(gm3))

gmTeam <- glmer(redCards ~ 1+avgrate01+(1 |playerShort) + (1|refNum) + (1+avgrate01|refCountry), 
             family = binomial, data = data.games.nona,nAGQ=0) 
print(summary(gm3))


coeffs_log_odds <- fixef(gm3)
ic_log_odds <- confint(gm3, method="Wald")
results_log_odds <- data.frame(
  Coefficient = coeffs_log_odds,
  IC_2.5 = ic_log_odds[rownames(ic_log_odds) %in% names(coeffs_log_odds), 1],
  IC_97.5 = ic_log_odds[rownames(ic_log_odds) %in% names(coeffs_log_odds), 2]
)
results_OR <- exp(results_log_odds)
print(results_OR)


print("Calculating with team 31 covariables")
gmTeam31 <- glmer(redCards ~ 1+avgrate01 + position + height + weight + refCountry  +(1 |playerShort) + (1|refNum), 
                family = binomial, data = data.games.nona,nAGQ=0) 
print(summary(gmTeam31))

coeffs_log_odds31 <- fixef(gmTeam31)
ic_log_odds31 <- confint(gmTeam31, method="Wald")
results_log_odds31 <- data.frame(
  Coefficient = coeffs_log_odds31,
  IC_2.5 = ic_log_odds31[rownames(ic_log_odds31) %in% names(coeffs_log_odds31), 1],
  IC_97.5 = ic_log_odds31[rownames(ic_log_odds31) %in% names(coeffs_log_odds31), 2]
)
results_OR31 <- exp(results_log_odds31)
print(results_OR31)

print("Calculating with team 15 covariables")
gmTeam15 <- glmer(redCards ~ 1+avgrate01 + leagueCountry +(1 |playerShort) + (1|refNum) + (1+avgrate01|refCountry), 
                  family = binomial, data = data.games.nona,nAGQ=0) 
print(summary(gmTeam15))

coeffs_log_odds15 <- fixef(gmTeam15)
ic_log_odds15 <- confint(gmTeam15, method="Wald")
results_log_odds15 <- data.frame(
  Coefficient = coeffs_log_odds15,
  IC_2.5 = ic_log_odds15[rownames(ic_log_odds15) %in% names(coeffs_log_odds15), 1],
  IC_97.5 = ic_log_odds15[rownames(ic_log_odds15) %in% names(coeffs_log_odds15), 2]
)
results_OR31 <- exp(results_log_odds15)
print(results_OR15)
