# 03 · EndNote en CeiOS (módulo Wine, avanzado)

## Marco legal

EndNote (Clarivate) es software propietario de pago. Igual que con Office, CeiOS **no lo incluye ni lo activa**: el módulo prepara Wine y requiere **tu licencia y tu instalador original**.

## Advertencia honesta para este hardware

EndNote para Windows depende de **.NET Framework 4.x**. Bajo Wine, instalar `dotnet48` ocupa ~1,5 GB de disco, tarda mucho (20–40 minutos) y es el paso más frágil de todo el sistema. En una Chromebook de **16 GB y 2 GB de RAM** el resultado esperable es:

- Instalación posible solo si hay **≥ 8 GB libres** (el script lo comprueba y se niega si no).
- Uso lento: abrir la biblioteca y sincronizar puede tardar minutos.
- Riesgo alto de fallos de .NET cuando Wine se actualiza.

**Recomendación oficial de CeiOS**: usa **Zotero**, que viene como módulo nativo gratuito, es más ligero y se integra con LibreOffice y Word. Puedes exportar tu biblioteca EndNote a `RIS` o `BibTeX` (File → Export) e importarla en Zotero sin perder referencias ni los PDF adjuntos enlazados.

## Instalación (bajo tu responsabilidad)

```bash
# Comprobaciones + .NET 4.8 + tu instalador original
bash /usr/local/bin/ceios/setup-wine-endnote.sh --instalar /ruta/a/EndNoteInstaller.exe
```

El script: exige confirmación explícita, verifica 8 GB libres, reutiliza el Wine instalado por el módulo de Office, aplica `dotnet48 corefonts` en el prefix `~/.wine-endnote` y lanza el instalador. Si .NET falla, el mensaje sugerirá usar EndNote en otro equipo o migrar la biblioteca a Zotero.

## Salidas dignas si EndNote es imprescindible

- Ejecutar EndNote en la **nube institucional** (VDI de tu universidad).
- Máquina virtual Windows, solo en equipos con más RAM.
- Mantener la biblioteca compartida y **citar desde Zotero** con el estilo de salida exacto que exija la revista (Zotero trae miles de estilos CSL).
