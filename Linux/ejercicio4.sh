#!/bin/bash

# URL de la página web
URL="https://example.com" 

# Comprobar que se pasa el parámetro
if [ -z "$1" ]; then
  echo "Se debe pasar una palabra como parámetro"
  exit 1
fi

# Descargar el contenido de la página y buscar la palabra
word="$1"
content=$(curl -s "$URL")

# Buscar la palabra y contar las veces que aparece
count=$(echo "$content" | grep -o -i "$word" | wc -l)

if [ $count -eq 0 ]; then
  echo "No se ha encontrado la palabra \"$word\""
else
  first_line=$(echo "$content" | grep -n -i "$word" | head -n 1 | cut -d: -f1)
  echo "La palabra \"$word\" aparece $count veces"
  echo "Aparece por primera vez en la línea $first_line"
fi
