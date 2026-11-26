#!/usr/bin/env bash
# CeiOS · setup-wine-endnote.sh — EndNote bajo Wine (AVANZADO).
# Requiere TU licencia y tu instalador original.
# Recomendación oficial en 2 GB/16 GB: usa Zotero (nativo y gratuito).
#
# Uso: bash setup-wine-endnote.sh --instalar /ruta/a/EndNoteInstaller.exe
set -e

PFX="$HOME/.wine-endnote"
[ "${1:-}" = "--instalar" ] || { echo "Uso: bash $0 --instalar /ruta/a/EndNoteInstaller.exe"; exit 1; }
[ -f "${2:-}" ] || { echo "No encuentro el instalador."; exit 1; }
command -v wine >/dev/null 2>&1 || { echo "Primero: sudo bash setup-wine-office2016.sh --preparar"; exit 1; }

libre=$(df --output=avail -BG "$HOME" | tail -1 | tr -dc '0-9')
[ "${libre:-0}" -ge 8 ] || { echo "EndNote + .NET necesitan 8 GB libres y solo hay ${libre:-0}G. Alternativa: Zotero."; exit 1; }

if command -v zenity >/dev/null 2>&1 && [ -n "${DISPLAY:-}" ]; then
  zenity --question --title="CeiOS · EndNote" \
    --text="EndNote bajo Wine en este hardware es lento y frágil (depende de .NET 4.8).\n¿Continuar de todas formas?" --width 420 || \
    { echo "Buena elección: usa Zotero."; exit 0; }
fi

export WINEPREFIX="$PFX" WINEARCH=win32
[ -d "$PFX" ] || { echo "==> Creando prefix"; wineboot -i; }

echo "==> Instalando .NET 4.8 (20-40 minutos, ~1,5 GB)"
winetricks -q dotnet48 corefonts || winetricks dotnet48 corefonts

echo "==> Instalando EndNote"
wine "$2"

echo "Fin. Si .NET falló, exporta tu biblioteca a RIS (File → Export) y pásala a Zotero."
