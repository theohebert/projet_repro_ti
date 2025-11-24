## load packages
install.packages("lsr")
library(lsr)

# Import data and select relevant variables.
data = read.csv("./data/new_crowdstorming.csv")
data <- subset(data, select=c(playerShort,refNum,redCards,games,goals,position,rater1,rater2,meanIAT,meanExp,club,leagueCountry,yellowCards))
starting_size = nrow(data)

## Transform variables ##

# Creates rating variable and drops cases with NAs (goes from 146028 to 124621)
data$rating <- ((data$rater1 + data$rater2) / 2)  
data = data[!is.na(data$rating),]  

# Tests position data. The only position whose CIs don't overlap with multiple other positions is the Center Back, so there's no clear clustering mechanism.  We'll leave this variable alone then.
aggregate(redCards~position, data=data, FUN=ciMean) 

# Drop missing IAT and EXP values
data = data[!is.na(data$meanIAT),] 
data = data[!is.na(data$meanExp),] 
data = data[!is.na(data$position),] 
data = data[!is.na(data$goals),] 
data = data[!is.na(data$yellowCards),] 
data = data[!is.na(data$redCards),] 

cat("Final length: ", nrow(data), "(starting size: ", starting_size, "; total dropped:", starting_size - nrow(data), ")\n")

## ANALYSIS ##
model <- glm(redCards ~ rating + position*rating + goals*rating + yellowCards*rating + meanIAT*rating + meanExp*rating + leagueCountry*rating, family = "poisson", data = data, offset=log(games))

# Print coefficients
m_coef = coef(model)
m_ci = confint(model)
cat("Rating Coeff: ", m_coef["rating"], "\n")
cat("Rating Coeff CIs :", m_ci["rating",], "\n")
cat("IRR: ", exp(m_coef)["rating"], "\n")
cat("IRR CI: ", exp(m_ci)["rating",], "\n")

cat("meanIAT*Rating Coeff: ", m_coef["rating:meanIAT"], "\n")
cat("meanIAT*Rating Coeff CIs :", m_ci["rating:meanIAT",], "\n")
cat("IRR: ", exp(m_coef)["rating:meanIAT"], "\n")
cat("IRR CI: ", exp(m_ci)["rating:meanIAT",], "\n")

cat("meanExp*Rating Coeff: ", m_coef["rating:meanExp"], "\n")
cat("meanExp*Rating Coeff CIs :", m_ci["rating:meanExp",], "\n")
cat("IRR: ", exp(m_coef)["rating:meanExp"], "\n")
cat("IRR CI: ", exp(m_ci)["rating:meanExp",], "\n")






