#!/usr/bin/env bash
# CeiOS · primeros-pasos.sh — Menú de bienvenida con los módulos del sistema.
set -e
DIR="$(cd "$(dirname "$0")" && pwd)"
command -v zenity >/dev/null 2>&1 || { echo "Falta zenity."; exit 1; }

while true; do
  OP=$(zenity --list --title="CeiOS · Primeros pasos" \
    --text="¿Qué quieres hacer? (equipos de 2 GB de RAM: una tarea pesada a la vez)" \
    --column="Opción" --column="Descripción" \
    1 "Aplicar apariencia Windows 11 (Fluent, acento rojo)" \
    2 "Optimizar el equipo para 2 GB de RAM" \
    3 "Instalar Zotero (gestor de referencias, nativo)" \
    4 "Instalar OnlyOffice (compatibilidad MS Office)" \
    5 "Instalar LaTeX ligero (tesis y artículos)" \
    6 "Instalar entorno Python científico" \
    7 "Preparar Microsoft Office 2016 vía Wine (TU licencia)" \
    8 "Preparar EndNote vía Wine (avanzado, TU licencia)" \
    9 "Generar el fondo de escritorio con mi imagen" \
    0 "Salir" \
    --height 500 --width 700 2>/dev/null) || exit 0

  case "$OP" in
    1) bash "$DIR/apply-win11-look.sh" ;;
    2) sudo bash "$DIR/tune-lowram.sh" ;;
    3) sudo bash "$DIR/install-zotero.sh" ;;
    4) sudo bash "$DIR/install-onlyoffice.sh" ;;
    5) sudo bash "$DIR/install-latex-light.sh" ;;
    6) bash "$DIR/install-python-ciencia.sh" ;;
    7) sudo bash "$DIR/setup-wine-office2016.sh" --preparar ;;
    8) bash "$DIR/setup-wine-endnote.sh" ;;
    9) bash "$DIR/make-wallpaper.sh" ;;
    0|"") exit 0 ;;
  esac
  zenity --info --title="CeiOS" --text="Operación finalizada." --width 300 2>/dev/null || true
done
