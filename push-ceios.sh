#!/usr/bin/env bash
# push-ceios.sh — Sube los 3 commits finales de CeiOS a GitHub (1 minuto).
# Requisitos: git instalado. Te pedirá tu usuario de GitHub y un token (PAT)
# con permiso "Contents: read/write" — si tienes `gh auth login`, no pide nada.
set -e
cd "$(dirname "$0")"

[ -f ceios-main.bundle ] || { echo "ERROR: pon este script junto a ceios-main.bundle"; exit 1; }
echo "==> Contenido a subir: 3 commits sobre main (docs+licencia, foto oficial base64, workflow CI)"

if [ ! -d CeiOS-push ]; then
  git clone -q -b main ceios-main.bundle CeiOS-push
fi
cd CeiOS-push

echo "==> Push (te pedirá credenciales de GitHub si no tienes gh autenticado)"
git push https://github.com/SamyOsiel/CeiOS.git main:main

echo ""
echo "✅ Listo. Actions está compilando la ISO (20-45 min):"
echo "   https://github.com/SamyOsiel/CeiOS/actions"
echo "   Al terminar se publica sola en:"
echo "   https://github.com/SamyOsiel/CeiOS/releases/tag/v0.1-tocororo"
