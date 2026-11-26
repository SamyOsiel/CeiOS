#!/usr/bin/env python3
"""CeiOS · compose-wallpaper.py — Fondo de pantalla oficial (1920x1080).

Compone el fondo oficial de CeiOS a partir de:
  - La imagen del usuario, centrada en tarjeta redondeada con borde y sombra,
    sobre un fondo ambiental ampliado y difuminado con velo azul marino.
  - El emblema oficial (rombo + estrella + ramas + bandera cubana) y la
    marca CeiOS en la parte inferior, más la barra tricolor cubana.

Uso:
    compose-wallpaper.py [imagen_usuario] [salida.png] [emblema.png]

Requiere Pillow (python3-pil). Fuentes: Liberation Sans o DejaVu Sans
(instaladas por los paquetes fonts-liberation / fonts-dejavu-core).
"""
import math
import os
import sys

from PIL import Image, ImageDraw, ImageFilter, ImageFont, ImageEnhance

W, H = 1920, 1080
AZUL = (0, 42, 143)
ROJO = (206, 17, 38)
BLANCO = (245, 247, 250)
MARINO_TOP = (10, 33, 82)

BOLD = [
    '/usr/share/fonts/truetype/liberation/LiberationSans-Bold.ttf',
    '/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf',
    '/usr/share/fonts/truetype/noto/NotoSans-Bold.ttf',
]
REG = [
    '/usr/share/fonts/truetype/liberation/LiberationSans-Regular.ttf',
    '/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf',
    '/usr/share/fonts/truetype/noto/NotoSans-Regular.ttf',
]


def font(path_list, size):
    for p in path_list:
        if os.path.exists(p):
            return ImageFont.truetype(p, size)
    return ImageFont.load_default()


def rounded_mask(w, h, r):
    m = Image.new('L', (w * 2, h * 2), 0)          # 2x para suavizar bordes
    ImageDraw.Draw(m).rounded_rectangle((0, 0, w * 2 - 1, h * 2 - 1),
                                        radius=r * 2, fill=255)
    return m.resize((w, h), Image.LANCZOS)


def star(draw, cx, cy, r, fill):
    pts = []
    for i in range(10):
        ang = math.radians(-90 + i * 36)
        rr = r if i % 2 == 0 else r * 0.48
        pts.append((cx + rr * math.cos(ang), cy + rr * math.sin(ang)))
    draw.polygon(pts, fill=fill)


def build_backdrop(photo):
    """Copia de la foto ampliada y difuminada como fondo ambiental."""
    s = max(W / photo.width, H / photo.height)
    bw, bh = int(photo.width * s) + 1, int(photo.height * s) + 1
    back = photo.resize((bw, bh), Image.LANCZOS)
    x0, y0 = (bw - W) // 2, (bh - H) // 2
    back = back.crop((x0, y0, x0 + W, y0 + H))
    back = back.filter(ImageFilter.GaussianBlur(30))
    back = ImageEnhance.Brightness(back).enhance(0.38)
    back = ImageEnhance.Color(back).enhance(0.85)
    return back.convert('RGBA')


