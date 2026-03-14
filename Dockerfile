# Stage 1: Build the application using Maven
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# Copy the pom.xml and source code to the container
COPY pom.xml .
COPY src ./src

# Build the WAR file (named ROOT.war based on pom.xml <finalName>)
# We use -DskipTests to ensure tests don't interrupt the build in headless environments
RUN mvn clean package -DskipTests -v

# Stage 2: Create the final lightweight Tomcat image
FROM tomcat:9.0-jdk17-corretto
WORKDIR /usr/local/tomcat

# Remove default Tomcat webapps to keep it clean
RUN rm -rf webapps/* 

# Copy our compiled ROOT.war from the build stage into Tomcat's webapps directory 
# so it is served at the root URL (/)
COPY --from=build /app/target/ROOT.war webapps/ROOT.war

# Expose port 8080 default
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
