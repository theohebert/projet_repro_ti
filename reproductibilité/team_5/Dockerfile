FROM r-base:4.1.1

RUN R -e "install.packages('car', repos='https://cloud.r-project.org')"
RUN R -e "install.packages('lme4',version='1.1.37', repos='https://cloud.r-project.org')"

COPY . /app
WORKDIR /app
CMD ["R", "./Rscript rep_Team5.R | tee results/results.txt"]
