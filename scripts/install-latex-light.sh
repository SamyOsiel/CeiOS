#!/usr/bin/env bash
# CeiOS · install-latex-light.sh — LaTeX ligero para tesis y artículos (español).
# Uso: sudo bash install-latex-light.sh
set -e
[ "$(id -u)" -eq 0 ] || { echo "Ejecuta con sudo."; exit 1; }

echo "==> Instalando TeX Live básico (~600 MB)"
apt-get install -y --no-install-recommends \
  texlive-latex-base texlive-latex-recommended texlive-fonts-recommended \
  texlive-lang-spanish latexmk

echo "LaTeX listo. Prueba con:"
echo "  pdflatex documento.tex   |   latexmk -pdf documento.tex"
echo "Bibliografía con biblatex: sudo apt-get install texlive-bibtex-extra biber"
echo "Editor gráfico opcional:   sudo apt-get install texstudio"
