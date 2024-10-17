FROM ubuntu:latest

WORKDIR /app

COPY . .

ENV IVY_VERSION=2.5.2
ENV IVY_HOME=/usr/local/ivy
ENV IVY_JAR_PATH=$IVY_HOME/ivy-${IVY_VERSION}.jar

RUN apt-get update && \
    apt-get install -y openjdk17 ant curl && \  
    apt-get clean

RUN mkdir -p $IVY_HOME && \
    curl -L https://dlcdn.apache.org/ant/ivy/${IVY_VERSION}/apache-ivy-${IVY_VERSION}-bin.tar.gz | tar xz -C $IVY_HOME --strip-components=1 && \
    mv $IVY_HOME/ivy-${IVY_VERSION}.jar $IVY_HOME/ivy.jar

ENV CLASSPATH=$CLASSPATH:$IVY_HOME/ivy.jar

CMD ["bash", "-c", "ant all && ls -la bin && sleep 60"]
