# Use a multi-stage build: compile with Maven then produce a small runtime image
FROM maven:3.8.8-eclipse-temurin-21 AS builder
WORKDIR /workspace
COPY mvnw pom.xml ./
COPY .mvn .mvn
COPY src ./src
RUN chmod +x mvnw && ./mvnw -B -DskipTests package

FROM eclipse-temurin:21
WORKDIR /app
COPY --from=builder /workspace/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/app.jar"]