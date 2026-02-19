#!/bin/bash
# Descargar una página web en un archivo local
curl -o ejemplo.html https://example.com
# Crea 'ejemplo.html' con el contenido HTML de example.com.

# Descargar varios archivos numerados
curl -O https://example.com/archivo{1..3}.txt
# Descarga archivo1.txt, archivo2.txt, archivo3.txt.

# Hacer una petición GET a una API pública (texto JSON en salida)
curl -s https://api.quotable.io/random
# Salida esperada (una cita aleatoria en JSON), por ejemplo:
# {"_id":"xyz","content":"Be yourself; everyone else is already taken.","author":"Oscar Wilde",...}

# curl: GET
curl https://jsonplaceholder.typicode.com/posts/1


# POST JSON
curl -X POST -H "Content-Type: application/json" \
-d '{"title":"Hola","body":"Mundo","userId":1}' \
https://jsonplaceholder.typicode.com/posts

# Mostrar solo los encabezados HTTP de respuesta
curl -I https://www.google.com
# Ejemplo de salida:
# HTTP/1.1 200 OK
# Date: ...
# Content-Type: text/html; charset=UTF-8
# ...
