#!/usr/bin/env bash
# CeiOS · tune-lowram.sh — Perfil de bajo consumo para equipos con 2 GB de RAM.
# Uso: sudo bash tune-lowram.sh
set -e
[ "$(id -u)" -eq 0 ] || { echo "Ejecuta con sudo."; exit 1; }

echo "==> zram (lz4, 50 % de la RAM)"
if [ -f /etc/default/zramswap ]; then
  sed -i 's/^#\?ALGO=.*/ALGO=lz4/' /etc/default/zramswap
  sed -i 's/^#\?PERCENT=.*/PERCENT=50/' /etc/default/zramswap
  grep -q '^ALGO='    /etc/default/zramswap || echo 'ALGO=lz4'    >> /etc/default/zramswap
  grep -q '^PERCENT=' /etc/default/zramswap || echo 'PERCENT=50' >> /etc/default/zramswap
fi
systemctl restart zramswap.service 2>/dev/null || \
  systemctl restart zram-swap.service 2>/dev/null || true

echo "==> Parámetros del kernel"
cat > /etc/sysctl.d/99-ceios-lowram.conf <<'EOF'
# CeiOS — perfil bajo consumo (2 GB RAM)
vm.swappiness=180
vm.vfs_cache_pressure=200
vm.dirty_writeback_centisecs=3000
vm.dirty_expire_centisecs=6000
EOF
sysctl --system >/dev/null 2>&1 || true

echo "==> Servicios que no aportan nada en un portátil de investigación"
for s in avahi-daemon ModemManager cups bluetooth apt-daily.timer apt-daily-upgrade.timer; do
  systemctl disable --now "$s.service" 2>/dev/null || true
done

echo "Listo. Verifica con: zramctl y free -h"
echo "(Para imprimir de nuevo: sudo systemctl enable --now cups)"
