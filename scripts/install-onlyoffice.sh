#!/usr/bin/env bash
# CeiOS · install-onlyoffice.sh — OnlyOffice Desktop Editors (gratuito).
# Alta compatibilidad con los formatos de Microsoft Office.
# Uso: sudo bash install-onlyoffice.sh
set -e
[ "$(id -u)" -eq 0 ] || { echo "Ejecuta con sudo."; exit 1; }
[ "$(uname -m)" = "x86_64" ] || { echo "Solo x86_64."; exit 1; }

echo "==> Buscando la última versión de OnlyOffice Desktop Editors"
URL=$(curl -fsSL https://api.github.com/repos/ONLYOFFICE/DesktopEditors/releases/latest \
  | grep -oE '"browser_download_url": *"[^"]+amd64\.deb"' | head -1 | cut -d'"' -f4)
if [ -z "$URL" ]; then
  echo "No se encontró el paquete automáticamente."
  echo "Descárgalo de https://www.onlyoffice.com/download-desktop.aspx e instala con:"
  echo "  sudo apt-get install ./onlyoffice-desktopeditors_amd64.deb"
  exit 1
fi

echo "==> Descargando e instalando"
curl -fL "$URL" -o /tmp/onlyoffice.deb
apt-get install -y /tmp/onlyoffice.deb
rm -f /tmp/onlyoffice.deb
echo "OnlyOffice instalado: menú → OnlyOffice Desktop Editors."
