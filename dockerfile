FROM openjdk:11-jdk-alpine

WORKDIR /app

COPY . .

ENV IVY_VERSION=2.5.2
ENV IVY_HOME=/usr/local/ivy
ENV IVY_JAR_PATH=$IVY_HOME/ivy-${IVY_VERSION}.jar

# Install dependencies
RUN apk add --no-cache bash curl

# Install Apache Ant
RUN curl -L https://downloads.apache.org/ant/binaries/apache-ant-1.10.12-bin.tar.gz | tar xz -C /usr/local/ && \
    mv /usr/local/apache-ant-1.10.12 /usr/local/ant

ENV PATH=$PATH:/usr/local/ant/bin
ENV CLASSPATH=$CLASSPATH:$IVY_HOME/ivy.jar

# Install Ivy
RUN mkdir -p $IVY_HOME && \
    curl -L https://dlcdn.apache.org/ant/ivy/${IVY_VERSION}/apache-ivy-${IVY_VERSION}-bin.tar.gz | tar xz -C $IVY_HOME --strip-components=1 && \
    mv $IVY_HOME/ivy-${IVY_VERSION}.jar $IVY_HOME/ivy.jar

CMD ["bash", "-c", "ant all && ls -la bin && sleep 60"]
