# 06 · Compilar la ISO de CeiOS

## Requisitos del host de compilación

- Debian 12 (o contenedor Docker, recomendado), ~15 GB libres y acceso a internet.
- Docker con permisos para ejecutar contenedores (opción A).

## Opción A · Docker (recomendada, reproducible)

```bash
git clone https://github.com/SamyOsiel/CeiOS.git
cd CeiOS
docker build -t ceios-builder build/
docker run --rm -v "$PWD":/work ceios-builder
```

Resultado: `images/ceios-0.1-tocororo-amd64.iso` (~1,5–1,8 GB) y su `SHA256SUMS`.

## Opción B · Debian 12 nativo

```bash
sudo apt-get update
sudo apt-get install -y live-build squashfs-tools xorriso grub-pc-bin \
  grub-efi-amd64-bin syslinux-common syslinux-utils mtools dosfstools \
  git rsync librsvg2-bin
sudo ./build/build.sh
```

## Qué hace build.sh

1. Sincroniza `scripts/`, `theme/includes.chroot/` y `assets/` dentro de `build/lb-config/config/includes.chroot/`.
2. Si existe `assets/wallpaper/wallpaper-usuario.jpg`, genera el fondo con tu imagen **centrada** (requiere ImageMagick en el host).
3. Ejecuta `lb config` (lee `auto/config`) y `lb build`.
4. Renombra la ISO a `images/ceios-0.1-tocororo-amd64.iso` y calcula `SHA256SUMS`.

## Hooks de personalización (build/lb-config/config/hooks/normal/)

| Hook | Función |
| --- | --- |
| 0010-idioma-ceios | Locale `es_ES.UTF-8`, hostname `ceios` |
| 0020-bajo-consumo | Servicios apagados; sysctl y zram vienen de includes |
| 0030-marca-ceios | os-release «CeiOS 0.1 (Tocororo)», fondo 1920x1080, logo |
| 0040-tema-fluent-red | Clona Fluent (acento rojo) y lo fija en el perfil base |
| 0050-aplicaciones-ceios | Permisos de `/usr/local/bin/ceios/` y menú |
| 0060-limpieza | Cachés apt y temporales fuera |

## Probar la ISO sin quemarla

```bash
# Con 2 GB de RAM, igual que la Chromebook objetivo
qemu-system-x86_64 -m 2048 -k es \
  -cdrom images/ceios-0.1-tocororo-amd64.iso -boot d
```

## CI (GitHub Actions) — la ISO oficial

El workflow `.github/workflows/build-iso.yml` compila la ISO automáticamente en **cada push a `main`** (y también bajo demanda en Actions → «Compilar ISO oficial de CeiOS» → Run workflow):

1. Compila en un contenedor reproducible **Debian 12**: primero `build/ci-prepare.sh` regenera los PNG de branding desde los SVG, decodifica la foto oficial (`wallpaper-usuario.jpg.b64`) y compone el fondo oficial con `scripts/compose-wallpaper.py`; después `build/build.sh` ejecuta live-build.
2. Guarda la ISO como **artefacto** del workflow (14 días, requiere sesión iniciada).
3. Publica la ISO en la **release oficial** `v0.1-tocororo` junto a `SHA256SUMS`: [github.com/SamyOsiel/CeiOS/releases/tag/v0.1-tocororo](https://github.com/SamyOsiel/CeiOS/releases/tag/v0.1-tocororo).

Cada nueva compilación sustituye la ISO de la release por la última (`--clobber`).

## Personalizar el fondo con tu propia imagen en la ISO

Coloca tu foto en `assets/wallpaper/wallpaper-usuario.jpg` antes de compilar: si el host tiene ImageMagick, la ISO saldrá ya con tu imagen integrada y centrada. Sin foto, la ISO lleva el emblema oficial por defecto (rombo, estrella, ramas de laurel y bandera cubana).
