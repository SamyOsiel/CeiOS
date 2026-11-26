#!/usr/bin/env bash
# CeiOS · install-zotero.sh — Instala Zotero (nativo) en /opt/zotero.
# Uso: sudo bash install-zotero.sh
set -e
[ "$(id -u)" -eq 0 ] || { echo "Ejecuta con sudo."; exit 1; }
[ "$(uname -m)" = "x86_64" ] || { echo "Solo x86_64 (Intel/AMD)."; exit 1; }

echo "==> Descargando Zotero (última versión estable)"
URL="https://www.zotero.org/download/client/dl?channel=release&platform=linux-x86_64"
curl -fL "$URL" -o /tmp/zotero.tar.bz2

echo "==> Instalando en /opt/zotero"
rm -rf /opt/zotero
mkdir -p /opt
tar -xjf /tmp/zotero.tar.bz2 -C /opt
rm -f /tmp/zotero.tar.bz2

echo "==> Sandbox de Chromium (setuid) y lanzador de menú"
chmod 4755 /opt/zotero/chrome-sandbox 2>/dev/null || true
[ -f /opt/zotero/zotero.desktop ] && cp /opt/zotero/zotero.desktop /usr/share/applications/zotero.desktop || true

echo "==> Integración con LibreOffice"
echo "  Dentro de Zotero: Editar → Preferencias → Citar → Procesadores de texto →"
echo "  «Instalar el complemento de Microsoft Word para LibreOffice»."

echo "Zotero instalado. Ábrelo desde el menú Aplicaciones."
