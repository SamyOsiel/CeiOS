#!/bin/bash
# CeiOS · ci-prepare.sh — Genera los binarios de marca a partir de las
# fuentes vectoriales antes de compilar la ISO.
#   1. Renderiza los PNG de branding (icono, emblema, logo) desde los SVG.
#   2. Decodifica la foto del usuario (base64) si está versionada.
#   3. Compone el fondo oficial 1920x1080 con compose-wallpaper.py.
# Todo se ejecuta en el contenedor Debian 12 del builder (ver Dockerfile).
set -e

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BR="$ROOT/assets/branding"
WALL="$ROOT/assets/wallpaper"

echo "==> [prep 1/3] Renderizando PNGs de marca desde los SVG"
if command -v rsvg-convert >/dev/null 2>&1; then
  mkdir -p "$BR/png"
  for s in 512 128 64 48 32; do
    rsvg-convert -w "$s" -h "$s" "$BR/ceios-icon.svg" \
      -o "$BR/png/ceios-icon-$s.png"
  done
  rsvg-convert -w 512 -h 512 "$BR/ceios-emblema.svg" \
    -o "$BR/png/ceios-emblema-512.png"
  rsvg-convert -w 1024 "$BR/ceios-logo.svg" -o "$BR/png/ceios-logo-1024.png"
else
  echo "    rsvg-convert no disponible: se mantienen los PNG existentes."
fi

echo "==> [prep 2/3] Recuperando la foto oficial del fondo"
if [ -f "$WALL/wallpaper-usuario.jpg.b64" ]; then
  base64 -d "$WALL/wallpaper-usuario.jpg.b64" > "$WALL/wallpaper-usuario.jpg"
fi

echo "==> [prep 3/3] Componiendo el fondo oficial"
if [ -f "$WALL/wallpaper-usuario.jpg" ] \
   && python3 -c 'import PIL' 2>/dev/null; then
  python3 "$ROOT/scripts/compose-wallpaper.py" \
    "$WALL/wallpaper-usuario.jpg" \
    "$WALL/ceios-wallpaper-1920.png" \
    "$BR/png/ceios-emblema-512.png"
else
  echo "    Sin foto/PIL disponible: la ISO usará el fondo vectorial SVG."
fi

echo "Preparación de marca lista."
