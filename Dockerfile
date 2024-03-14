# syntax=docker/dockerfile:1

FROM python:3.8-slim-buster

WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

COPY . .

CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0"]

FROM jenkins/jenkins:latest

# Install Docker inside the Jenkins container
USER root
RUN apt-get update && apt-get install -y docker.io
USER jenkins

