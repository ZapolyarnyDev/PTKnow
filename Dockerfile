FROM gradle:8.12.0-jdk AS builder

WORKDIR /build

COPY src ./src
COPY build.gradle.kts settings.gradle.kts ./
COPY gradle ./gradle

RUN gradle bootJar --no-daemon

FROM eclipse-temurin:21-jre

ARG EXPOSE_PORT
ENV SERVER_PORT=${EXPOSE_PORT}

ENV JAVA_OPTS="-Xms512m -Xmx1024m -XX:+UseG1GC"

WORKDIR /app
COPY --from=builder /build/build/libs/app.jar app.jar

EXPOSE ${EXPOSE_PORT}

CMD ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]