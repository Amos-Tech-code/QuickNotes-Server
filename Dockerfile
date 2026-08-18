# Build stage
FROM gradle:8.12.1-jdk17 AS build
WORKDIR /home/gradle/src
COPY --chown=gradle:gradle . .
RUN gradle buildFatJar --no-daemon

# Runtime stage
FROM eclipse-temurin:17-jre-jammy
EXPOSE 8080
RUN mkdir /app

# Copy the file while preserving its original name
COPY --from=build /home/gradle/src/build/libs/*-all.jar /app/

# Shell form allows the * wildcard to expand at runtime
ENTRYPOINT java -jar /app/*-all.jar
