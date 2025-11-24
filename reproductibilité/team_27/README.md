# Lancer l'expérience

## Executer

Vérifiez que vous avez bien docker d'installé (https://www.docker.com/).

Assurez vous d'être dans le même dossier que ce README.

Build le docker image avec :
```bash
sudo docker build -t team_27 .
```

Puis executer avec :
```bash
sudo docker run -v  .:/app team_27
```

Attention : l'execution peut prendre un certain temps.

## Résultats

Les résultats de l'experience apparaissent 


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