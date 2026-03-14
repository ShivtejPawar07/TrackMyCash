# Stage 1: Build the application using Maven
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# Copy the pom.xml and source code to the container
COPY pom.xml .
COPY src ./src

# Build the WAR file (named ROOT.war based on pom.xml <finalName>)
RUN mvn clean package -v

# Stage 2: Create the final lightweight Tomcat image
FROM tomcat:9.0-jdk17-corretto
WORKDIR /usr/local/tomcat

# Remove default Tomcat webapps to keep it clean
RUN rm -rf webapps/* 

# Copy our compiled ROOT.war from the build stage into Tomcat's webapps directory 
# We use a wildcard *.war and rename to ROOT.war to ensure it works even if maven names it slightly differently
COPY --from=build /app/target/*.war webapps/ROOT.war

# Expose port 8080 default
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
