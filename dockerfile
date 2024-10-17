# Use an official Java image as the base
FROM openjdk:11-slim AS base

# Set environment variables
ENV VERSION=""
ENV IVY_VERSION=2.5.2
ENV IVY_HOME=/usr/local/ivy
ENV IVY_JAR_PATH=$IVY_HOME/ivy-${IVY_VERSION}.jar
ENV CLASSPATH=$CLASSPATH:$IVY_HOME/ivy.jar


RUN apt-get update && \
    apt-get install -y ant curl && \
    apt-get clean

RUN mkdir -p $IVY_HOME && \
    curl -L https://dlcdn.apache.org/ant/ivy/${IVY_VERSION}/apache-ivy-${IVY_VERSION}-bin.tar.gz | tar xz -C $IVY_HOME --strip-components=1 && \
    mv $IVY_HOME/ivy-${IVY_VERSION}.jar $IVY_HOME/ivy.jar

# Set the working directory
WORKDIR /app

# Copy the project files into the container
COPY . .

# Build stage
FROM base AS build
RUN echo "Building the project with Ant..." && \
    apt-get update && apt-get install -y ant && \
    ant compile

# Test stage
FROM build AS test
RUN echo "Running tests with Ant..." && \
    ant test

# Docs stage
FROM build AS docs
RUN echo "Generating Javadoc with Ant..." && \
    ant javadoc

# Copy the generated docs to a separate directory for artifacts
RUN mkdir /app/javadoc && \
    cp -r build/javadoc/* /app/javadoc/

# Dist stage
FROM build AS dist
RUN echo "Packaging the project into a JAR file with Ant..." && \
    ant dist