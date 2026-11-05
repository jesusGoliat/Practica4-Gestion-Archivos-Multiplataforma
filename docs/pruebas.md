# Pruebas realizadas — Práctica 4

## Entorno común

| Dato | Valor |
|---|---|
| Autora/autor de la ejecución | Jesús Ángel González Arellano |
| Fecha | 5 de noviembre de 2026 |
| Aplicaciones | Gestor de archivos (`gestor_archivos`) y juego (`juego_pares`) |
| Android | Celular físico por USB (modelo y API se registran al ejecutar) |
| iOS | Simulador de iPhone en GitHub Actions (`macos-15`) |
| Flutter / Dart | 3.47.6 / 3.13.5 |
| SHA probado | Se registra al final de la entrega |

Las pruebas unitarias y de widgets se ejecutaron antes de la evidencia en
dispositivo/simulador. El plan de este documento se escribió antes de ejecutar
los casos de dispositivo, como pide la lección de QA.

## Criterios de aceptación

1. **Éxito:** el gestor abre TXT, MD, JSON, XML e imágenes de su espacio privado
   y de una carpeta autorizada; el juego guarda y recupera una partida en los
   tres formatos sin perder puntaje, tiempo, configuración ni historial.
2. **Condición alterna/límite:** un archivo vacío, incompleto, con checksum
   alterado o una ruta sin permiso produce un mensaje legible y no bloquea la
   app ni borra otras partidas.

## Riesgos identificados

| Riesgo | Impacto | Caso que lo cubre |
|---|---|---|
| Un proveedor SAF no permite escribir/renombrar | Operación incompleta | AG-06, IG-06 y mensajes de “operación no permitida” |
| Bookmark de iOS queda obsoleto o se revoca | Carpeta externa no disponible | IG-04 e IG-06; se ofrece volver a autorizar/importar |
| Archivo de partida truncado o manipulado | Pérdida de una partida | AJ-02, AJ-03, IJ-02 e IJ-03 con checksum y validación |
| Cambio de orientación o texto ampliado | Overflow/inaccesibilidad | AG-05, AJ-05, IG-05, IJ-05 |
| Falta de red | La app depende de Internet | Casos offline AG-06/AJ-06/IG-06/IJ-06; la app no hace peticiones |

## Resultados automatizados (antes del dispositivo)

| Paquete | Pruebas | Resultado |
|---|---|---|
| `packages/comun` | 10 | Todas pasan |
| `apps/gestor_archivos` | 14 | Todas pasan |
| `apps/juego_pares` | 19 | Todas pasan |

Cubren: resaltado JSON/XML, MIME/UTType, temas claro/oscuro, operaciones de
archivos privados, traversal/symlinks, conflictos, caché de miniaturas,
serialización round-trip TXT/XML/JSON, checksum, archivos vacíos/truncados,
motor del juego, puntaje, racha, victoria y temporizador.

## Matriz de casos (24)

Los resultados se llenan **después** de ejecutar cada caso. Un caso bloqueado
no se cuenta como aprobado.

### Android — Gestor

| ID | Categoría | Pasos y resultado esperado | Estado | Evidencia |
|---|---|---|---|---|
| AG-01 | Ruta feliz | Abrir Ejemplos; abrir `bienvenida.txt`, `notas.md`, `datos.json`, `configuracion.xml` y la imagen; se ven sin error | Pendiente | `docs/img/android/gestor/` |
| AG-02 | Alterna/límite | Abrir `datos_invalidos.json` y cancelar el selector de carpeta; mensajes claros, sin crash | Pendiente | |
| AG-03 | Regresión | Cambiar Guinda/Azul y claro/oscuro; el explorador conserva la carpeta y los favoritos | Pendiente | |
| AG-04 | Navegación/estado | Entrar a subcarpeta, usar breadcrumbs/atrás, rotar, force-stop y reabrir; recientes persisten | Pendiente | |
| AG-05 | Accesibilidad | Texto al 200 %, TalkBack en una tarjeta y botones; sin overflow | Pendiente | |
| AG-06 | Compatibilidad/permiso | Autorizar una carpeta SAF; crear, renombrar, copiar, mover y eliminar; revocar permiso y reabrir | Pendiente | |

