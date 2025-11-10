import csv
import matplotlib.pyplot as p  # Import for visualizations
import pandas
import scipy.stats as s 
import numpy as np 
import statsmodels.api as sm
from patsy import dmatrices

def ecriture_fichier(nom_fichier, contenu):
    with open(nom_fichier, 'w') as f:
        f.write(str(contenu) + '\n')

results = "Resultats de la reproduction de l'analyse de l'equipe 27:\n"

data_reader = csv.DictReader(open('./DATA/CrowdstormingDataJuly1st.csv', 'r'))   # Open datafile
data = []
for c,row in enumerate(data_reader):    # Create list of dics from the DictReader object
    data.append(row)
#print (data[:2])

redCards = [float(row["redCards"]) for row in data]

# Create a histogram
#p.figure(1)
#np, bins, patches = p.hist(redCards,bins=5,range=(0,5))
#p.show()

print(np.var([float(row["redCards"]) for row in data]))
print(np.mean([float(row["redCards"]) for row in data]))

# Check IRR of ratings
rater1 = [float(row["rater1"]) for row in data if "NA" not in [row["rater1"],row["rater2"]]]
rater2 = [float(row["rater2"]) for row in data if "NA" not in [row["rater1"],row["rater2"]]]

# Print results of scipy's normality test (based off D'Agostino-Pearson normality test)
#print(s.stats.normaltest(rater1, axis=0))
#print(s.stats.normaltest(rater2, axis=0))

#print("Spearman: ", s.spearmanr(rater1,rater2))

df = pandas.read_csv('./DATA/CrowdstormingDataJuly1st.csv')
keys = ['playerShort','refNum','games','goals','yellowCards','redCards','position','meanIAT','meanExp', 'rater1', 'rater2','club','leagueCountry']
df = df[keys]
#print (df[:3])


# Drop NA ratings and make an average
df = df.dropna(subset=['rater1','rater2'])
df['rating'] = (df['rater1'] + df['rater2']) / 2
#print(df[:3])

positions = df.groupby(['position'])
positions['goals'].mean() / positions['games'].mean()

before_drop = len(df)
df = df.dropna(subset=['position'])  
#print ("rows dropped: ", before_drop - len(df))

def f(x):
    positionDict = {"Attacking Midfielder" : "Midfield", "Center Back" : "Defense", "Center Forward" : "Offense", "Center Midfielder" : "Midfield", "Defensive Midfielder" : "Defense", "Goalkeeper" : "Goalkeeper", "Left Fullback" : "Defense", "Left Midfielder" : "Midfield", "Left Winger" : "Offense", "Right Fullback" : "Defense", "Right Midfielder" : "Midfield", "Right Winger" : "Offence"}
    return positionDict[x]
df['positionGroup'] = df['position'].apply(f,1)

#print (df[:10]['positionGroup'])

before_drop = len(df)
df = df.dropna(subset=['meanIAT', 'meanExp'])
#print ("rows dropped: ", before_drop - len(df))

df['meanIAT'] = df['meanIAT'] * 100
df['meanExp'] = df['meanExp'] * 100
#print(df[:3])

exposure_array = df['games'].values


# Create + fit poisson model
def test_question(y, X, exposure_array,results):  
    poisson_mod = sm.Poisson(y, X, exposure=exposure_array)
    poisson_res = poisson_mod.fit()
    results = results + str(poisson_res.summary()) + "\n"
    print (poisson_res.summary())
    return results
    
    

    # print (np.exp(poisson_res.params))

# Define x and y 
y, X = dmatrices('redCards ~ rating + rating*goals + rating*positionGroup + rating*yellowCards + rating*meanIAT + rating*meanExp', data=df, return_type='dataframe')

results = test_question(y, X, exposure_array,results)

# The same function as above, but displaying different output.
def test_question(y, X, exposure_array,results):  
    poisson_mod = sm.Poisson(y, X, exposure=exposure_array)
    poisson_res = poisson_mod.fit()
    # print poisson_res.summary()
    print (np.exp(poisson_res.params))
    results += str(np.exp(poisson_res.params)) + "\n"
    return results

results= test_question(y, X, exposure_array,results)

ecriture_fichier("./reproductibilité/team_27/team_27_results.txt", results)
