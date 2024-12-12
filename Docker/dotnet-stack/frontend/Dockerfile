# Usa una imagen base de Node.js

FROM node:18

  

# Establece el directorio de trabajo dentro del contenedor

WORKDIR /usr/src/app

  

# Copia los archivos necesarios para instalar dependencias

COPY package*.json ./

  

# Instala las dependencias

RUN npm install

  

# Copia todos los archivos del frontend al contenedor

COPY . .

  

# Expone el puerto en el contenedor

EXPOSE 8080

  

# Comando para iniciar la aplicación

CMD ["node", "server.js"]