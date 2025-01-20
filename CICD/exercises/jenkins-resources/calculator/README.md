
## 0.Instalación Jenkins
Vamos a la carpeta:

```
cd "C:\Users\hugin\Documents\repo_lemon_code\LemonCodeDevOps\CICD\exercises\jenkins-resources"
```

Generamos la imagen de Jenkins para poder realizar los ejercicios

```
docker build -t jenkins-gradle -f gradle.Dockerfile .
```

Levantamos el contenedor:
```
docker run -p 8080:8080 -p 50000:50000 jenkins-gradle

```

En el log de ejecución del contenedor aparece la contraseña de instalación necesaria para la configuración inicial que se solicitará al inicio:

![[Pasted image 20250108204353.png]]

Usamos el navegador para acceder a la configuración de Jenkins:

```
http://localhost:8080
```

Introducimos la contraseña de instalación que aparece en los logs:

Seguidamente instalamos los plugins recomendados.



## 1. Ubicación del Jenkinsfile en el repositorio

1. Colocar el "Jenkinsfile" en:
```
CICD/exercises/jenkins-resources/calculator/Jenkinsfile
```
**NOTA:**
Hay que asegurarse de que, en esa misma carpeta (calculator), esté el proyecto Java con los archivos build.gradle, gradlew, la carpeta gradle, etc. (o al menos que la ruta relativa haga sentido para que, al ejecutar ./gradlew compileJava y ./gradlew test, se encuentren los archivos necesarios).
**Ojo!, Hay que hacer commit para que esté el JenkinsFile en el repositorio.**

```
pipeline {

    agent any

  

    stages {

        stage('Checkout') {

            steps {

                // (Si todavía no has quitado tu bloque de checkout declarativo)

                checkout([$class: 'GitSCM',

                          branches: [[name: '*/main']],

                          userRemoteConfigs: [[url: 'https://github.com/jornkbz/LemonCodeDevOps.git']]])

            }

        }

  

        stage('Compile') {

            steps {

                dir('CICD/exercises/jenkins-resources/calculator') {

                    sh 'chmod +x ./gradlew'

                    sh './gradlew compileJava'

                }

            }

        }

  

        stage('Test') {

            steps {

                dir('CICD/exercises/jenkins-resources/calculator') {

                    sh './gradlew test'

                }

            }

        }

    }

}
```


## 2. Crear (o configurar) el job en Jenkins

1. En el "panel de Jenkins", pulsar en "New Item" o "Crear nuevo elemento".
2. Elegir "Pipeline" como tipo de proyecto y dar un nombre (por ejemplo, "calculator-pipeline").

## 3. Configurar la sección Pipeline

Dentro de la configuración del nuevo job:

1. Ir a la sección "Pipeline".
2. En "Definition", elegir "Pipeline script from SCM".
3. En "SCM", seleccionar "Git".
4. En "Repository URL", pegar la URL del repositorio, por ejemplo:
```
https://github.com/jornkbz/LemonCodeDevOps.git
```

5. Si tienes una rama específica, cámbiarla en "Branches to build" (en mi caso, "main" ).
6. En "Script Path" escribir la ruta al archivo Jenkinsfile dentro del repositorio, por ejemplo:

```
CICD/exercises/jenkins-resources/calculator/Jenkinsfile

```

Quedaría más o menos así:

- "Repository URL": `https://github.com/jornkbz/LemonCodeDevOps.git`
- "Script Path": `CICD/exercises/jenkins-resources/calculator/Jenkinsfile`

7. Guarda los cambios.

## 4. Ejecutar el Pipeline

1. En la página principal del nuevo job, hacer clic en "Build Now" (o "Ejecutar ahora").
2. Jenkins hará el checkout del repo completo, buscará el "Jenkinsfile" en la ruta que se ha definido y ejecutará los stages (Checkout, Compile, Test, etc.).

Salida de la consola tras ejecutar el pipeline:


