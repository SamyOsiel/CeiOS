# 04 · Optimización para 2 GB de RAM (y qué aplica CeiOS)

## Presupuesto de memoria de referencia

| Aplicación | RAM típica |
| --- | --- |
| Sistema CeiOS en reposo (LXQt + picom + red) | 450–600 MB |
| Firefox ESR (3–5 pestañas) | 500–900 MB |
| LibreOffice Writer | 250–450 MB |
| Zotero | 300–450 MB |
| Word/Excel bajo Wine | 900–1400 MB |

Con 2 GB la regla es: **una tarea pesada a la vez**. Firefox + Zotero conviven bien; Firefox + Office/Wine no.

## Lo que CeiOS aplica automáticamente

- **zram 50 % con lz4** (`/etc/default/zramswap`): comprime la memoria en RAM en lugar de escribir en disco, vital con el eMMC lento de una Chromebook.
- `vm.swappiness=180` y `vm.vfs_cache_pressure=200` (`/etc/sysctl.d/99-ceios-lowram.conf`): el kernel prefiere comprimir y liberar cachés antes que bloquear aplicaciones.
- Servicios desactivados: `avahi-daemon`, `ModemManager`, `cups` (impresión: reactiva con `sudo systemctl enable --now cups`), `bluetooth` si existe y los temporizadores `apt-daily`.
- LXQt sobre **X11** con picom en modo ligero; sin efectos innecesarios ni índices de búsqueda de fondo.

## Buenas prácticas en el día a día

1. Navegador: usa **uBlock Origin** (ahorra 20–40 % de RAM) y pocas pestañas abiertas.
2. Zotero: desactiva la indexación de texto completo de PDF si no la necesitas (Editar → Preferencias → Búsqueda).
3. Vigila con `htop` y `zramctl`; si el zram está casi lleno de forma constante, cierra aplicaciones.
4. Mantenimiento: `sudo apt clean` de vez en cuando; la compilación de la ISO ya limpia cachés.
5. No instales entornos de escritorio adicionales ni aceleradores genéricos (preload, zswap junto a zram, etc.).

## Si algo se queda sin memoria

- El kernel (OOM) cerrará la aplicación más pesada; guarda tu trabajo con frecuencia.
- Para jobs científicos grandes (R o Python con datasets grandes) usa la tarjeta SD o un equipo de escritorio. CeiOS está pensado para escritura, gestión de referencias y análisis ligero.
