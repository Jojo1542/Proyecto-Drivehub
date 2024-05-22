FROM gradle:8.4.0-jdk17-alpine AS build

COPY --chown=gradle:gradle . /home/gradle/src
WORKDIR /home/gradle/src

RUN gradle spotlessApply build --no-daemon

FROM eclipse-temurin:17-jre-focal

# In case of need to expose port
EXPOSE 8443

RUN mkdir /app

COPY --from=build /home/gradle/src/bot/build/libs/*.jar /app/application.jar
COPY --from=build /home/gradle/src/bot/src/main/resources /app/data

# As we need to get the data from the bot, we need to set the working directory to /app
WORKDIR /app

ENTRYPOINT ["java", "-jar", "/app/application.jar"]