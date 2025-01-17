Crear el fichero deployment:

```
apiVersion: apps/v1

kind: Deployment

metadata:

  name: todo-app

spec:

  replicas: 1

  selector:

    matchLabels:

      app: todo-app

  template:

    metadata:

      labels:

        app: todo-app

    spec:

      containers:

      - name: todo-app

        image: lemoncodersbc/lc-todo-monolith:v5-2024

        ports:

        - containerPort: 3000

        env:

        - name: NODE_ENV

          value: "production"

        - name: PORT

          value: "3000"
```


Ejecutar el yaml
```
kubectl apply -f todo-app-deployment.yaml

```

Seguidamente comprobamos que está levantado.

```
kubectl get pods

```

Para más detalle
```
kubectl get pods -o wide
```

![image](https://github.com/user-attachments/assets/14b80e7c-4ba5-4f0c-adec-75768a47ca28)




Ahora crearíamos el servicio.

```
apiVersion: v1
kind: Service
metadata:
  name: todo-app-service
spec:
  type: LoadBalancer
  selector:
    app: todo-app
  ports:
  - protocol: TCP
    port: 80
    targetPort: 3000

```

Seguidamente aplicamos el manifiesto y levantamos el servicio.

```
kubectl apply -f todo-app-service.yaml

```

Por último podemos acceder al servicio ejecutando.
```
minikube service todo-app-service

```

Podemos comprobar el estado del servicio
```
kubectl get svc
```


TUNEL MINIKUBE

Ejecutar comando, hay que tener en cuenta que este comando usará la terminal actual por lo que hay que abrir otra terminal para seguir con el proceso:
```
minikube tunnel

```


Como se menciona anteriormente una vez abierto el tunel en la terminal, abrimos otra terminal y escribimos el siguiente comando para ver la IP- externa de nuestro servicio.

```
kubectl get svc

```

![[Pasted image 20241230130129.png]]

Una vez identificada la IP externa hay que abrir el navegador e introducir la IP externa y el protocolo http:
```
http://127.0.0.1/
```
![[Pasted image 20241230130346.png]]
