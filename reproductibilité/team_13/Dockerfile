# Utilise une image de base avec R 4.5.2
FROM rocker/r-ver:4.5.2

# Installe les dépendances système nécessaires pour les packages R
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libnlopt-dev \
    libudunits2-dev \
    && rm -rf /var/lib/apt/lists/*

# Installe les packages R avec des versions précises
RUN R -e "install.packages('remotes', version = '2.4.2', repos = 'https://cloud.r-project.org/')"
RUN R -e "remotes::install_version('car', version = '3.1-3')"
RUN R -e "remotes::install_version('lme4', version = '1.1-37')"
RUN R -e "install.packages('ggplot2', version = '3.5.1', repos = 'https://cloud.r-project.org/')"
RUN R -e "install.packages('lmerTest', version = '3.1-3', repos = 'https://cloud.r-project.org/')"
RUN R -e "install.packages('irr', version = '0.84.1', repos = 'https://cloud.r-project.org/')"

# Copie le répertoire local dans le conteneur
COPY . /app

# Définit le répertoire de travail
WORKDIR /app

# Commande pour exécuter le script R et sauvegarder les résultats
CMD ["/bin/sh", "-c", "Rscript rep_Team13.R | tee results/results.txt"]
