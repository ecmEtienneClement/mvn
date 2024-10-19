# FROM scratch AS build
# WORKDIR /home/api
# ADD *.tar /
# COPY . .
# # COPY src ./src
# RUN mvn clean package 
# FROM openjdk:21-jdk
#  WORKDIR /home/api
# COPY --from=build /home/api/target/*.jar  /home/api/app.jar
# CMD ["java", "-jar", "app.jar"]

# # maven:3.8.4-openjdk-17-slim 
FROM maven:openjdk  AS build
# Set the working directory in the container
WORKDIR /app
# Copy the pom.xml and the project files to the container
COPY pom.xml .
COPY src ./src
# Build the application using Maven
RUN mvn clean install -U
RUN mvn dependency:purge-local-repository
RUN mvn package -DskipTests
# Use an official OpenJDK image as the base image
FROM openjdk:11-jre-slim
# Set the working directory in the container
WORKDIR /app
# Copy the built JAR file from the previous stage to the container
COPY --from=build /app/target/*.jar ./app.jar
# Set the command to run the application
CMD ["java", "-jar", "app.jar"]