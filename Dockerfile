# -------- Build stage --------
FROM maven:3.9.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package

# -------- Runtime stage --------
FROM tomcat:9.0-jdk17

# Install envsubst
RUN apt-get update && apt-get install -y gettext-base

# Remove default apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# Copy server.xml template
COPY server.xml.template /usr/local/tomcat/conf/server.xml.template

# Generate server.xml at runtime and start Tomcat
CMD envsubst < /usr/local/tomcat/conf/server.xml.template > /usr/local/tomcat/conf/server.xml \
    && catalina.sh run
