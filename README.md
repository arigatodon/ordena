# Ordena - Organizador de Archivos Ruby

Script mejorado que organiza archivos en carpetas según su tipo/extensión con múltiples características avanzadas.

## Características

- ✅ **Organización inteligente** por tipo de archivo con categorías expandidas
- ✅ **Modo dry-run** para previsualizar cambios sin ejecutar
- ✅ **Modo verbose** para ver detalles de cada operación
- ✅ **Manejo de errores** robusto con validación de permisos
- ✅ **Manejo de duplicados** automático con renombrado
- ✅ **Estadísticas** de archivos procesados y movidos
- ✅ **Interfaz de línea de comandos** y modo interactivo
- ✅ **Compatibilidad** con el script original

## Uso

### Línea de Comandos
```bash
# Organizar carpeta específica
ruby ordena_carpetas.rb /ruta/a/carpeta

# Ver qué haría sin ejecutar (dry-run)
ruby ordena_carpetas.rb --dry-run /ruta/a/carpeta

# Ver detalles de cada operación
ruby ordena_carpetas.rb --verbose /ruta/a/carpeta

# Combinar opciones
ruby ordena_carpetas.rb --dry-run --verbose /ruta/a/carpeta

# Ver ayuda
ruby ordena_carpetas.rb --help
```

### Modo Interactivo
```bash
# Ejecutar sin argumentos para modo interactivo
ruby ordena_carpetas.rb

# O con opciones
ruby ordena_carpetas.rb --verbose
```

## Categorías de Archivos Soportadas

| Categoría | Extensiones | Carpeta |
|-----------|-------------|---------|
| **Imágenes** | jpg, jpeg, png, gif, bmp, svg, webp, ico, tif, tiff | `imagenes/` |
| **Videos** | mp4, avi, mov, mkv, wmv, flv, webm, m4v, 3gp | `videos/` |
| **Audio** | mp3, wav, flac, ogg, aac, wma, m4a | `musica/` |
| **Documentos** | doc, docx, txt, md, rtf, odt | `documentos/` |
| **Hojas de Cálculo** | xls, xlsx, csv, ods | `hojas_calculo/` |
| **Presentaciones** | ppt, pptx, odp | `presentaciones/` |
| **PDF** | pdf | `pdf/` |
| **Comprimidos** | zip, rar, 7z, tar, gz, tgz, bz2, xz, deb, rpm, appimage | `comprimidos/` |
| **Código** | rb, py, js, html, css, java, cpp, c, php, go, rs, sql | `codigo/` |
| **Mapas** | kml, kmz | `mapas/` |
| **Programas** | exe, msi, dmg, run, app | `programas/` |
| **Otros** | Archivos con extensiones no reconocidas | `otros/` |

## Características Avanzadas

### Manejo de Duplicados
Si un archivo ya existe en la carpeta de destino, se renombra automáticamente:
- `documento.pdf` → `documento_1.pdf`
- Si `documento_1.pdf` existe → `documento_2.pdf`

### Archivos sin Extensión
Los archivos sin extensión (como Makefile, README, LICENSE) se saltan automáticamente para evitar mover archivos importantes del sistema.

### Manejo de Errores
- Validación de permisos de escritura
- Manejo de archivos en uso
- Mensajes de error informativos
- Códigos de salida apropiados

### Estadísticas y Logging
- Resumen de archivos procesados y movidos
- Lista detallada de operaciones en modo verbose
- Reporte de errores encontrados

## Ejemplos

### Organizar Descargas
```bash
ruby ordena_carpetas.rb ~/Downloads
```

### Previsualizar cambios
```bash
ruby ordena_carpetas.rb --dry-run --verbose ~/Downloads
```

### Modo interactivo con opciones
```bash
ruby ordena_carpetas.rb --verbose
# Luego escribir la ruta cuando se solicite
```

## Compatibilidad

Este script mantiene compatibilidad total con el comportamiento original, añadiendo nuevas características sin romper funcionalidad existente.

## Requisitos

- Ruby 2.5+ (probado con Ruby 3.2.3)
- Permisos de escritura en la carpeta a organizar
