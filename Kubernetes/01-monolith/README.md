## 1 ConfigMap de PostgreSQL (credenciales)
Creamos el configmap para postgreSQL
```
apiVersion: v1
kind: ConfigMap
metadata:
  name: db-config
data:
  POSTGRES_DB: "todos_db"
  POSTGRES_USER: "postgres"
  POSTGRES_PASSWORD: "postgres"

```

Aplicamos el fichero

```
kubectl apply -f db-configmap.yaml
```

## 2 StorageClass para aprovisionamiento dinámico

Creamos el storage-class:

```
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: standard
provisioner: k8s.io/minikube-hostpath
volumeBindingMode: Immediate

```

Aplicamos el fichero:
```
kubectl apply -f storage-class.yaml
```

## 3 PersistentVolumeClaim (PVC) para PostgreSQL
Esta PVC pedirá 1Gi al StorageClass standard. No necesitamos crear un PersistentVolume manualmente, ya que lo generará dinámicamente.

```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: postgres-pvc
spec:
  storageClassName: standard
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi

```

Aplicamos el fichero:

```
kubectl apply -f db-pvc.yaml
```
 
## 4 Service de PostgeSQL (ClusterIP)
Creamos un Service interno para que la app Node.js (u otros pods) puedan conectarse a la base de datos por DNS postgres-service.

```
apiVersion: v1
kind: Service
metadata:
  name: postgres-service
spec:
  type: ClusterIP
  selector:
    app: postgres
  ports:
    - name: postgres
      protocol: TCP
      port: 5432
      targetPort: 5432

```

Aplicamos el fichero

```
kubectl apply -f db-service.yaml
```

## 5 StatefulSet de PostgreSQL (usando imagen oficial)

```
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: postgres-statefulset
spec:
  serviceName: postgres-service
  replicas: 1
  selector:
    matchLabels:
      app: postgres
  template:
    metadata:
      labels:
        app: postgres
    spec:
      containers:
        - name: postgres
          image: "postgres:10.4"
          env:
            - name: POSTGRES_DB
              valueFrom:
                configMapKeyRef:
                  name: db-config
                  key: POSTGRES_DB
            - name: POSTGRES_USER
              valueFrom:
                configMapKeyRef:
                  name: db-config
                  key: POSTGRES_USER
            - name: POSTGRES_PASSWORD
              valueFrom:
                configMapKeyRef:
                  name: db-config
                  key: POSTGRES_PASSWORD
          ports:
            - containerPort: 5432
          volumeMounts:
            - name: postgres-data
              mountPath: /var/lib/postgresql/data
      volumes:
        - name: postgres-data
          persistentVolumeClaim:
            claimName: postgres-pvc

```


Aplicamos fichero:

```
kubectl apply -f db-statefulset.yaml
```

Verificamos que el pod esté en running:

```
kubectl get pods
```


