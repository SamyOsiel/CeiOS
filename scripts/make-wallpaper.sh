#!/usr/bin/env bash
# CeiOS · make-wallpaper.sh — Genera el fondo de escritorio integrando TU imagen
# CENTRADA sobre el diseño azul/rojo/blanco de la bandera cubana.
# Uso: make-wallpaper.sh [imagen] [salida.png]
set -e

command -v convert >/dev/null 2>&1 || {
  echo "Falta ImageMagick. Instalando..."
  sudo apt-get update -qq && sudo apt-get install -y imagemagick
}

IMAGEN="${1:-}"
SALIDA="${2:-$HOME/.local/share/ceios/fondo-ceios.png}"
W=1920; H=1080

if [ -z "$IMAGEN" ] && [ -n "${DISPLAY:-}" ] && command -v zenity >/dev/null 2>&1; then
  IMAGEN=$(zenity --file-selection --title="Elige tu imagen para el fondo" 2>/dev/null || true)
fi
[ -n "$IMAGEN" ] || { echo "Uso: make-wallpaper.sh imagen.jpg [salida.png]"; exit 1; }
[ -f "$IMAGEN" ] || { echo "No existe la imagen: $IMAGEN"; exit 1; }
mkdir -p "$(dirname "$SALIDA")"

echo "==> Fondo base azul cubano con acentos rojo y azul claro"
convert -size ${W}x${H} gradient:'#011646'-'#002a8f' "$SALIDA"
convert "$SALIDA" \( -size 1400x1400 radial-gradient:'#ce112633'-'#ce112600' \) \
  -gravity NorthEast -geometry +260-420 -composite "$SALIDA"
convert "$SALIDA" \( -size 1600x1600 radial-gradient:'#5e8bff44'-'#5e8bff00' \) \
  -gravity SouthWest -geometry -380+380 -composite "$SALIDA"

echo "==> Marco de esquinas (rojo y blanco)"
convert "$SALIDA" \
  -stroke '#ce1126' -strokewidth 5 \
  -draw "line 56,96 56,56"   -draw "line 56,56 176,56" \
  -draw "line 1864,984 1864,1024" -draw "line 1864,1024 1744,1024" \
  -stroke '#ffffff' \
  -draw "line 1744,56 1864,56" -draw "line 1864,56 1864,96" \
  -draw "line 56,984 56,1024"  -draw "line 56,1024 176,1024" \
  "$SALIDA"

echo "==> Tu imagen, centrada, con marco blanco y sombra suave"
convert "$IMAGEN" -auto-orient -resize x560\> -bordercolor '#ffffff' -border 6 /tmp/ceios-marco.png
convert /tmp/ceios-marco.png \
  \( +clone -background '#000000' -shadow 60x14+0+10 \) +swap \
  -background none -layers merge /tmp/ceios-marco-sombra.png
convert "$SALIDA" /tmp/ceios-marco-sombra.png -gravity center -geometry +0-40 -composite "$SALIDA"

echo "==> Firma discreta"
convert "$SALIDA" -gravity South -pointsize 22 -fill '#ffffffcc' \
  -annotate +0+36 "CeiOS · Ciencia e Investigación" "$SALIDA"
rm -f /tmp/ceios-marco.png /tmp/ceios-marco-sombra.png

echo "==> Aplicando en LXQt"
pcmanfm-qt --set-wallpaper "$SALIDA" 2>/dev/null || true
CONF="$HOME/.config/pcmanfm-qt/lxqt/settings.conf"
mkdir -p "$(dirname "$CONF")"; touch "$CONF"
grep -q '^\[General\]' "$CONF" || printf '[General]\n__userfile__=true\n' > "$CONF"
if grep -q '^Wallpaper=' "$CONF"; then
  sed -i "s|^Wallpaper=.*|Wallpaper=$SALIDA|" "$CONF"
else
  echo "Wallpaper=$SALIDA" >> "$CONF"
fi
if grep -q '^WallpaperMode=' "$CONF"; then
  sed -i "s|^WallpaperMode=.*|WallpaperMode=crop|" "$CONF"
else
  echo "WallpaperMode=crop" >> "$CONF"
fi

echo "Fondo listo: $SALIDA"
