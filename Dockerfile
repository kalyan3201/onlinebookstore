# -------- Stage 1 : Build --------
FROM maven:3.9.6-eclipse-temurin-17-alpine AS builder

WORKDIR /app

# Copy project files
COPY . .

# Build the WAR file
RUN mvn clean package -DskipTests


# -------- Stage 2 : Runtime --------
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Copy WAR file from builder stage
COPY --from=builder /app/target/*.war app.war

# Download webapp-runner
ADD https://repo1.maven.org/maven2/com/heroku/webapp-runner/9.0.75.0/webapp-runner-9.0.75.0.jar webapp-runner.jar

# Expose application port
EXPOSE 8080

# Run application
CMD ["java","-jar","webapp-runner.jar","--port","8080","app.war"]
