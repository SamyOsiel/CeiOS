#!/usr/bin/env bash
# CeiOS · install-python-ciencia.sh — Entorno Python científico en ~/ceios-ciencia.
# Uso: bash install-python-ciencia.sh   (sin sudo)
set -e

echo "==> Creando entorno virtual ~/ceios-ciencia"
python3 -m venv "$HOME/ceios-ciencia"
source "$HOME/ceios-ciencia/bin/activate"
pip install --upgrade pip wheel >/dev/null

echo "==> Instalando paquetes: numpy, scipy, pandas, matplotlib, seaborn, statsmodels, openpyxl"
pip install numpy scipy pandas matplotlib seaborn statsmodels openpyxl

cat > "$HOME/ceios-ciencia/README.txt" <<'EOF'
Entorno científico de CeiOS
===========================
Activar:   source ~/ceios-ciencia/bin/activate
Salir:     deactivate
Jupyter (opcional, ~400 MB): pip install jupyterlab
EOF

echo "Listo. Actívalo con: source ~/ceios-ciencia/bin/activate"