def compose(imagen, salida, emblema_png):
    photo = Image.open(imagen).convert('RGB')
    canvas = build_backdrop(photo)

    # Velo azul marino: más oscuro arriba/abajo, deja ver el centro
    veil = Image.new('RGBA', (W, H), MARINO_TOP + (0,))
    alphas = []
    for y in range(H):
        t = y / (H - 1)
        alphas.append(int(150 + 55 * t))            # 150 -> 205 hacia abajo
    va = Image.new('L', (1, H))
    va.putdata(alphas)
    veil.putalpha(va.resize((W, H)))
    canvas.alpha_composite(veil)

    # Resplandor central suave detrás de la tarjeta
    glow = Image.new('RGBA', (W, H), (0, 0, 0, 0))
    ImageDraw.Draw(glow).ellipse((330, 60, 1590, 900),
                                 fill=(35, 90, 210, 70))
    glow = glow.filter(ImageFilter.GaussianBlur(120))
    canvas.alpha_composite(glow)

    overlay = Image.new('RGBA', (W, H), (0, 0, 0, 0))
    d = ImageDraw.Draw(overlay)

    # Estrellas decorativas sutiles (eco de la estrella solitaria)
    for cx, cy, r, a in [(150, 130, 16, 90), (260, 84, 10, 60),
                         (1765, 118, 13, 75), (1836, 190, 8, 55),
                         (120, 900, 10, 50)]:
        star(d, cx, cy, r, (255, 255, 255, a))

    # ---- Tarjeta central con la foto del usuario ----
    cw, ch, radius = 1152, 610, 26
    px, py = (W - cw) // 2, 120
    card = photo.resize((cw, ch), Image.LANCZOS).convert('RGBA')
    mask = rounded_mask(cw, ch, radius)

    # sombra
    shadow = Image.new('RGBA', (W, H), (0, 0, 0, 0))
    ImageDraw.Draw(shadow).rounded_rectangle(
        (px, py + 18, px + cw, py + ch + 18), radius=radius,
        fill=(0, 4, 14, 170))
    canvas.alpha_composite(shadow.filter(ImageFilter.GaussianBlur(38)))

    canvas.paste(card, (px, py), mask)

    # borde blanco fino
    d.rounded_rectangle((px, py, px + cw, py + ch), radius=radius,
                        outline=(255, 255, 255, 140), width=3)
    canvas.alpha_composite(overlay)

    # ---- Marca abajo: emblema + CeiOS + tagline ----
    if emblema_png and os.path.exists(emblema_png):
        emblem = Image.open(emblema_png).convert('RGBA')
        emblem = emblem.resize((200, 200), Image.LANCZOS)
    else:
        emblem = Image.new('RGBA', (200, 200), (0, 0, 0, 0))
    f_big = font(BOLD, 88)
    f_tag = font(REG, 32)
    tag = 'Ciencia e Investigación · «Tocororo» v0.1'

    tw = d.textlength('CeiOS', font=f_big)
    total = 200 + 34 + tw
    x0 = (W - total) / 2
    ey = 772
    canvas.alpha_composite(emblem, (int(x0), int(ey)))
    ty = ey + 100 - 62                       # centro óptico del texto
    d2 = ImageDraw.Draw(canvas)
    d2.text((x0 + 234, ty), 'Cei', font=f_big, fill=BLANCO)
    d2.text((x0 + 234 + d2.textlength('Cei', font=f_big), ty), 'OS',
            font=f_big, fill=(232, 37, 58))
    tw_tag = d2.textlength(tag, font=f_tag)
    d2.text(((W - tw_tag) / 2, ey + 218), tag, font=f_tag,
            fill=(255, 255, 255, 200))

    # ---- Barra tricolor cubana abajo ----
    d2.rectangle((0, H - 8, W // 3, H), fill=AZUL)
    d2.rectangle((W // 3, H - 8, 2 * W // 3, H), fill=BLANCO)
    d2.rectangle((2 * W // 3, H - 8, W, H), fill=ROJO)

    out = canvas.convert('RGB')
    os.makedirs(os.path.dirname(os.path.abspath(salida)) or '.', exist_ok=True)
    out.save(salida, optimize=True)
    print('Fondo oficial generado:', salida)


def main():
    args = sys.argv[1:]
    imagen = args[0] if len(args) > 0 else ''
    salida = args[1] if len(args) > 1 else 'ceios-wallpaper-1920.png'
    emblema = args[2] if len(args) > 2 else ''
    if not imagen or not os.path.exists(imagen):
        print('Uso: compose-wallpaper.py <imagen_usuario> [salida.png] '
              '[emblema.png]')
        sys.exit(1)
    compose(imagen, salida, emblema)


if __name__ == '__main__':
    main()
