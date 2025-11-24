# Lancer l'expérience

## Executer

Vérifiez que vous avez bien docker d'installé (https://www.docker.com/).

Assurez vous d'être dans le même dossier que ce README.

Build le docker image avec :
```bash
sudo docker build -t team_5 .
```

Puis executer avec :
```bash
sudo docker run -v  ./results:/app/results team_5
```

Attention : l'execution peut prendre un certain temps.

## Résultats

Les paramètres et métriques des modèles sont écrits dans la console. Pour vérifier que ce sont bien les même que la team étudié, voir leur papier : https://osf.io/qix4g/files/d4t5b.


# Versions

Nous n'avons pas utilisé les mêmes version de R et de ces packages mais cela ne semble pas avoir influé les résultats.

### Utilisé par la team 5
Version de R : 3.1.1
Version de lme4 : 1.1-7

### Utilisé pour cette reproductibilité

Version de R : 4.1.1
Version de lme4 : 1.1.37


# Complications

Nous avons récupéré le script dans un tableur qui répértorie les codes de toutes les équipes. 
Ce script semble le même que celui mis en fin de l'article de l'équipe, cependant quelques éléments diffèrent.
Cette section présentent les éléments qui ont freiné la réproductibilité.

### Dataset

Il semblerait que les notes (rating1 et rating2) de la couleur de peau étaient 1,2,3,4 ou 5.
Le code R de la team 5 normalisait donc ces notes entre 0 et 1.
Le dataset que nous utilisons semble pourtant avoir des notes déjà normalisé.
Nous avons donc rajouté la ligne ```data$avgrate = data$avgrate*4 + 1 ``` en ligne 16.

Notons que ce problèmes était également présent dans le script récupéré.

### Paramètre du modèle

Le paramètre *nAGQ* (c'est la méthode d'aproximation) n'était pas présent dans le script récupéré (en fin d'article, on remarque que *nAGQ=0* est ajouté aux modèles). 
Nous avons observé sur le premier modèle (*gm0*) une différence avec et sans ce paramètre. 
Cependant changer ce paramètre influe énormément sur le temps de calcul et nous ne sommes donc pas allé plus loin.

