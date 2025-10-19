#!/usr/bin/env bash
# Ejecuta pgAdmin4 dentro del entorno virtual y lo abre con launch-webapp

VENV="$HOME/pgadmin4"

# Activar el entorno virtual
source "$VENV/bin/activate"

# Iniciar pgAdmin4 desde su ejecutable correcto
"$VENV/bin/pgadmin4" &

# Esperar unos segundos a que arranque el servidor
sleep 3

# Abrirlo en navegador usando launch-webapp
launch-webapp "http://127.0.0.1:5050"

