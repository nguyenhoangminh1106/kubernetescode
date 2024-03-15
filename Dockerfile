# syntax=docker/dockerfile:1

FROM python:3.8-slim-buster

WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

COPY . .

CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0"]

RUN echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Now we need to allow jenkins to run docker commands! (This is not elegant, but at least it's semi-portable...)
USER root

## allowing jenkins user to run docker without specifying a password
RUN echo "jenkins ALL=(ALL) NOPASSWD: /usr/bin/docker" >> /etc/sudoers

# Create our alias file that allows us to use docker as sudo without writing sudo
COPY docker_sudo_overwrite.sh /usr/local/bin/docker
RUN chmod +x /usr/local/bin/docker

# switch back to the jenkins-user
USER jenkins

