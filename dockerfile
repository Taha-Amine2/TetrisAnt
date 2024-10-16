FROM alpine:latest

WORKDIR /app

COPY . .

ENV IVY_VERSION=2.5.2
ENV IVY_HOME=/usr/local/ivy
ENV IVY_JAR_PATH=$IVY_HOME/ivy-${IVY_VERSION}.jar

# Installer OpenJDK et curl
RUN apk add --no-cache openjdk17 curl bash wget unzip

# Télécharger et installer Ant
RUN wget https://archive.apache.org/dist/ant/binaries/apache-ant-1.10.12-bin.zip && \
    unzip apache-ant-1.10.12-bin.zip && \
    mv apache-ant-1.10.12 /usr/local/apache-ant && \
    ln -s /usr/local/apache-ant/bin/ant /usr/bin/ant && \
    rm apache-ant-1.10.12-bin.zip

# Créer le répertoire pour Ivy et télécharger Ivy
RUN mkdir -p $IVY_HOME && \
    curl -L https://dlcdn.apache.org/ant/ivy/${IVY_VERSION}/apache-ivy-${IVY_VERSION}-bin.tar.gz | tar xz -C $IVY_HOME --strip-components=1 && \
    mv $IVY_HOME/ivy-${IVY_VERSION}.jar /usr/local/apache-ant/lib/ivy.jar  # Déplacer Ivy dans le répertoire lib d'Ant

ENV CLASSPATH=$CLASSPATH:$IVY_HOME/ivy.jar

# Exécute la commande ant lorsque le conteneur est démarré

RUN ant all
