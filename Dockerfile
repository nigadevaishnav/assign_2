# Use an official Maven image as a build stage
FROM maven:3.8.6-openjdk-17 AS build

# Set working directory
WORKDIR /app

# Copy pom.xml and download dependencies (to leverage Docker cache)
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy the full source code and build the application
COPY src ./src
RUN mvn clean package -DskipTests

# Use an official OpenJDK image for running the app
FROM openjdk:17-jdk-slim

# Set working directory
WORKDIR /app

# Copy the built JAR file from the build stage
COPY --from=build /app/target/*.jar app.jar

# Expose the port your app runs on (change if needed)
EXPOSE 8080

# Command to run the application
CMD ["java", "-jar", "app.jar"]

