FROM eclipse-temurin:17-jdk
WORKDIR /app
COPY target/calculator-1.0.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
