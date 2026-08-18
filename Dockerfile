# =========================
# Build stage
# =========================
FROM gradle:8.12.1-jdk21 AS build

WORKDIR /home/gradle/src

# Copy project with Gradle ownership
COPY --chown=gradle:gradle . .

# Build the executable Shadow JAR
RUN gradle shadowJar --no-daemon


# =========================
# Runtime stage
# =========================
FROM eclipse-temurin:21-jre-jammy

WORKDIR /app

# Expose the port used by the Ktor application
EXPOSE 8080

# Copy the Shadow JAR produced by Gradle
COPY --from=build /home/gradle/src/build/libs/quickernotes-server.jar /app/quickernotes-server.jar

# Start the Ktor application
ENTRYPOINT ["java", "-jar", "/app/quickernotes-server.jar"]
