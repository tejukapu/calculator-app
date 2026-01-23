# Use Eclipse Temurin 21 JRE (Runtime) on a slim Debian base for 2026
# JRE is smaller and more secure than the full JDK
FROM eclipse-temurin:21-jre-noble

# Set the working directory inside the container
WORKDIR /app

# Copy the JAR file built by Maven from your Jenkins workspace
# Note: Ensure the filename matches your pom.xml (artifactId-version.jar)
COPY target/calculator-1.0.jar app.jar

# Run the application using the "exec" form for better signal handling
ENTRYPOINT ["java", "-jar", "app.jar"]
