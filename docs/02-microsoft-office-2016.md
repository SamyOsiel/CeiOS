# 02 · Microsoft Office 2016 en CeiOS (módulo Wine)

## Marco legal y honesto

Microsoft Office 2016 es software **propietario y de pago**. CeiOS **no puede incluirlo ni redistribuirlo**: ningún sistema operativo legal puede hacerlo sin acuerdo con Microsoft. El módulo de CeiOS prepara el entorno (Wine, bibliotecas y accesos directos) y **requiere que tú aportes**:

- Una **licencia válida** de Office 2016 (clave de producto).
- El **instalador original** (la carpeta con `setup.exe` del DVD/ISO de Office 2016 que hayas comprado).

## Compatibilidad técnica

| Requisito | Detalle |
| --- | --- |
| CPU | Intel/AMD x86_64. **No funciona en Chromebooks ARM.** |
| Disco libre | ≥ 6 GB (Wine + prefix + Office) |
| RAM | 2 GB es el mínimo absoluto: documentos moderados y sin navegador abierto |
| Activación | Puede requerir iniciar sesión con tu cuenta Microsoft o activación telefónica |

El estado de Office 2016 bajo Wine cambia con cada versión; consulta la base de datos **WineHQ AppDB** («Microsoft Office 2016») antes de instalar. En este hardware el resultado esperable es razonable en **Word, Excel y PowerPoint** con documentos cotidianos; Outlook, Teams y las funciones de nube no están soportados.

## Instalación con el módulo de CeiOS

```bash
# 1) Prepara Wine y las bibliotecas que Office 2016 necesita (con sudo)
sudo bash /usr/local/bin/ceios/setup-wine-office2016.sh --preparar

# 2) Instala con TU medio original (sin sudo)
bash /usr/local/bin/ceios/setup-wine-office2016.sh --instalar /ruta/a/setup.exe

# 3) Al terminar quedan accesos directos de Word, Excel y PowerPoint en el menú
```

Qué hace el script: añade la arquitectura i386, instala `wine`, `wine32`, `winbind`, `winetricks` y `cabextract`; crea el prefix `~/.wine-office` (32 bits, recomendado para Office 2016) y aplica `corefonts msxml6 gdiplus riched20 fontsmooth=rgb win10`.

## Consejos para 2 GB de RAM

- Cierra Firefox y Zotero mientras uses Office bajo Wine.
- Trabaja en formatos nativos (.docx/.xlsx) y evita libros con miles de fórmulas.
- Si el rendimiento no te sirve, quedan dos alternativas serias:
  1. **LibreOffice** (incluido) y **OnlyOffice** (módulo gratuito), con muy buena compatibilidad de formato;
  2. **Office para la web** (office.com) desde Firefox, con tu suscripción Microsoft 365.

## Desinstalar

```bash
rm -rf ~/.wine-office
sudo apt-get remove --purge wine wine32 wine64 winbind winetricks   # opcional
```
