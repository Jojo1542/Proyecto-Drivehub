plugins {
	java
	id("org.springframework.boot") version "3.2.4"
	id("io.spring.dependency-management") version "1.1.4"
}

group = "es.iesmm.proyecto.drivehub"
version = "0.0.1-SNAPSHOT"

java {
	sourceCompatibility = JavaVersion.VERSION_17
}

configurations {
	compileOnly {
		extendsFrom(configurations.annotationProcessor.get())
	}
}

repositories {
	mavenCentral()
}

extra["sentryVersion"] = "7.3.0"

dependencies {
	// Spring Boot packs
	implementation("org.springframework.boot:spring-boot-starter-data-jpa")
	implementation("org.springframework.boot:spring-boot-starter-web")
	implementation("org.springframework.boot:spring-boot-starter-websocket")
    //implementation("org.springframework.boot:spring-boot-starter-actuator")

    // Spring Boot DevTools
	annotationProcessor("org.springframework.boot:spring-boot-configuration-processor")
	developmentOnly("org.springframework.boot:spring-boot-devtools")

	// Spring Security
	implementation("org.springframework.security:spring-security-core")
	implementation("org.springframework.security:spring-security-crypto")
	implementation("org.springframework.security:spring-security-config")
	implementation("org.springframework.security:spring-security-web")

	// Spring Actuator
	//implementation("org.springframework:spring-jcl")

	// Addons de Hibernate
	implementation("org.hibernate.validator:hibernate-validator:8.0.1.Final")

	// Jackson JSON Processor
	implementation("com.fasterxml.jackson.core:jackson-core:2.17.0")
	implementation("com.fasterxml.jackson.core:jackson-databind:2.17.0")

	// JWT
	implementation("io.jsonwebtoken:jjwt-api:0.12.3")
	implementation("io.jsonwebtoken:jjwt-impl:0.12.3")
	implementation("io.jsonwebtoken:jjwt-jackson:0.12.3")

	// Lombok
	compileOnly("org.projectlombok:lombok")
	annotationProcessor("org.projectlombok:lombok")

	// Database drivers
	runtimeOnly("com.oracle.database.jdbc:ojdbc11")

	// Librerías utiles
	implementation("org.apache.commons:commons-lang3:3.14.0")
	implementation("com.google.guava:guava:33.1.0-jre")

	// Test
	testImplementation("org.springframework.boot:spring-boot-starter-test")
	testImplementation("org.springframework.security:spring-security-test")
}

tasks.withType<Test> {
	useJUnitPlatform()
}
