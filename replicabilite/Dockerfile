FROM rocker/r-ver:4.5.2

RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libnlopt-dev \
    && rm -rf /var/lib/apt/lists/*
    
RUN R -e "install.packages('remotes')"

RUN R -e "remotes::install_version('car', version='3.1-3',upgrade='never')" \
 && R -e "remotes::install_version('lme4', version='1.1-37', upgrade='never')"

COPY . /app
WORKDIR /app
CMD ["/bin/sh", "-c", "Rscript repli_team_5.R | tee results/results.txt"]
