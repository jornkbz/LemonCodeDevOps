#!/bin/bash

# Asignar texto por defecto
de_txt="Que me gusta la bash!!!!"

# Asignar texto por defecto o texto recibido como parámetro
txt="${1:-$d_txt}"

# Crear la estructura de directorios
mkdir -p foo/dummy foo/empty

# Crear file1.txt con el texto pasado como parámetro
echo "$txt" > foo/dummy/file1.txt

# Crear file2.txt vacío
touch foo/dummy/file2.txt

# Volcar el contenido de file1.txt a file2.txt
cat foo/dummy/file1.txt > foo/dummy/file2.txt

# Mover file2.txt a la carpeta empty
mv foo/dummy/file2.txt foo/empty/
