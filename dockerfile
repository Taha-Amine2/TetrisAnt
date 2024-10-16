FROM ubuntu:22.04

WORKDIR /app

COPY . .

ENV IVY_VERSION=2.5.2
ENV IVY_HOME=/usr/local/ivy
ENV IVY_JAR_PATH=$IVY_HOME/ivy-${IVY_VERSION}.jar

# Installer les dépendances nécessaires
RUN apt-get update && \
    apt-get install -y ant curl git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Installer Ivy
RUN mkdir -p $IVY_HOME && \
    curl -L https://dlcdn.apache.org/ant/ivy/${IVY_VERSION}/apache-ivy-${IVY_VERSION}-bin.tar.gz | tar xz -C $IVY_HOME --strip-components=1 && \
    mv $IVY_HOME/ivy-${IVY_VERSION}.jar $IVY_HOME/ivy.jar

# Construire le projet avec Ant
RUN ant

# Optionnel : Exposer un port ou définir une commande par défaut
# EXPOSE 8080
# CMD ["ant", "run"]
