# Paso 1: Utiliza una imagen base con Maven para construir tu proyecto
FROM maven:3.8.4-openjdk-17 as builder

# Establece el token de SonarQube directamente (No recomendado para producción)
ENV SONAR_TOKEN="squ_e9fe96ad6be6d4da20511d696a682a4081cec9ca"

# Copia el código fuente del proyecto al contenedor
COPY src /home/app/src
COPY pom.xml /home/app

# Inserta el token de SonarQube en el archivo pom.xml
RUN sed -i "s|<sonar.login>.*</sonar.login>|<sonar.login>${SONAR_TOKEN}</sonar.login>|" /home/app/pom.xml

# Construye la aplicación
RUN mvn -f /home/app/pom.xml clean package

# Paso 2: Utiliza una imagen base de OpenJDK para ejecutar tu aplicación
FROM openjdk:17

# Copia el jar construido desde el paso de construcción al contenedor de ejecución
COPY --from=builder /home/app/target/modelo-0.0.1-SNAPSHOT.jar /usr/local/lib/modelo.jar

# Expone el puerto en el que tu aplicación escuchará
EXPOSE 8080

# Comando para ejecutar la aplicación
ENTRYPOINT ["java","-jar","/usr/local/lib/modelo.jar"]