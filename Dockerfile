# Stage 1: Build the application using Maven
FROM openjdk:17-jdk AS build

WORKDIR /app
COPY pom.xml .
COPY src ./src
COPY mvnw .
COPY .mvn .mvn

RUN chmod +x mvnw
RUN ./mvnw clean package -DskipTests

# Stage 2: Final image with the JAR file
FROM openjdk:17-jdk

# Expose the port that will be set dynamically by Render (the PORT environment variable)
EXPOSE 8080

# Copy the JAR file
COPY --from=build /app/target/*.jar app.jar

# Run the application
ENTRYPOINT ["java", "-jar", "/app.jar"]