```
Started by user admin

Obtained CICD/exercises/jenkins-resources/calculator/Jenkinsfile from git https://github.com/jornkbz/LemonCodeDevOps.git
[Pipeline] Start of Pipeline
[Pipeline] node
Running on Jenkins
 in /var/jenkins_home/workspace/calculator
[Pipeline] {
[Pipeline] stage
[Pipeline] { (Declarative: Checkout SCM)
[Pipeline] checkout
Selected Git installation does not exist. Using Default
The recommended git tool is: NONE
No credentials specified
 > git rev-parse --resolve-git-dir /var/jenkins_home/workspace/calculator/.git # timeout=10
Fetching changes from the remote Git repository
 > git config remote.origin.url https://github.com/jornkbz/LemonCodeDevOps.git # timeout=10
Fetching upstream changes from https://github.com/jornkbz/LemonCodeDevOps.git
 > git --version # timeout=10
 > git --version # 'git version 2.39.5'
 > git fetch --tags --force --progress -- https://github.com/jornkbz/LemonCodeDevOps.git +refs/heads/*:refs/remotes/origin/* # timeout=10
 > git rev-parse refs/remotes/origin/main^{commit} # timeout=10
Checking out Revision 052694032300388c2b782c5fbdb6e9cdfdc8adeb (refs/remotes/origin/main)
 > git config core.sparsecheckout # timeout=10
 > git checkout -f 052694032300388c2b782c5fbdb6e9cdfdc8adeb # timeout=10
Commit message: "permisos jenkinsfile"
 > git rev-list --no-walk d3c895493ac2c9f6c23ec1532147b06c49a2bc12 # timeout=10
[Pipeline] }
[Pipeline] // stage
[Pipeline] withEnv
[Pipeline] {
[Pipeline] stage
[Pipeline] { (Checkout)
[Pipeline] checkout
Selected Git installation does not exist. Using Default
The recommended git tool is: NONE
No credentials specified
 > git rev-parse --resolve-git-dir /var/jenkins_home/workspace/calculator/.git # timeout=10
Fetching changes from the remote Git repository
 > git config remote.origin.url https://github.com/jornkbz/LemonCodeDevOps.git # timeout=10
Fetching upstream changes from https://github.com/jornkbz/LemonCodeDevOps.git
 > git --version # timeout=10
 > git --version # 'git version 2.39.5'
 > git fetch --tags --force --progress -- https://github.com/jornkbz/LemonCodeDevOps.git +refs/heads/*:refs/remotes/origin/* # timeout=10
 > git rev-parse refs/remotes/origin/main^{commit} # timeout=10
Checking out Revision 052694032300388c2b782c5fbdb6e9cdfdc8adeb (refs/remotes/origin/main)
 > git config core.sparsecheckout # timeout=10
 > git checkout -f 052694032300388c2b782c5fbdb6e9cdfdc8adeb # timeout=10
Commit message: "permisos jenkinsfile"
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Compile)
[Pipeline] dir
Running in /var/jenkins_home/workspace/calculator/CICD/exercises/jenkins-resources/calculator
[Pipeline] {
[Pipeline] sh
+ chmod +x ./gradlew
[Pipeline] sh
+ ./gradlew compileJava
Downloading https://services.gradle.org/distributions/gradle-6.6.1-bin.zip

.........10%..........20%..........30%..........40%.........50%..........60%..........70%..........80%..........90%.........100%


Welcome to Gradle 6.6.1!

Here are the highlights of this release:
 - Experimental build configuration caching
 - Built-in conventions for handling credentials
 - Java compilation supports --release flag

For more details see https://docs.gradle.org/6.6.1/release-notes.html

Starting a Gradle Daemon (subsequent builds will be faster)

> Task :compileJava

BUILD SUCCESSFUL in 1m 28s
1 actionable task: 1 executed
[Pipeline] }
[Pipeline] // dir
[Pipeline] }

[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Test)
[Pipeline] dir
Running in /var/jenkins_home/workspace/calculator/CICD/exercises/jenkins-resources/calculator
[Pipeline] {
[Pipeline] sh
+ ./gradlew test

> Task :compileJava UP-TO-DATE
> Task :processResources
> Task :classes

> Task :compileTestJava
> Task :processTestResources NO-SOURCE
> Task :testClasses
> Task :test

BUILD SUCCESSFUL in 9s
4 actionable tasks: 3 executed, 1 up-to-date
[Pipeline] }
[Pipeline] // dir
[Pipeline] }
[Pipeline] // stage
[Pipeline] }
[Pipeline] // withEnv
[Pipeline] }
[Pipeline] // node
[Pipeline] End of Pipeline
Finished: SUCCESS

```


--------------------------------------------------------------------
# Ejercicio 2
---------------------------------------------------------------------
## 0. Instalación Jeckins dind:

