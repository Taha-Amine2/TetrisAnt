FROM ubuntu:latest

WORKDIR /app

# Copy project files
COPY . .

# Set Ivy version and home
ENV IVY_VERSION=2.5.2
ENV IVY_HOME=/usr/local/ivy
ENV IVY_JAR_PATH=$IVY_HOME/ivy-${IVY_VERSION}.jar

# Install necessary packages
RUN apt-get update && \
    apt-get install -y openjdk-17-jdk ant curl && \
    apt-get clean

# Create Ivy directory and download Ivy
RUN mkdir -p $IVY_HOME && \
    curl -L https://dlcdn.apache.org/ant/ivy/${IVY_VERSION}/apache-ivy-${IVY_VERSION}-bin.tar.gz | tar xz -C $IVY_HOME --strip-components=1 && \
    mv $IVY_HOME/ivy-${IVY_VERSION}.jar $IVY_HOME/ivy.jar

# Update CLASSPATH
ENV CLASSPATH=$CLASSPATH:$IVY_HOME/ivy.jar

# Run Ant to build the project
CMD ["ant", "all"]
