# 01 · Instalación de CeiOS en una Chromebook

## 1. Por qué hace falta tocar el firmware

Chrome OS, con su firmware de fábrica, **no permite arrancar otro sistema operativo** desde USB. Para instalar CeiOS (o cualquier GNU/Linux) en una Chromebook hay que sustituir el firmware del fabricante por un firmware UEFI libre: **MrChromebox (coreboot + UEFI Full ROM)**.

Aviso importante:

- Solo es posible en modelos con procesador **Intel o AMD**. Los Chromebook con **ARM (Mediatek, Rockchip, Snapdragon) no son compatibles** con este método, ni con Wine, por lo que el módulo de Office 2016 tampoco funcionaría allí.
- Flashear el firmware tiene riesgos (un corte de energía puede dejar el equipo inutilizable) y puede invalidar la garantía. Haz copia de seguridad de tus datos antes.
- Es reversible: el mismo script permite **restaurar el firmware de fábrica** si guardaste la copia de seguridad que el propio script ofrece crear.

## 2. Comprobaciones previas

1. Busca tu modelo exacto en la lista de dispositivos soportados de MrChromebox («MrChromebox device list», sitio de techchrism) y confirma que aparece como soportado para UEFI Full ROM.
2. Necesitarás dos USB de 4 GB o más: uno para el backup del firmware y otro para la ISO de CeiOS.
3. Carga la Chromebook al 100 % y trabaja conectado a la corriente.

## 3. Flashear el firmware (UEFI Full ROM)

1. Entra en **modo desarrollador** (normalmente: Esc + Refrescar + Encender; luego Ctrl+D y confirmar).
2. Inicia Chrome OS, abre Crosh (Ctrl+Alt+T) y escribe `shell`.
3. Descarga y ejecuta el utilitario oficial:

```bash
cd ~
curl -LO https://mrchromebox.tech/firmware-util.sh
sudo bash firmware-util.sh
```

4. Elige **Install/Update UEFI (Full ROM) Firmware** y acepta crear la copia de seguridad del firmware original cuando la pida (guárdala fuera del equipo).
5. Al terminar, apaga el equipo.

## 4. Grabar y arrancar la ISO de CeiOS

1. Graba `ceios-0.1-tocororo-amd64.iso` en un USB con BalenaEtcher, o en Linux con:
   `sudo dd if=ceios-0.1-tocororo-amd64.iso of=/dev/sdX bs=4M status=progress oflag=sync`
2. Conecta el USB y enciende pulsando **Esc** para abrir el menú de arranque UEFI; selecciona el USB.
3. En el escritorio en vivo de CeiOS abre **Instalar CeiOS** (Calamares).

## 5. Particionado recomendado para 16 GB

- Opción simple: **Borrar disco** en Calamares (crea EFI + raíz ext4; sin swap de disco, porque CeiOS usa zram).
- El sistema instalado ocupa ~6,5 GB; el resto queda libre para tus proyectos. Para datos pesados (PDF de bibliografía, datasets) se recomienda una **tarjeta SD** o USB externo montado en `~/datos`.
- Con 16 GB no conviene separar `/home`: deja una sola partición raíz.

## 6. Después de instalar

- Abre **CeiOS · Primeros pasos** en el menú: aplica la apariencia Windows 11, optimiza la RAM y ofrece instalar Zotero, OnlyOffice, LaTeX, Python científico y los módulos Wine de Office 2016 y EndNote.
- Tu usuario tiene sudo; la contraseña es la que definiste en el instalador.

## 7. Volver a Chrome OS

Desde Chrome OS (antes de flashear) o desde el propio utilitario de MrChromebox puedes crear el backup y restaurar el firmware stock más tarde. Tenlo presente antes de instalar CeiOS definitivamente.
