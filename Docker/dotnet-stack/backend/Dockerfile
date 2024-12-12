# Etapa 1: Construcción de la aplicación

FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build

WORKDIR /app

  

# Copiar los archivos del proyecto al contenedor

COPY . .

  

# Restaurar las dependencias y publicar la aplicación

RUN dotnet restore

RUN dotnet publish -c Release -o out

  

# Etapa 2: Imagen de runtime

FROM mcr.microsoft.com/dotnet/aspnet:3.1

WORKDIR /app

  

# Copiar los archivos publicados desde la etapa de build

COPY --from=build /app/out .

  
  

# Exponer el puerto 5000

EXPOSE 5000

# Definir el punto de entrada

ENTRYPOINT ["dotnet", "backend.dll"]