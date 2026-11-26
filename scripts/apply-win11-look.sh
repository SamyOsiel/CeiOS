#!/usr/bin/env bash
# CeiOS · apply-win11-look.sh — Aplica la apariencia tipo Windows 11:
# tema Fluent con acento rojo, iconos Papirus y picom al arranque.
set -e
if [ "$(id -u)" -eq 0 ]; then SUDO=""; else SUDO="sudo"; fi

echo "==> Tema Fluent (GTK) con acento rojo"
if ! ls /usr/share/themes 2>/dev/null | grep -qi fluent; then
  TMP=$(mktemp -d)
  git clone --depth 1 https://github.com/vinceliuice/Fluent-gtk-theme.git "$TMP/fluent"
  ( cd "$TMP/fluent" && \
    $SUDO ./install.sh --dest /usr/share/themes --name Fluent --theme red --color light || \
    $SUDO ./install.sh -d /usr/share/themes -n Fluent -t red -c light || true )
  rm -rf "$TMP"
fi
TEMA=$(find /usr/share/themes -maxdepth 1 -iname 'fluent*red*' 2>/dev/null | sort | head -1)
[ -n "$TEMA" ] || TEMA=$(find /usr/share/themes -maxdepth 1 -iname 'fluent*' 2>/dev/null | head -1)
TEMA=$(basename "${TEMA:-Frost}")

echo "==> Configuración LXQt para el usuario $USER"
mkdir -p "$HOME/.config/lxqt" "$HOME/.config/autostart" "$HOME/.config/picom"
CONF="$HOME/.config/lxqt/lxqt.conf"
touch "$CONF"
grep -q '^\[General\]' "$CONF" || printf '[General]\n__userfile__=true\n' > "$CONF"
if grep -q '^theme=' "$CONF"; then
  sed -i "s|^theme=.*|theme=$TEMA|" "$CONF"
else
  echo "theme=$TEMA" >> "$CONF"
fi
if grep -q '^icon_theme=' "$CONF"; then
  sed -i "s|^icon_theme=.*|icon_theme=Papirus|" "$CONF"
else
  echo "icon_theme=Papirus" >> "$CONF"
fi

[ -f "$HOME/.config/picom/picom.conf" ] || \
  cp /etc/skel/.config/picom/picom.conf "$HOME/.config/picom/picom.conf" 2>/dev/null || true
cat > "$HOME/.config/autostart/picom.desktop" <<'EOF'
[Desktop Entry]
Type=Application
Name=picom
Exec=picom --config %h/.config/picom/picom.conf
EOF

echo "==> Reiniciando panel"
killall lxqt-panel 2>/dev/null || true
(setsid lxqt-panel >/dev/null 2>&1 &) || true

echo "Tema aplicado: $TEMA. Si algo no se refrescó, cierra y abre la sesión."