```
cd "C:\Users\hugin\Documents\repo_lemon_code\LemonCodeDevOps\CICD\01-jenkins\00-instalando-jenkins"
```

En dicho directorio ejecutamos el comando:


```
docker-compose up 
```

**Nota**: El compose tira del Dockerfile y del .sh por lo que estos tres archivos deben de situarse en la misma carpeta.

Instalar además los pluggins Docker y Docker Pipeline.

## 1. Ubicación del Jenkinsfile en el repositorio

1. Colocar el `Jenkinsfile2` en:
```
CICD/exercises/jenkins-resources/calculator/
```
**NOTA:**
Hay que asegurarse de que , en esa misma carpeta (calculator), esté el proyecto Java con los archivos build.gradle, gradlew, la carpeta gradle, etc. (o al menos que la ruta relativa haga sentido para que, al ejecutar ./gradlew compileJava y ./gradlew test, se encuentren los archivos necesarios).

**Ojo!, Hay que hacer commit para que esté el JenkinsFile en el repositorio.**

```
pipeline {

    agent none

    options {

        // Evita que Jenkins haga checkout automático al entrar a un stage con 'agent'

        skipDefaultCheckout()

    }

    stages {

        stage('Checkout') {

            agent any

            steps {

                checkout([$class: 'GitSCM',

                          branches: [[name: '*/main']],

                          userRemoteConfigs: [[url: 'https://github.com/jornkbz/LemonCodeDevOps.git']]])

            }

        }

  

        stage('Build & Test') {

            agent {

                docker {

                    image 'gradle:6.6.1-jre14-openj9'

                    reuseNode true

                }

            }

            steps {

                // Asumiendo que tu Jenkinsfile y gradlew viven en:

                //    CICD/exercises/jenkins-resources/calculator/

                dir('CICD/exercises/jenkins-resources/calculator') {

                    sh 'chmod +x gradlew'

                    sh './gradlew compileJava'

                    sh './gradlew test'

                }

            }

        }

    }

}
```


## 2. Crear (o configurar) el job en Jenkins

