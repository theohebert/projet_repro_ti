# Team 13
L'equipe 13 a choisi d'utiliser R pour effectuer son analyse. L'OS utilisé ainsi que la version de R sont précisés: "All analyses were conducted using R 3.0.2 on OSX 10.9.3 and an alpha of .05 was used for all tests". Dans un premier temps, nous utilisons und version récente de R afin de tester le code sans avoir a télécharger une version ancienne. Nous n'avons pas accès à OSX, nos tests seront executés sur ubuntu 22.04.

## Version recente de R

L'équipe utilise le reglage nAGC=1 (Adaptive Gauss-Hermite Quadrature) pour plus de precisions dans ses calculs, les résultats fournis sont donc ceux issus des calculs utilisant ce réglage. Cependant ce réglage implique que le code nécessite de tourner pendant la nuit car l'execution est très longue. 

Nous avons aussi du changer une fonction et ajouter une librairie (la fonction ckappa n'était pas reconnue, nous avons fait le choix d'utiliser kappa2 de la librairie 'irr' à la place).

Dans un premier temps nous avons fait tourner les modèles avec le réglage de nAGC =0 (comme ils l'ont fait dans leur code). Les résultats obtenus sont déjà très proches de ceux que l'équipe 13 a fourni dans son papier et nous permettent d'arriver à la même conclusion qu'eux (les arbitres ont tendance à donner plus de cartons rouges aux joueurs ayant la peau foncée).

### Resultats obtenus pour la première Question

#### Are soccer referees more likely to give red cards to dark skin toned players than light skin toned players?

Pour cette première question nos resultats avec une version récente de R et nAGC sont les suivants (disponibles dans le fichier "resultats_nADQ=0.txt"):

exp(β)=1.39[95%CI:1.13–1.72], z = 3.091, p=.002

Resultats de l'équipe (avec nADQ=1 et R 3.0.2):

exp(β)=1.41[95% CI 1.13–1.75], z = 3.08, p=.002

On retrouve des resultats proches (mais pas identiques !). Cependant étant donné que dans les deux cas les résultats sont significatifs (p < 0.05 → effet statistiquement significatif) et qu'ils amène à une conclusion proche (41% de plus de change d'obtenir un carton rouge pour les joureurs ayany une peau foncée pour l'équipe de recherche contre 39% de notre côté) avec des intervalles de confiance à 95% similaires, on peut déjà affirmer que l'on arrive à la même conclusion sans la précision du réglage du nADQ et la bonne version de R.

### Resultats obtenus pour la seconde question

#### Are soccer referees from countries high in skintone prejudice more likely to award red cards to dark skin toned players?

Pour cette première question nos resultats avec une version récente de R et nAGC sont les suivants (disponibles dans le fichier "resultats_nADQ=0.txt"):
meanAIC:

exp(β)=2.77[...]
meanExp:


Les resultats de l'équipe de recherche pour cette question étaient les suivants:

Neither interaction was significant, IAT: exp(β) = 0.13[95% CI .0002–68.06],z =-0.65, p = .52; Exp: exp(β) = 1.09[95% CI 0.42–2.84], z = 0.18 , p = .86, suggesting that the general skintone bias found in the distribution of red cards was not influenced by whether the referee was from a country high in skintone prejudice.   