FROM gradle:8.4.0-jdk17-alpine AS build

COPY --chown=gradle:gradle . /home/gradle/src
WORKDIR /home/gradle/src

RUN gradle bootJar --no-daemon

FROM eclipse-temurin:17-jre-focal

MAINTAINER "José Antonio Ponce Piñero <"
LABEL description="Dockerfile para DriveHub"
LABEL version="1.0"
LABEL maintainer="José Antonio Ponce Piñero"

EXPOSE 8443

RUN mkdir /app

COPY --from=build /home/gradle/src/build/libs/*.jar /app/application.jar

# As we need to get the data from the bot, we need to set the working directory to /app
WORKDIR /app

#ENTRYPOINT ["java", "-jar", "/app/application.jar"]
ENTRYPOINT ["tail"]
CMD ["-f","/dev/null"]