1. En el **panel de Jenkins**, pulsar en "New Item" o "Crear nuevo elemento".
2. Elegir "Pipeline" como tipo de proyecto y dar un nombre (por ejemplo, "calculator-pipeline"`).

## 3. Configurar la sección Pipeline

Dentro de la configuración del nuevo job:

1. Ir a la sección "Pipeline".
2. En "Definition", elegir "Pipeline script from SCM".
3. En "SCM", seleccionar "Git".
4. En "Repository URL", pegar la URL del repositorio, por ejemplo:
```
https://github.com/jornkbz/LemonCodeDevOps.git
```

5. Si hay una específica, cámbiarla en "Branches to build" (en mi caso, "main" ).
6. En "Script Path" , escribe la ruta al archivo Jenkinsfile dentro del repositorio, por ejemplo:

```
CICD/exercises/jenkins-resources/calculator/Jenkinsfile2

```

Quedaría más o menos así:

- "Repository URL" `https://github.com/jornkbz/LemonCodeDevOps.git`
- "Script Path": `CICD/exercises/jenkins-resources/calculator/Jenkinsfile2`

7. Guarda los cambios.

## 4. Ejecutar el Pipeline

1. En la página principal del nuevo job, hacer clic en "Build Now" (o "Ejecutar ahora").
2. Jenkins hará el checkout del repo completo, buscará el "Jenkinsfile" en la ruta que definiste y ejecutará los stages (Checkout, Compile, Test, etc.).

Salida Jenkins:

```
Started by user admin

Obtained CICD/exercises/jenkins-resources/calculator/JenkinsFile2 from git https://github.com/jornkbz/LemonCodeDevOps.git
[Pipeline] Start of Pipeline
[Pipeline] stage
[Pipeline] { (Checkout)
[Pipeline] node
Running on Jenkins
 in /var/jenkins_home/workspace/calculator2
[Pipeline] {
[Pipeline] checkout
Selected Git installation does not exist. Using Default
The recommended git tool is: NONE
No credentials specified
 > git rev-parse --resolve-git-dir /var/jenkins_home/workspace/calculator2/.git # timeout=10
Fetching changes from the remote Git repository
 > git config remote.origin.url https://github.com/jornkbz/LemonCodeDevOps.git # timeout=10
Fetching upstream changes from https://github.com/jornkbz/LemonCodeDevOps.git
 > git --version # timeout=10
 > git --version # 'git version 2.39.5'
 > git fetch --tags --force --progress -- https://github.com/jornkbz/LemonCodeDevOps.git +refs/heads/*:refs/remotes/origin/* # timeout=10
 > git rev-parse refs/remotes/origin/main^{commit} # timeout=10
Checking out Revision a1d601ab2aa0d8db626f3ed4fb82206594ccc9e1 (refs/remotes/origin/main)
 > git config core.sparsecheckout # timeout=10
 > git checkout -f a1d601ab2aa0d8db626f3ed4fb82206594ccc9e1 # timeout=10
Commit message: "cambios jenk2"
 > git rev-list --no-walk a1d601ab2aa0d8db626f3ed4fb82206594ccc9e1 # timeout=10
[Pipeline] }
[Pipeline] // node
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Build & Test)
[Pipeline] getContext
[Pipeline] node
Running on Jenkins
 in /var/jenkins_home/workspace/calculator2
[Pipeline] {
[Pipeline] isUnix
[Pipeline] withEnv
[Pipeline] {
[Pipeline] sh
+ docker inspect -f . gradle:6.6.1-jre14-openj9
.
[Pipeline] }
[Pipeline] // withEnv
[Pipeline] withDockerContainer
Jenkins seems to be running inside container bd65e6281c3afb52195da1948626b69e7a54dba8ee17612a328cbd94081957f3
but /var/jenkins_home/workspace/calculator2 could not be found among []
but /var/jenkins_home/workspace/calculator2@tmp could not be found among []
$ docker run -t -d -u 1000:1000 -w /var/jenkins_home/workspace/calculator2 -v /var/jenkins_home/workspace/calculator2:/var/jenkins_home/workspace/calculator2:rw,z -v /var/jenkins_home/workspace/calculator2@tmp:/var/jenkins_home/workspace/calculator2@tmp:rw,z -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** gradle:6.6.1-jre14-openj9 cat
$ docker top af07f426e3eb30dbca8be8f7e29c7a9c4bce3d81f594ce57afb6fdc02950325e -eo pid,comm
[Pipeline] {
[Pipeline] dir
Running in /var/jenkins_home/workspace/calculator2/CICD/exercises/jenkins-resources/calculator
[Pipeline] {
[Pipeline] sh
+ chmod +x gradlew
[Pipeline] sh
+ ./gradlew compileJava
Downloading https://services.gradle.org/distributions/gradle-6.6.1-bin.zip
.........10%..........20%..........30%..........40%.........50%..........60%..........70%..........80%..........90%.........100%

Welcome to Gradle 6.6.1!

Here are the highlights of this release:
 - Experimental build configuration caching
 - Built-in conventions for handling credentials
 - Java compilation supports --release flag

For more details see https://docs.gradle.org/6.6.1/release-notes.html

Starting a Gradle Daemon (subsequent builds will be faster)
> Task :compileJava UP-TO-DATE

BUILD SUCCESSFUL in 1m 59s
1 actionable task: 1 up-to-date
[Pipeline] sh
+ ./gradlew test
> Task :compileJava UP-TO-DATE
> Task :processResources UP-TO-DATE
> Task :classes UP-TO-DATE
> Task :compileTestJava UP-TO-DATE
> Task :processTestResources NO-SOURCE
> Task :testClasses UP-TO-DATE
> Task :test UP-TO-DATE

BUILD SUCCESSFUL in 9s
4 actionable tasks: 4 up-to-date
[Pipeline] }
[Pipeline] // dir
[Pipeline] }
$ docker stop --time=1 af07f426e3eb30dbca8be8f7e29c7a9c4bce3d81f594ce57afb6fdc02950325e
$ docker rm -f --volumes af07f426e3eb30dbca8be8f7e29c7a9c4bce3d81f594ce57afb6fdc02950325e
[Pipeline] // withDockerContainer
[Pipeline] }
[Pipeline] // node
[Pipeline] }
[Pipeline] // stage
[Pipeline] End of Pipeline
Finished: SUCCESS

```


![[Pasted image 20250118145929.png]]

![[Pasted image 20250118145900.png]]

![[Pasted image 20250118150001.png]]