### Android — Juego

| ID | Categoría | Pasos y resultado esperado | Estado | Evidencia |
|---|---|---|---|---|
| AJ-01 | Ruta feliz | 4×4 relajado: voltear, acertar/fallar, puntaje y racha correctos | Pendiente | `docs/img/android/juego/` |
| AJ-02 | Alterna/límite | 6×6 contrarreloj: termina al agotarse el tiempo; cargar archivo corrupto muestra error | Pendiente | |
| AJ-03 | Regresión | Guardar en TXT, XML y JSON; listar metadatos y cargar cada formato | Pendiente | |
| AJ-04 | Navegación/estado | Autoguardado tras cada movimiento; force-stop y “Continuar” recupera el tablero | Pendiente | |
| AJ-05 | Accesibilidad | Semántica de cartas, escala 2.0, contraste y área táctil | Pendiente | |
| AJ-06 | Compatibilidad | Exportar/compartir con SAF, importar, modo avión y rotación | Pendiente | |

### iOS — Gestor

| ID | Categoría | Pasos y resultado esperado | Estado | Evidencia |
|---|---|---|---|---|
| IG-01 | Ruta feliz | Espacio privado y visores TXT/MD/JSON/XML/imagen en simulador | Pendiente | `docs/img/ios/gestor/` |
| IG-02 | Alterna/límite | JSON/XML inválidos, archivo vacío y `.xyz` no soportado; mensajes legibles | Pendiente | |
| IG-03 | Regresión | Temas Guinda/Azul y claro/oscuro sin perder estado | Pendiente | |
| IG-04 | Navegación/estado | Favoritos/recientes tras cerrar y reabrir; ruta eliminada marcada no disponible | Pendiente | |
| IG-05 | Accesibilidad | Semántica y escala 2.0 sin overflow | Pendiente | |
| IG-06 | Compatibilidad | Operaciones en Documents del sandbox, orientación y modo offline | Pendiente | |

### iOS — Juego

| ID | Categoría | Pasos y resultado esperado | Estado | Evidencia |
|---|---|---|---|---|
| IJ-01 | Ruta feliz | 4×4 relajado en simulador; puntaje y movimientos | Pendiente | `docs/img/ios/juego/` |
| IJ-02 | Alterna/límite | 6×6 contrarreloj y archivo corrupto | Pendiente | |
| IJ-03 | Regresión | Round-trip TXT/XML/JSON, lista y metadatos | Pendiente | |
| IJ-04 | Navegación/estado | Autoguardado y “Continuar” tras reabrir | Pendiente | |
| IJ-05 | Accesibilidad | Semántica y escala 2.0 | Pendiente | |
| IJ-06 | Compatibilidad | Tema oscuro, orientación, offline y operaciones en sandbox | Pendiente | |

## Casos no ejecutables y su tratamiento

- **Selector del sistema iOS y hoja de compartir:** no son automatizables en el
  simulador sin UI externa; se documentan como limitación y se sustituyen por
  los casos de operaciones en el sandbox (IG-01/IG-06, IJ-03/IJ-06).
- **VoiceOver/TalkBack manual:** se verifica con `Semantics` y escala de texto;
  si no hay lector disponible en el entorno, se registra como limitación.
- **API 24 física:** si el celular disponible tiene otra API, se registra y se
  usa `minSdk 24` como garantía de compilación; no se afirma una prueba en API 24.

## Defectos conocidos

Se completa al final. Cualquier defecto encontrado se documenta con pasos,
esperado vs. observado, severidad y estado; no se borra evidencia citada.

## SHA final

Se registra al cerrar la entrega; si los commits posteriores solo cambian
documentación, se declara expresamente.
