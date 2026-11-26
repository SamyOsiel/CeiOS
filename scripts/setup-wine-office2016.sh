#!/usr/bin/env bash
# CeiOS · setup-wine-office2016.sh — Prepara Wine y guía la instalación de TU
# Microsoft Office 2016. CeiOS no incluye ni activa Office: tú aportas licencia
# e instalador original.
#
# Uso:
#   sudo bash setup-wine-office2016.sh --preparar
#   bash  setup-wine-office2016.sh --instalar /ruta/a/setup.exe
set -e

PFX="$HOME/.wine-office"
usage() { echo "Uso: $0 --preparar | $0 --instalar /ruta/a/setup.exe"; }

caso="${1:-}"
if [ "$caso" = "--preparar" ]; then
  [ "$(id -u)" -eq 0 ] || { echo "--preparar se ejecuta con sudo."; exit 1; }
  [ "$(uname -m)" = "x86_64" ] || { echo "Office bajo Wine solo en Chromebooks Intel/AMD, no ARM."; exit 1; }
  libre=$(df --output=avail -BG "$HOME" | tail -1 | tr -dc '0-9')
  [ "${libre:-0}" -ge 6 ] || { echo "Necesitas 6 GB libres y solo hay ${libre:-0}G."; exit 1; }

  echo "==> Wine con arquitectura mixta (Office 2016 es 32 bits)"
  dpkg --add-architecture i386
  apt-get update
  apt-get install -y wine wine32 wine64 winbind winetricks cabextract
  echo "Base lista. Ahora, SIN sudo:"
  echo "  bash $0 --instalar /ruta/a/setup.exe"
  exit 0
fi

if [ "$caso" = "--instalar" ]; then
  [ -f "${2:-}" ] || { usage; exit 1; }
  command -v wine >/dev/null 2>&1 || { echo "Primero: sudo bash $0 --preparar"; exit 1; }

  export WINEPREFIX="$PFX" WINEARCH=win32
  [ -d "$PFX" ] || { echo "==> Creando prefix de 32 bits"; wineboot -i; }

  echo "==> Bibliotecas que Office 2016 necesita (tarda unos minutos)"
  winetricks -q corefonts msxml6 gdiplus riched20 fontsmooth=rgb win10 || \
    winetricks corefonts msxml6 gdiplus riched20 fontsmooth=rgb win10

  echo "==> Instalando Office 2016: sigue el asistente e introduce TU clave de licencia"
  wine "$2"

  OFF="$PFX/drive_c/Program Files/Microsoft Office/root/Office16"
  mkdir -p "$HOME/.local/share/applications"
  for par in WINWORD:Word EXCEL:Excel POWERPNT:PowerPoint; do
    exe="${par%%:*}"; nombre="${par##*:}"
    [ -f "$OFF/$exe.EXE" ] || continue
    cat > "$HOME/.local/share/applications/ceios-office-$nombre.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=Microsoft $nombre 2016 (Wine)
Exec=env WINEPREFIX=$PFX wine "$OFF/$exe.EXE"
Icon=application-x-executable
Categories=Office;
EOF
  done
  echo "Listo. Si la activación en línea falla dentro de Wine, prueba la activación telefónica."
  echo "Con 2 GB de RAM: cierra Firefox y Zotero mientras uses Word/Excel."
  exit 0
fi

usage
exit 1
