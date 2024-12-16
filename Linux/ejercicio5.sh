#!/bin/bash

# Verificar si se pasaron dos parámetros
if [ $# -ne 2 ]; then
  echo "Se necesitan únicamente dos parámetros para ejecutar este script"
  exit 1
fi

# Parámetros
URL="$1"
word="$2"

# Descargar el contenido de web y buscar la palabra
content=$(curl -s "$URL")

# Buscar la palabra y contar las veces que aparece
count=$(echo "$content" | grep -o -i "$word" | wc -l)

if [ $count -eq 0 ]; then
  echo "No se ha encontrado la palabra \"$word\""
elif [ $count -eq 1 ]; then
  first_line=$(echo "$content" | grep -n -i "$word" | cut -d: -f1)
  echo "La palabra \"$word\" aparece 1 vez"
  echo "Aparece únicamente en la línea $first_line"
else
  first_line=$(echo "$content" | grep -n -i "$word" | head -n 1 | cut -d: -f1)
  echo "La palabra \"$word\" aparece $count veces"
  echo "Aparece por primera vez en la línea $first_line"
fi