## 6 ConfigMap con el script todos_db.sql
En este ConfigMap vamos a guardar todo el contenido del script todos_db.sql para crear y poblar la base de datos con tus tablas, datos iniciales, etc.
```
apiVersion: v1

kind: ConfigMap

metadata:

  name: db-seed-script

data:

  todos_db.sql: |

    -- PostgreSQL database dump

    --

  

    -- Dumped from database version 10.4 (Debian 10.4-2.pgdg90+1)

    -- Dumped by pg_dump version 10.4 (Debian 10.4-2.pgdg90+1)

  

    SET statement_timeout = 0;

    SET lock_timeout = 0;

    SET idle_in_transaction_session_timeout = 0;

    SET client_encoding = 'UTF8';

    SET standard_conforming_strings = on;

    SELECT pg_catalog.set_config('search_path', '', false);

    SET check_function_bodies = false;

    SET client_min_messages = warning;

    SET row_security = off;

  

    --

    -- Name: plpgsql; Type: EXTENSION; Schema: -; Owner:

    --

  

    CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;

  
  

    --

    -- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner:

    --

  

    COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';

  
  

    SET default_tablespace = '';

  

    SET default_with_oids = false;

  

    --

    -- Name: migrations; Type: TABLE; Schema: public; Owner: postgres

    --

  

    CREATE DATABASE todos_db;

  

    \c todos_db

  

    CREATE TABLE public.migrations (

        id integer NOT NULL,

        name character varying(255),

        batch integer,

        migration_time timestamp with time zone

    );

  
  

    ALTER TABLE public.migrations OWNER TO postgres;

  

    --

    -- Name: migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres

    --

  

    CREATE SEQUENCE public.migrations_id_seq

        AS integer

        START WITH 1

        INCREMENT BY 1

        NO MINVALUE

        NO MAXVALUE

        CACHE 1;

  
  

    ALTER TABLE public.migrations_id_seq OWNER TO postgres;

  

    --

    -- Name: migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres

    --

  

    ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;

  
  

    --

    -- Name: migrations_lock; Type: TABLE; Schema: public; Owner: postgres

    --

  

    CREATE TABLE public.migrations_lock (

        index integer NOT NULL,

        is_locked integer

    );

  
  

    ALTER TABLE public.migrations_lock OWNER TO postgres;

  

    --

    -- Name: migrations_lock_index_seq; Type: SEQUENCE; Schema: public; Owner: postgres

    --

  

    CREATE SEQUENCE public.migrations_lock_index_seq

        AS integer

        START WITH 1

        INCREMENT BY 1

        NO MINVALUE

        NO MAXVALUE

        CACHE 1;

  
  

    ALTER TABLE public.migrations_lock_index_seq OWNER TO postgres;

  

    --

    -- Name: migrations_lock_index_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres

    --

  

    ALTER SEQUENCE public.migrations_lock_index_seq OWNED BY public.migrations_lock.index;

  
  

    --

    -- Name: todos; Type: TABLE; Schema: public; Owner: postgres

    --

  

    CREATE TABLE public.todos (

        id integer NOT NULL,

        title character varying(255) NOT NULL,

        completed boolean NOT NULL,

        due_date timestamp with time zone,

        "order" integer

    );

  
  

    ALTER TABLE public.todos OWNER TO postgres;

  

    --

    -- Name: todos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres

    --

  

    CREATE SEQUENCE public.todos_id_seq

        AS integer

        START WITH 1

        INCREMENT BY 1

        NO MINVALUE

        NO MAXVALUE

        CACHE 1;

  
  

    ALTER TABLE public.todos_id_seq OWNER TO postgres;

  

    --

    -- Name: todos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres

    --

  

    ALTER SEQUENCE public.todos_id_seq OWNED BY public.todos.id;

  
  

    --

    -- Name: migrations id; Type: DEFAULT; Schema: public; Owner: postgres

    --

  

    ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);

  
  

    --

    -- Name: migrations_lock index; Type: DEFAULT; Schema: public; Owner: postgres

    --

  

    ALTER TABLE ONLY public.migrations_lock ALTER COLUMN index SET DEFAULT nextval('public.migrations_lock_index_seq'::regclass);

  
  

    --

    -- Name: todos id; Type: DEFAULT; Schema: public; Owner: postgres

    --

  

    ALTER TABLE ONLY public.todos ALTER COLUMN id SET DEFAULT nextval('public.todos_id_seq'::regclass);

  
  

    --

    -- Data for Name: migrations; Type: TABLE DATA; Schema: public; Owner: postgres

    --

  

    COPY public.migrations (id, name, batch, migration_time) FROM stdin;

    1 20201122205735_create_todos_table.js  1 2020-12-04 09:26:30.428+00

    2 20201123104711_update_todos_table.js  1 2020-12-04 09:26:30.433+00

    \.

  
  

    --

    -- Data for Name: migrations_lock; Type: TABLE DATA; Schema: public; Owner: postgres

    --

  

    COPY public.migrations_lock (index, is_locked) FROM stdin;

    1 0

    \.

  
  

    --

    -- Data for Name: todos; Type: TABLE DATA; Schema: public; Owner: postgres

    --

  

    COPY public.todos (id, title, completed, due_date, "order") FROM stdin;

    12  Learn Jenkins f 2020-12-04 18:37:44.234+00  \N

    13  Learn GitLab  t 2020-12-04 18:38:06.993+00  \N

    21  Learn K8s f 2020-12-04 19:12:16.174+00  \N

    \.

  
  

    --

    -- Name: migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres

    --

  

    SELECT pg_catalog.setval('public.migrations_id_seq', 2, true);

  
  

    --

    -- Name: migrations_lock_index_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres

    --

  

    SELECT pg_catalog.setval('public.migrations_lock_index_seq', 1, true);

  
  

    --

    -- Name: todos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres

    --

  

    SELECT pg_catalog.setval('public.todos_id_seq', 21, true);

  
  

    --

    -- Name: migrations_lock migrations_lock_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres

    --

  

    ALTER TABLE ONLY public.migrations_lock

        ADD CONSTRAINT migrations_lock_pkey PRIMARY KEY (index);

  
  

    --

    -- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres

    --

  

    ALTER TABLE ONLY public.migrations

        ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);

  
  

    --

    -- Name: todos todos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres

    --

  

    ALTER TABLE ONLY public.todos

        ADD CONSTRAINT todos_pkey PRIMARY KEY (id);

  
  

    --

    -- PostgreSQL database dump complete

    --
```


Aplicamos fichero:
```
kubectl apply -f db-seed-configmap.yaml

```


## 7 Job para hacer el seed de la base de datos

