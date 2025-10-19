#!/bin/bash

# ===============================================
# 📡 Conexión WiFi con Gum (versión estable)
# Autor: Diego / ChatGPT
# ===============================================

# Nombre del dispositivo WiFi (ajusta según tu sistema)
IFACE="wlp3s0"

# Ancho fijo de la terminal (120 columnas para una ventana de 1200 píxeles)
TERM_WIDTH=110

# Banner ASCII
ASCII_ART="
    ██     ██ ██ ███████ ██      ██████  ██████  ███    ██ ███    ██ ███████  ██████ ████████ 
    ██     ██ ██ ██      ██     ██      ██    ██ ████   ██ ████   ██ ██      ██         ██    
    ██  █  ██ ██ █████   ██     ██      ██    ██ ██ ██  ██ ██ ██  ██ █████   ██         ██    
    ██ ███ ██ ██ ██      ██     ██      ██    ██ ██  ██ ██ ██  ██ ██ ██      ██         ██    
     ███ ███  ██ ██      ██      ██████  ██████  ██   ████ ██   ████ ███████  ██████    ██    
"

# Función para centrar el texto
center_text() {
  local text="$1"
  local term_width=$TERM_WIDTH
  # Calcular el ancho de la línea más larga del arte ASCII
  local max_width=0
  while IFS= read -r line; do
    line_width=${#line}
    if [ $line_width -gt $max_width ]; then
      max_width=$line_width
    fi
  done <<< "$text"
  
  # Calcular el padding necesario para centrar
  local padding=$(( (term_width - max_width) / 2 ))
  if [ $padding -lt 0 ]; then padding=0; fi
  
  # Imprimir cada línea con el padding
  while IFS= read -r line; do
    printf "%${padding}s%s\n" "" "$line"
  done <<< "$text"
}

# Imprimir el banner centrado con color
echo -e "\033[1;36m"
center_text "$ASCII_ART"
echo -e "\033[0m"

# Comprobar que nmcli está disponible
if ! command -v nmcli &>/dev/null; then
  echo "❌ nmcli no está instalado."
  exit 1
fi

# Buscar redes disponibles
echo "📡 Buscando redes WiFi..."
networks=$(nmcli -t -f SSID,SIGNAL dev wifi list | awk -F: '$1!="" {printf "%s (%s%%)\n", $1, $2}' | sort -k2 -nr)

if [ -z "$networks" ]; then
  gum confirm "No se encontraron redes disponibles. ¿Reintentar?" && exec "$0"
  exit 1
fi

# Seleccionar red con gum
SSID=$(echo "$networks" | gum choose --height 15 --cursor "👉" --header "Selecciona una red WiFi:" | sed 's/ ([0-9]\+%)//')

if [ -z "$SSID" ]; then
  echo "❌ No seleccionaste ninguna red."
  exit 1
fi

echo "📶 Red seleccionada: '$SSID'"

# Verificar si la red ya está guardada
if nmcli connection show | grep -q "^${SSID}"; then
  echo "🔁 Red ya guardada, intentando conectar..."
  if pkexec nmcli connection up "$SSID"; then
    echo "✅ Conectado a '$SSID'."
    exit 0
  else
    echo "⚠️ No se pudo conectar automáticamente, probando manualmente..."
  fi
fi

# Solicitar contraseña solo si es nueva
WIFI_PASS=$(gum input --password --placeholder "Introduce la contraseña para '$SSID'")

if [ -z "$WIFI_PASS" ]; then
  echo "❌ No se ingresó ninguna contraseña."
  exit 1
fi

# Eliminar conexiones previas con el mismo nombre (por si hay conflictos)
nmcli connection delete id "$SSID" &>/dev/null

# Intentar conectar directamente
echo "🔗 Conectando a '$SSID'..."
if pkexec nmcli dev wifi connect "$SSID" password "$WIFI_PASS" ifname "$IFACE" 1>/dev/null; then
  echo "✅ Conectado correctamente a '$SSID'."
  exit 0
fi

# Si falla, intentar modo manual
echo "⚙️ Intentando configuración manual..."
pkexec nmcli connection add type wifi ifname "$IFACE" con-name "$SSID" ssid "$SSID" \
  wifi-sec.key-mgmt wpa-psk wifi-sec.psk "$WIFI_PASS" autoconnect yes

if pkexec nmcli connection up "$SSID"; then
  echo "✅ Conectado correctamente a '$SSID'."
else
  echo "❌ Error al conectar a '$SSID'. Revisa la contraseña o el tipo de red."
fi
