FROM gradle:8.4.0-jdk17-alpine AS build

COPY --chown=gradle:gradle . /home/gradle/src
WORKDIR /home/gradle/src

RUN gradle bootJar --no-daemon

FROM eclipse-temurin:17-jre-focal

MAINTAINER "José Antonio Ponce Piñero <"
LABEL description="Dockerfile para DriveHub"
LABEL version="1.0"
LABEL maintainer="José Antonio Ponce Piñero"

EXPOSE 8080

RUN mkdir /app

COPY --from=build /home/gradle/src/build/libs/*.jar /app/application.jar

WORKDIR /app

ENTRYPOINT ["java", "-jar", "/app/application.jar"]