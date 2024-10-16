FROM ubuntu:latest

WORKDIR /app

COPY . .

RUN apt-get update && apt-get install -y curl ant openjdk-11-jdk && \
    mkdir -p /usr/local/lib/ant/lib && \
    curl -L https://repo1.maven.org/maven2/org/apache/ivy/ivy/2.5.2/ivy-2.5.2.jar -o /usr/local/lib/ant/lib/ivy.jar

CMD ["ant"]
