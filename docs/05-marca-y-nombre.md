# 05 · Marca, nombre y paleta (guía de marketing)

## Nombre oficial

**CeiOS** — de «**C**iencia e **I**nvestigación **O**perating **S**ystem». Corto, pronunciable en español e inglés («se-i-OS»), y describe exactamente a quién sirve.

Eslogan propuesto: **«CeiOS · El sistema operativo de la ciencia y la investigación»**.

Variantes de mensaje por público:

- Universidades: «Todo un laboratorio de escritorio en 2 GB de RAM».
- Estudiantes: «Tu tesis, tus referencias y tu Office en la Chromebook que ya tienes».
- Prensa técnica: «Linux ligero con apariencia Windows 11 y las herramientas del investigador».

## Alternativas profesionales (si el equipo decide rebrandear)

| Nombre | Lectura | Riesgo |
| --- | --- | --- |
| **CeiOS** (recomendado) | Ciencia e Investigación OS | ninguno relevante |
| InvestiOS | «investigar» + OS | confusión con iOS de Apple |
| ScholarOS | anglicismo académico | pierde identidad hispana |
| EurekaOS | memorable, buen marketing | nombre muy repetido |
| LaboraOS | trabajo de laboratorio | genérico |
| AteneaOS | conocimiento clásico | no dice «ciencia aplicada» |

Consejo: conserva **CeiOS** como marca y usa **«Tocororo»** (ave nacional cubana) como **nombre de versión**: es único, memorable y libre de conflicto de marca.

## Paleta de la bandera cubana

| Uso | Color | Hex |
| --- | --- | --- |
| Primario / fondos profundos | Azul | `#002A8F` (variante oscura `#011646`) |
| Acento / acciones / energía | Rojo | `#CE1126` |
| Texto sobre azul / superficies | Blanco | `#FFFFFF` |
| Apoyo (órbitas, enlaces, gráficos) | Azul claro | `#5E8BFF` |

Reglas de uso: fondo azul oscuro para escritorio, arranque e iconografía; rojo solo como acento (botones primarios, barra de progreso, icono del menú); blanco para texto y marcos. Esquinas redondeadas de 8 px, tipografía **Noto Sans**, iconos **Papirus**.

## Activos

- **Emblema oficial** `assets/branding/ceios-emblema.svg`: rombo partido en diagonal (mitad superior roja, mitad inferior negra) con la estrella blanca central, flanqueado por dos ramas de laurel doradas y la bandera cubana ondeando detrás, todo sobre el cuadrado redondeado azul marino. Coincide con el icono `ceios-icono-512` y es la identidad de CeiOS; rinde homenaje al emblema de «100 años con Fidel» que inspiró el proyecto.
- **Icono de aplicación** `assets/branding/ceios-icon.svg`: mismo diseño que el emblema; es el botón de inicio del panel y el origen de los PNG de `assets/branding/png/` (512/128/64/48/32 px).
- **Logo horizontal** `assets/branding/ceios-logo.svg`: icono + wordmark «CeiOS» (con «OS» en rojo) y la etiqueta «CIENCIA E INVESTIGACIÓN».
- Fondo de escritorio oficial 1920x1080: `assets/wallpaper/ceios-wallpaper-1920.png` — la imagen del emblema «100 años con Fidel» centrada en tarjeta sobre fondo azul marino con degradado, estrellas sutiles, marca CeiOS y barra tricolor cubana. El SVG `assets/wallpaper/ceios-wallpaper.svg` se conserva como respaldo vectorial.
- Fondo personalizado con otra foto centrada: `scripts/make-wallpaper.sh` o el menú «Fondo y mi imagen» de `primeros-pasos.sh`.

Simbolismo del emblema: el **rombo** evoca la fortaleza y la precisión de la ciencia; la **estrella blanca** es la estrella solitaria de la nación; las **ramas de laurel** celebran el triunfo del conocimiento; la **bandera** ancla la identidad cubana del proyecto.
