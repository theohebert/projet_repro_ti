# Choix de réplicabilité

Nous nous sommes rendu compte qu'en plus des différentes méthodes utilisées,
le choix des variables de covariances utilisées étaient très changeant.
Nous avons donc décidé de partir du code de la team_5 puis essayer de changer les variables
de covariances utilisées pour voir les effets. Nous nous sommes concentré sur utiliser les variables
choisies par les team qui ont choisi des méthodes du même type (logistic) mais qui sont
parvenue à un résultat différents de la team_5 (i.e. pas de correlation significatives).

## Team_17

### Covariables

Cette team a utilisé les covariables _PlayerCards_ et _RefereeCards_.

## Team_15

### Covariables

Cette team a utilisé la covariable _LeagueCountry_.

### Résultats

Nous trouvons un OR de 1.350629770 dans un interval de confiance [1.076305929 ,1.69487199].
Ainsi nous avons que **l'effet est significatif**.

Cette équipe avait comme résultat un OR de 1.02 dans un interval de confiance de [1.00,1.03].
Nous avons donc même changé leur conclusion (car 1 était dans l'intervalle et ne l'est plus).

## Team_31

### Covariables

s
Cette team a utilisé les covariables _Position_, _Height_, _Weight_ et _Referee country_.

### Résultats

Nous trouvons un OR de 1.392674362 dans un interval de confiance [1.1262601110,1.72210829].
Ainsi nous avons que **l'effet est significatif**.

Cette équipe avait comme résultat un OR de 1.12 dans un interval de confiance de [0.88,1.43].
Nous avons donc même changé leur conclusion (car 1 était dans l'intervalle et ne l'est plus).

### Complications

Le modèle utilisé par la team_5 s'est avéré trop complexe avec ces covariables en plus
par rapport au nombre de données disponibles. Nous avons donc pris le modèle qu'ils appellent
gm1 et qui semblait être le second meilleur quand ils ont comparé leurs modèles
(voir leur papier: https://osf.io/qix4g/files/d4t5b).

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

Les resultats de l'execution sont ensuite stockés dans le fichier results dans le dossier du même nom.

## Versions

Version de R : 4.1.1
Version de lme4 : 1.1.37
