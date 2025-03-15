# Use an official OpenJDK runtime as a parent image
FROM maven:3.9.6-eclipse-temurin-17 AS build
    
# Set the working directory inside the container
WORKDIR /app

# Copy the Maven project into the container
COPY . /app

# Build the application
RUN mvn clean package

# Use Jetty image to run the built app
FROM jetty:11-jdk17

# Copy built WAR file from previous stage into Jetty container
COPY --from=build /app/target/*.war /var/lib/jetty/webapps/ROOT.war    

# Expose the Jetty server port
EXPOSE 8080

# Run the application using Jetty
CMD ["java", "-jar", "/usr/local/jetty/start.jar"]
    
