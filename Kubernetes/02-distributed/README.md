## 1 front-todo deploy

Creamos el deploy de front-todo

```
apiVersion: apps/v1

kind: Deployment

metadata:

  name: todo-front

spec:

  replicas: 1

  selector:

    matchLabels:

      app: todo-front

  template:

    metadata:

      labels:

        app: todo-front

    spec:

      containers:

      - name: todo-front

        image: lemoncodersbc/lc-todo-front:v5-2024

        ports:

        - containerPort: 80

```

Aplicamos configuración:

```
kubectl apply -f front-deployment.yaml
```

Seguidamente creamos el servicio:

```
apiVersion: v1

kind: Service

metadata:

  name: todo-front

spec:

  type: ClusterIP

  selector:

    app: todo-front

  ports:

    - port: 80

      targetPort: 80

      protocol: TCP
```

Aplicamos configuración:

```
kubectl apply -f front-service.yaml
```


## 2 todo-api 
Creamos el configmap:

```
apiVersion: v1

kind: ConfigMap

metadata:

  name: todo-api-config

data:

  NODE_ENV: production

  PORT: "3000"
```

Aplicamos configuración:

```
kubectl apply -f todo-configmap.yaml
```


Creamos el deployment:


```
apiVersion: apps/v1

kind: Deployment

metadata:

  name: todo-api

spec:

  replicas: 1

  selector:

    matchLabels:

      app: todo-api

  template:

    metadata:

      labels:

        app: todo-api

    spec:

      containers:

      - name: todo-api

        image: lemoncodersbc/lc-todo-api:v5-2024

        envFrom:

        - configMapRef:

            name: todo-api-config

        ports:

        - containerPort: 3000
```

Aplicamos configuración:

```
kubectl apply -f todo-deployment.yaml
```


Creamos servicio:

```
apiVersion: v1
kind: Service
metadata:
  name: todo-api
spec:
  type: ClusterIP
  selector:
    app: todo-api
  ports:
    - port: 3000
      targetPort: 3000
      protocol: TCP

```

Aplicamos configuración:

```
kubectl apply -f todo-service.yaml
```


## 3 nip.io
Usar nip.io te ahorra el paso de editar el fichero `/etc/hosts`. La idea principal es:

1. Usar 127-0-0-1.nip.io como dominio, ojo que no es una IP que es un dominio:

2. Configurar el Ingress para usar un host del tipo 127-0-0-1.nip.io
    
3. Con eso, cuando hagas peticiones a  http://127-0-0-1.nip.io  se resolverán directamente a la IP 127.0.0.1 gracias a ingress y minikube tunnel

![[Pasted image 20250107231113.png]]
## 4 Ingress :

Habilitamos ingress:
```
minikube addons enable ingress
```

![[Pasted image 20250107104112.png]]

Ejecutamos en un terminal a parte:
```
minikube tunnel
```

Creamos el deploy para configuración de ingress con nip.io:

```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: todo-ingress
spec:
  rules:
  - host: 127-0-0-1.nip.io
    http:
      paths:
      - path: /api
        pathType: Prefix
        backend:
          service:
            name: todo-api
            port:
              number: 3000
      - path: /
        pathType: Prefix
        backend:
          service:
            name: todo-front
            port:
              number: 80


```

Aplicamos configuración:

```
kubectl apply -f app-ingress.yaml
```


Verificar que NGINX Ingress controller está "Running"

```
kubectl get pods -n ingress-nginx
```

![[Pasted image 20250107110259.png]]



Con eso, cuando abras tu navegador en `http://127-0-0-1.nip.io`, verás la **UI** (todo-front), y si accedes a `http://127-0-0-1/api`, llegará a **todo-api**.


Comprobaciones y comandos de interés:

```
kubectl describe ingress <ingress-name> 
kubectl get pods --namespace ingress-nginx
kubectl logs --namespace ingress-nginx <nombre-del-pod-ingress>
```