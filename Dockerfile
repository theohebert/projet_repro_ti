FROM ubuntu:20.04
RUN apt-get update && apt-get install -y python3 python3-pip
COPY . /app
WORKDIR /app
RUN pip install -r requirements.txt
CMD ["python3", "reproductibilité/team_27/team_27.py"]