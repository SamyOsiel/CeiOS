#!/usr/bin/env bash
# CeiOS · build.sh — Compila la ISO de CeiOS con live-build.
# Uso:   sudo ./build/build.sh          (Debian 12 nativo)
#        docker run --rm -v "$PWD":/work ceios-builder
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
LB="$ROOT/build/lb-config"
INC="$LB/config/includes.chroot"

if [ "$(id -u)" -eq 0 ]; then SUDO=""; else SUDO="sudo"; fi

echo "==> [1/4] Sincronizando scripts, tema y assets en includes.chroot"
rm -rf "$INC"
mkdir -p "$INC/usr/local/bin/ceios" \
         "$INC/usr/share/ceios/assets" \
         "$INC/usr/share/applications"
cp -r "$ROOT/theme/includes.chroot/." "$INC/"
install -m 0755 "$ROOT/scripts/"*.sh "$INC/usr/local/bin/ceios/"
# Marca: emblema (rombo + estrella + ramas + bandera cubana), icono y logo
cp "$ROOT/assets/branding/ceios-logo.svg" "$INC/usr/share/ceios/assets/ceios-logo.svg"
cp "$ROOT/assets/branding/ceios-icon.svg" "$INC/usr/share/ceios/assets/ceios-icon.svg"
cp "$ROOT/assets/branding/ceios-emblema.svg" "$INC/usr/share/ceios/assets/ceios-emblema.svg"
if [ -d "$ROOT/assets/branding/png" ]; then
  mkdir -p "$INC/usr/share/ceios/assets/png"
  cp "$ROOT/assets/branding/png/"*.png "$INC/usr/share/ceios/assets/png/" 2>/dev/null || true
fi

# Fondo oficial (PNG ya compuesto 1920x1080, incluye la imagen del usuario)
cp "$ROOT/assets/wallpaper/ceios-wallpaper-1920.png" \
   "$INC/usr/share/wallpapers/ceios_tmp_wall.png" 2>/dev/null || true
mkdir -p "$INC/usr/share/wallpapers/ceios"
if [ -f "$INC/usr/share/wallpapers/ceios_tmp_wall.png" ]; then
  mv "$INC/usr/share/wallpapers/ceios_tmp_wall.png" \
     "$INC/usr/share/wallpapers/ceios/ceios-wallpaper-1920.png"
fi
cp "$ROOT/assets/wallpaper/ceios-wallpaper.svg" "$INC/usr/share/ceios/assets/ceios-wallpaper.svg"

# Fondo con la imagen del usuario: usa el PNG precompuesto si existe;
# solo lo regenera con ImageMagick si falta.
if [ -f "$ROOT/assets/wallpaper/wallpaper-usuario.jpg" ] \
   && [ ! -f "$ROOT/assets/wallpaper/ceios-wallpaper-usuario.png" ] \
   && command -v convert >/dev/null 2>&1; then
  echo "==> Fondo personalizado: componiendo wallpaper-usuario.jpg (centrado)"
  bash "$ROOT/scripts/make-wallpaper.sh" \
    "$ROOT/assets/wallpaper/wallpaper-usuario.jpg" \
    "$ROOT/assets/wallpaper/ceios-wallpaper-usuario.png" || true
fi
if [ -f "$ROOT/assets/wallpaper/ceios-wallpaper-usuario.png" ]; then
  cp "$ROOT/assets/wallpaper/ceios-wallpaper-usuario.png" \
     "$INC/usr/share/ceios/assets/ceios-wallpaper-usuario.png"
fi

echo "==> [2/4] Configurando live-build"
cd "$LB"
sh auto/config

echo "==> [3/4] Compilando (tarda 10-30 min según la red)"
$SUDO lb clean --all >/dev/null 2>&1 || true
$SUDO lb build

echo "==> [4/4] Publicando la ISO"
mkdir -p "$ROOT/images"
ISO="$ROOT/images/ceios-0.1-tocororo-amd64.iso"
mv -f live-image-amd64.hybrid.iso "$ISO"
( cd "$ROOT/images" && sha256sum "$(basename "$ISO")" > SHA256SUMS )

echo "Listo:"
ls -lh "$ROOT/images"
