# 07 · Fondo de escritorio con tu imagen (centrada)

CeiOS llega con un **fondo oficial ya compuesto** (`assets/wallpaper/ceios-wallpaper-1920.png`, 1920x1080): la imagen del emblema «100 años con Fidel» —el rombo rojo y negro con la estrella blanca y las ramas de laurel— centrada en tarjeta sobre un escenario azul marino con degradado, estrellas sutiles, la marca CeiOS y una barra tricolor cubana. Existe además un respaldo vectorial (`assets/wallpaper/ceios-wallpaper.svg`) con el emblema de CeiOS centrado y la barra tricolor, por si el sistema no trae el PNG.

Si quieres usar **otra imagen** como fondo —por ejemplo, la foto institucional de tu centro— el script oficial la integra **centrada** sobre ese mismo diseño:

```bash
bash /usr/local/bin/ceios/make-wallpaper.sh /ruta/a/mi-foto.jpg
```

- La imagen se escala para caber (sin deformarse) y queda **centrada**, con marco blanco, sombra suave y la paleta azul/roja cubana del fondo.
- El resultado se guarda en `~/.local/share/ceios/fondo-ceios.png` y se aplica al instante en LXQt (PCManFM-Qt).
- El cambio persiste tras reiniciar; para repetirlo con otra foto, vuelve a ejecutar el comando.

En el menú de aplicaciones: **CeiOS · Fondo con mi imagen** abre un selector de archivos y hace todo el trabajo.

## Para quien compila la ISO

El repositorio ya incluye el fondo oficial con el emblema «100 años con Fidel» (fotos y PNGs precompuestos), de modo que la ISO sale con él sin pasos extra. Si prefieres otra foto por defecto, colócala en `assets/wallpaper/wallpaper-usuario.jpg` antes de compilar (ver `docs/06-compilar-iso.md`) y la ISO saldrá ya con tu imagen integrada en el escritorio por defecto.
