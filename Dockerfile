# Stage 1: Build the application using Maven
FROM openjdk:17-jdk AS build

# Set the working directory in the container
WORKDIR /app

# Copy pom.xml and the source code into the container
COPY pom.xml .
COPY src ./src

# Copy Maven wrapper files
COPY mvnw .
COPY .mvn .mvn

# Set execution permissions for the Maven wrapper
RUN chmod +x mvnw

# Run Maven to build the project (skip tests for faster builds)
RUN ./mvnw clean package -DskipTests

# Stage 2: Create the final image with the JAR file
FROM openjdk:17-jdk

# Expose the port the app will run on
EXPOSE 8080

# Set the volume to store temporary files
VOLUME /tmp

# Copy the generated JAR file from the build stage
COPY --from=build /app/target/*.jar app.jar

# Set the entry point to run the application
ENTRYPOINT ["java", "-jar", "/app.jar"]

