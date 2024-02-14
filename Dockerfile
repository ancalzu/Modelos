# Paso 1: Utiliza una imagen base con Maven para construir tu proyecto
FROM maven:3.8.4-openjdk-17 as builder

# Copia el código fuente del proyecto al contenedor
COPY src /home/app/src
COPY pom.xml /home/app

# Ejecuta PMD check para análisis estático del código
RUN mvn -f /home/app/pom.xml pmd:check

# Construye la aplicación (solo se ejecutará si PMD check es exitoso)
RUN mvn -f /home/app/pom.xml clean package

# Paso 2: Utiliza una imagen base de OpenJDK para ejecutar tu aplicación
FROM openjdk:17

# Copia el jar construido desde el paso de construcción al contenedor de ejecución
COPY --from=builder /home/app/target/modelo-0.0.1-SNAPSHOT.jar /usr/local/lib/modelo.jar

# Expone el puerto en el que tu aplicación escuchará
EXPOSE 8080

# Comando para ejecutar la aplicación
ENTRYPOINT ["java","-jar","/usr/local/lib/modelo.jar"]