# Use official Maven image to build the project
FROM maven:3.8.6-openjdk-17 AS build

# Set working directory
WORKDIR /app

# Copy the pom.xml file and download dependencies first (for caching)
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy the full source code and build the application
COPY src ./src
RUN mvn clean package -DskipTests

# Use a lightweight JDK image for running the application
FROM openjdk:17-jdk-slim

# Set working directory
WORKDIR /app

# Copy the built JAR file from the Maven build stage
COPY --from=build /app/target/*.jar app.jar

# Expose the application's running port
EXPOSE 8080

# Run the application
CMD ["java", "-jar", "app.jar"]

