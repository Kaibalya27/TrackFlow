# -------- Build stage --------
FROM maven:3.9.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package

# -------- Runtime stage --------
FROM tomcat:9.0-jdk17

RUN rm -rf /usr/local/tomcat/webapps/*

# Copy custom server.xml
COPY server.xml /usr/local/tomcat/conf/server.xml

# Copy WAR as ROOT
COPY --from=build /app/target/ROOT.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
