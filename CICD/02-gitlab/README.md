## Ejercicio 1

1. El primer paso sería levantar Gitlab en WSL, para ello, hay que copiar el proyecto e ir a la carpeta donde se encuentra el sh gitlab_environment.sh

2. Seleccionar opción 1
3. En el siguiente paso seleccionar también opción 1

![image](https://github.com/user-attachments/assets/00817149-01a7-4863-85bf-94c23f3227af)



4. Cuando descargue las imágenes el script comenzará a ejecutar comprobaciones de conexión con el contendor:
![image](https://github.com/user-attachments/assets/1e5e0f0c-f76f-49f7-88c1-7ab69ea3a517)


5. Hay que esperar bastante tiempo(varios minutos) a que consiga conectarse, es normal que haga muchos intentos sin éxito, solo hay que esperar a que muestre esto:
Indicando que la conexión ha sido exitosa.
![image](https://github.com/user-attachments/assets/d7c65125-6425-4ff0-b582-2f0d907a9557)

6. Se crea grupo y proyecto en blanco:

![image](https://github.com/user-attachments/assets/01bc66ee-2841-4864-8423-7c55b314a413)


7. Nos descargamos el proyecto vacio y añadimos a el el contenido de la carpeta springapp proporcionada para el ejercicio.

8. Seguidamente subimos el proyecto con comandos git, antes debemos configurar correo y nombre de git por consola si es la primera vez que lo usamos :
![image](https://github.com/user-attachments/assets/0340f4b5-41d3-44a8-b8ab-cf986cefb8db)


9. Hacemos comiit y push para subir los ficheros
![image](https://github.com/user-attachments/assets/313291c9-9ec4-4b25-b00a-13a410e8ee95)


10. Ahora quedaría crear  pipeline para ello creamos el yml o bine mediante interfaz o creándolo en local y subiéndolo al repo.
```
# Este archivo define la configuración de la pipeline de GitLab CI/CD para una aplicación Spring.
# Se han establecido cuatro etapas principales: 
# 1) maven_build   2) maven_test   3) docker   4) deploy

stages:
  - maven_build
  - maven_test
  - docker
  - deploy

# La sección "default" establece un caché para las dependencias de Maven, 
# de modo que se puedan reutilizar en lugar de descargarlas en cada job.
default:
  cache:
    key: default-m2-repository
    paths:
      - .m2/repository

# Se definen variables que se utilizarán en los jobs de Maven.
# MAVEN_OPTS establece la ubicación local del repositorio y opciones de logging.
# MAVEN_CLI_OPTS contiene parámetros genéricos para los comandos de Maven.
variables:
  MAVEN_OPTS: "-Dmaven.repo.local=.m2/repository -Dorg.slf4j.simpleLogger.showDateTime=true -Dorg.slf4j.simpleLogger.dateTimeFormat=HH:mm:ss,SSS -Djava.awt.headless=true"
  MAVEN_CLI_OPTS: "--batch-mode --errors --fail-at-end --show-version -U -s settings.xml"

# Job: maven-build
# Compila la aplicación con Maven, omitiendo los tests (skipTests) para acelerar la build.
# Se generan archivos .jar en la carpeta "target/", que se guardan como artifacts.
maven-build:
  stage: maven_build
  image: maven:3.9.5-eclipse-temurin-21
  script:
    - mvn $MAVEN_CLI_OPTS clean package -DskipTests
  artifacts:
    when: on_success
    paths:
      - "target/*.jar"

# Job: maven-test
# Ejecuta los tests de la aplicación con Maven (mvn verify).
# Genera reportes JUnit para que GitLab pueda mostrar un resumen de las pruebas.
maven-test:
  stage: maven_test
  image: maven:3.9.5-eclipse-temurin-21
  script:
    - mvn $MAVEN_CLI_OPTS verify
  artifacts:
    when: on_success
    reports:
      junit:
        - target/surefire-reports/TEST-*.xml

# Job: docker-build
# Construye la imagen Docker de la aplicación a partir del Dockerfile, 
# usando el artefacto .jar generado en el job maven-build.
# A continuación, sube la imagen al registro de GitLab.
docker-build:
  stage: docker
  dependencies:
    - maven-build
  before_script:
    # Se inicia sesión en el registro de GitLab para poder hacer push de la imagen.
    - docker login -u $CI_REGISTRY_USER -p $CI_JOB_TOKEN $CI_REGISTRY/$CI_PROJECT_PATH
  script:
    # Se imprimen algunas variables por motivos de depuración (aunque no se recomienda mostrar credenciales en logs).
    - echo $CI_REGISTRY $CI_REGISTRY_USER $CI_REGISTRY_PASSWORD
    # Construye la imagen y la etiqueta con el SHA del commit.
    - docker build -t $CI_REGISTRY/$CI_PROJECT_PATH:$CI_COMMIT_SHA .
    # Envía la imagen al registro asociado al proyecto.
    - docker push $CI_REGISTRY/$CI_PROJECT_PATH:$CI_COMMIT_SHA
  cache: []

# Job: deploy
# Despliega la aplicación en local, creando un contenedor con la imagen generada.
# Se elimina cualquier contenedor anterior que coincida con el nombre "springapp".
deploy:
  stage: deploy
  image: docker:latest
  before_script:
    - docker login -u "$CI_REGISTRY_USER" -p "$CI_JOB_TOKEN" "$CI_REGISTRY"
    # Se verifica si existe un contenedor llamado "springapp"; en caso afirmativo, se elimina.
    - if [ "$(docker ps -a --filter "name=springapp" --format '{{.Names}}')" = "springapp" ]; then
        docker rm -f springapp;
      else
        echo "No existe contenedor anterior";
      fi
  script:
    # Se levanta un contenedor nuevo en segundo plano, exponiendo el puerto 8080 para acceder a la aplicación.
    - docker run --name "springapp" -d -p 8080:8080 "$CI_REGISTRY/$CI_PROJECT_PATH:$CI_COMMIT_SHA"
  cache: []

```

11. Resultado:
![image](https://github.com/user-attachments/assets/c54e4199-63ab-401b-859c-1c92e0d4cbfd)



![image](https://github.com/user-attachments/assets/87fa5813-7fc4-48fb-aaef-ba949f1547e3)


![image](https://github.com/user-attachments/assets/c8d1e53b-6ef6-4b3a-9a85-dfdf2581ecc3)

![image](https://github.com/user-attachments/assets/5954ef0b-55c8-432c-8f98-fe26b672cdfc)



![image](https://github.com/user-attachments/assets/186d0b86-2a62-45bf-8753-1a1270f6da90)


![image](https://github.com/user-attachments/assets/694a9e58-da81-4093-921b-f2638328af8f)

![image](https://github.com/user-attachments/assets/5ed775c3-a2a0-4856-817e-1f0bcff9f4c0)



![image](https://github.com/user-attachments/assets/f26b07ca-15bb-4042-8dc5-185f28e33ece)


![image](https://github.com/user-attachments/assets/59a99c03-e37d-468f-8f1d-18ac9af3cead)



```
2025-01-20 22:44:39 
2025-01-20 22:44:39   .   ____          _            __ _ _
2025-01-20 22:44:39  /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
2025-01-20 22:44:39 ( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
2025-01-20 22:44:39  \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
2025-01-20 22:44:39   '  |____| .__|_| |_|_| |_\__, | / / / /
2025-01-20 22:44:39  =========|_|==============|___/=/_/_/_/
2025-01-20 22:44:39  :: Spring Boot ::                (v3.1.0)
2025-01-20 22:44:39 
2025-01-20 22:44:39 2025-01-20T21:44:39.543Z  INFO 1 --- [           main] com.example.HelloWorldApplication        : Starting HelloWorldApplication v1.0.0-SNAPSHOT using Java 21.0.5 with PID 1 (/app/app.jar started by root in /app)
2025-01-20 22:44:39 2025-01-20T21:44:39.546Z  INFO 1 --- [           main] com.example.HelloWorldApplication        : No active profile set, falling back to 1 default profile: "default"
2025-01-20 22:44:40 2025-01-20T21:44:40.351Z  INFO 1 --- [           main] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat initialized with port(s): 8080 (http)
2025-01-20 22:44:40 2025-01-20T21:44:40.364Z  INFO 1 --- [           main] o.apache.catalina.core.StandardService   : Starting service [Tomcat]
2025-01-20 22:44:40 2025-01-20T21:44:40.364Z  INFO 1 --- [           main] o.apache.catalina.core.StandardEngine    : Starting Servlet engine: [Apache Tomcat/10.1.8]
2025-01-20 22:44:40 2025-01-20T21:44:40.454Z  INFO 1 --- [           main] o.a.c.c.C.[Tomcat].[localhost].[/]       : Initializing Spring embedded WebApplicationContext
2025-01-20 22:44:40 2025-01-20T21:44:40.455Z  INFO 1 --- [           main] w.s.c.ServletWebServerApplicationContext : Root WebApplicationContext: initialization completed in 848 ms
2025-01-20 22:44:40 2025-01-20T21:44:40.747Z  INFO 1 --- [           main] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat started on port(s): 8080 (http) with context path ''
2025-01-20 22:44:40 2025-01-20T21:44:40.763Z  INFO 1 --- [           main] com.example.HelloWorldApplication        : Started HelloWorldApplication in 1.61 seconds (process running for 2.008)
2025-01-20 22:51:50 2025-01-20T21:51:50.149Z  INFO 1 --- [nio-8080-exec-1] o.a.c.c.C.[Tomcat].[localhost].[/]       : Initializing Spring DispatcherServlet 'dispatcherServlet'
2025-01-20 22:51:50 2025-01-20T21:51:50.150Z  INFO 1 --- [nio-8080-exec-1] o.s.web.servlet.DispatcherServlet        : Initializing Servlet 'dispatcherServlet'
2025-01-20 22:51:50 2025-01-20T21:51:50.151Z  INFO 1 --- [nio-8080-exec-1] o.s.web.servlet.DispatcherServlet        : Completed initialization in 1 ms
```



## Ejercicio 2



1. Se crean los usuarios desde el panel de administrador :
![image](https://github.com/user-attachments/assets/550a9161-acf5-4a66-bc09-5b0df5d35344)



2. Se selecciona el proyecto:

![image](https://github.com/user-attachments/assets/6cec6545-38a7-4b8b-becb-a1f7803892e1)



3. Se invitan al proyecto y se le asignan el rol


![image](https://github.com/user-attachments/assets/31f26421-f87d-4eaa-8d92-aad0acb9dabf)


4. Pruebas:

| Acción                                   | Guest<br>               | Reporter                                             | Developer                                 | Maintainer                                          |
| ---------------------------------------- | ----------------------- | ---------------------------------------------------- | ----------------------------------------- | --------------------------------------------------- |
| **Commit**                               | No                      | No                                                   | Sí                                        | Sí                                                  |
| **Ejecutar pipeline manualmente**        | No                      | No                                                   | Sí                                        | Sí                                                  |
| **Push y Pull del repositorio**          | No<br>(ni push ni pull) | Pull: Sí  <br>Push: No                               | Pull: Sí  <br>Push: Sí                    | Pull: Sí  <br>Push: Sí                              |
| **Crear Merge Request**                  | No                      | Sí  <br>(puede crear MRs, aunque no mergear cambios) | Sí  <br>(puede crear y participar en MRs) | Sí  <br>(puede crear y además fusionar/mergear)     |
| **Acceder a la administración del repo** | No                      | No                                                   | No                                        | Sí  <br>(gestionar settings, miembros, CI/CD, etc.) |