Este Job arrancará un contenedor basado en postgres:10.4 (que incluye la herramienta psql), montará el ConfigMap anterior como un fichero todos_db.sql y ejecutará:
ESTO ES MERAMENTE EXPLICATIVO NO EJECUTAR, YA QUE SE EJECUTA EN EL ARCHIVO db-seed-job.yaml
```
psql -h postgres-service -U postgres -p 5432 -f /tmp/sql/todos_db.sql
```

Creamos el fichero:

```

apiVersion: batch/v1

kind: Job

metadata:

  name: db-seed-job

spec:

  template:

    metadata:

      name: db-seed-job-pod

    spec:

      restartPolicy: Never

      containers:

        - name: seed-container

          image: postgres:10.4

          # Establecer la contraseña en la variable de entorno:

          env:

            - name: PGPASSWORD

              value: "postgres"

          # Usar /bin/sh -c e indicar el comando psql en un solo arg (una sola línea)

          command: ["/bin/sh", "-c"]

          args:

            - psql -h postgres-service -U postgres -p 5432 -f /tmp/sql/todos_db.sql

          volumeMounts:

            - name: seed-volume

              mountPath: /tmp/sql

      volumes:

        - name: seed-volume

          configMap:

            name: db-seed-script

            items:

              - key: todos_db.sql

                path: todos_db.sql
```


Aplicamos fichero:

```
kubectl apply -f db-seed-job.yaml
```

Comprobamos job:

```
kubectl get jobs

```
![[Pasted image 20250103132234.png]]

Y el pod que crea:

```
kubectl get pods
```
![[Pasted image 20250103132301.png]]

Si no se completa puede buscar el error en el log:
```
kubectl logs job/db-seed-job
```

#### 8 ConfigMap para todo-app (Node.js)
Creamos ahora otro ConfigMap con las variables de entorno que usará la app Node.js (puerto, credenciales de DB, etc.).

```
apiVersion: v1
kind: ConfigMap
metadata:
  name: todoapp-config
data:
  # Entorno
  NODE_ENV: "production"

  # Puerto interno
  PORT: "3000"

  # Base de datos
  DB_HOST: "postgres-service"
  DB_USER: "postgres"
  DB_PASSWORD: "postgres"
  DB_PORT: "5432"
  DB_NAME: "todos_db"
  DB_VERSION: "10.4"

```

Aplicamos fichero:

```
kubectl apply -f todoapp-configmap.yaml
```

## 9 Deployment de todo-app

Desplegamos la app Node.js. Suponiendo que tenemos una imagen Docker ya construida (por ejemplo: lemoncodersbc/lc-todo-monolith-db:v5-2024 o una propia), la usaremos como contenedor.
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: todoapp-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: todoapp
  template:
    metadata:
      labels:
        app: todoapp
    spec:
      containers:
        - name: todoapp
          image: "lemoncodersbc/lc-todo-monolith-db:v5-2024"
          ports:
            - containerPort: 3000
          env:
            - name: NODE_ENV
              valueFrom:
                configMapKeyRef:
                  name: todoapp-config
                  key: NODE_ENV
            - name: PORT
              valueFrom:
                configMapKeyRef:
                  name: todoapp-config
                  key: PORT
            - name: DB_HOST
              valueFrom:
                configMapKeyRef:
                  name: todoapp-config
                  key: DB_HOST
            - name: DB_USER
              valueFrom:
                configMapKeyRef:
                  name: todoapp-config
                  key: DB_USER
            - name: DB_PASSWORD
              valueFrom:
                configMapKeyRef:
                  name: todoapp-config
                  key: DB_PASSWORD
            - name: DB_PORT
              valueFrom:
                configMapKeyRef:
                  name: todoapp-config
                  key: DB_PORT
            - name: DB_NAME
              valueFrom:
                configMapKeyRef:
                  name: todoapp-config
                  key: DB_NAME
            - name: DB_VERSION
              valueFrom:
                configMapKeyRef:
                  name: todoapp-config
                  key: DB_VERSION

```

Aplicamos configuración:

```
kubectl apply -f todoapp-deployment.yaml

```


## 10 Service de tipo LoadBalancer para todo-app
Por último, exponemos la aplicación externamente. En Minikube, simulamos un LoadBalancer con minikube service o minikube tunnel.

```
apiVersion: v1
kind: Service
metadata:
  name: todoapp-loadbalancer
spec:
  type: LoadBalancer
  selector:
    app: todoapp
  ports:
    - name: http
      port: 80
      targetPort: 3000

```


Aplicamos fichero:

```
kubectl apply -f todoapp-service.yaml

```

Ahora en otro terminal a adicional usar el comando:

```
minikube tunnel
```

Volvemos al terminal anterior ya que este donde ejecutamos el tunnel se quedará ejecutando el proceso continuamente y comprobamos la IP que se nos ha asignado tras aplicar el fichero todoapp-service.yaml

![[Pasted image 20250103133556.png]]


Como se indica, abrimos navegador y vamos a la dirección 127.0.0.1:80

![[Pasted image 20250103133717.png]]