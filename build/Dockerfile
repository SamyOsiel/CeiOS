FROM debian:12

# CeiOS builder — entorno reproducible para compilar la ISO con live-build
RUN apt-get update && apt-get install -y --no-install-recommends \
    live-build squashfs-tools xorriso \
    grub-pc-bin grub-efi-amd64-bin \
    syslinux-common syslinux-utils \
    mtools dosfstools \
    git rsync ca-certificates curl \
    librsvg2-bin imagemagick \
    python3 python3-pil \
    fonts-liberation fonts-dejavu-core \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /work
# 1) Prepara la marca (PNG desde SVG + fondo oficial) y 2) compila la ISO
CMD ["bash", "-c", "bash build/ci-prepare.sh && bash build/build.sh"]
