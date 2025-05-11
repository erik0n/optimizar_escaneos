#!/bin/bash

# Verifica que se proporcione un archivo
if [ $# -ne 1 ]; then
    echo "Uso: $0 archivo.gnmap"
    exit 1
fi

archivo="$1"

# Verifica si el archivo existe
if [ ! -f "$archivo" ]; then
    echo "Archivo no encontrado: $archivo"
    exit 1
fi

# Extrae puertos abiertos y los separa por comas
puertos=$(grep "Ports:" "$archivo" | \
          sed -n 's/.*Ports: //p' | \
          tr ',' '\n' | \
          grep 'open' | \
          cut -d'/' -f1 | \
          sort -n | \
          uniq | \
          paste -sd, -)

# Copia al clipboard usando xclip o xsel
if command -v xclip >/dev/null 2>&1; then
    echo -n "$puertos" | xclip -selection clipboard
elif command -v xsel >/dev/null 2>&1; then
    echo -n "$puertos" | xsel --clipboard --input
else
    echo "Error: Se necesita 'xclip' o 'xsel' para copiar al portapapeles"
    exit 1
fi

echo "Puertos copiados al portapapeles: $puertos"
