# Proyecto EduCode Mobile

## 1. Contexto general

Este proyecto es la versión móvil de EduCode, una plataforma educativa para aprender programación en Python.

Actualmente existe una versión web funcional y desplegada:

- Frontend: Angular 17.
- Frontend desplegado en Vercel.
- Backend: Node.js + Express.
- Backend desplegado en Railway.
- Base de datos y autenticación: Supabase.
- Código web y backend almacenado en GitHub.
- Laboratorio de ejecución de código Python funcionando desde el backend.

La aplicación Flutter debe replicar lo más fielmente posible la versión web existente, adaptándola correctamente a dispositivos móviles Android.

La aplicación móvil no debe crear un sistema independiente. Debe conectarse al mismo backend de Railway y utilizar los mismos usuarios, módulos, lecciones, progreso y configuraciones almacenados en Supabase.

---

## 2. Ubicación del proyecto

Este proyecto Flutter se encuentra en:

```text
C:\Users\axelc\Proyectos\Flutter\educode_mobile
```

El proyecto web original se encuentra separado en:

```text
C:\Users\axelc\Proyectos\EduCode
```

No se deben mezclar los archivos Angular con los archivos Flutter.

La aplicación móvil debe mantenerse como un proyecto independiente.

---

## 3. Objetivo principal

Construir una aplicación móvil Android utilizando Flutter que replique la funcionalidad y la identidad visual de EduCode Web.

La aplicación debe:

1. Permitir registrar usuarios.
2. Permitir iniciar sesión.
3. Mantener la sesión iniciada.
4. Mostrar un dashboard educativo.
5. Mostrar los módulos de aprendizaje.
6. Mostrar las lecciones de cada módulo.
7. Permitir marcar lecciones como completadas.
8. Sincronizar el progreso con el backend.
9. Mostrar estadísticas y logros.
10. Incluir un laboratorio para ejecutar código Python.
11. Permitir editar el perfil.
12. Permitir cambiar la contraseña.
13. Permitir configurar preferencias.
14. Permitir activar el modo oscuro.
15. Permitir cerrar sesión.
16. Mantener una navegación apropiada para teléfonos Android.
17. Conservar los colores, estilo, identidad y lenguaje visual de EduCode.

---

## 4. Referencia funcional existente

El proyecto web contiene las siguientes secciones:

### Sección pública

- Página de inicio.
- Registro.
- Inicio de sesión.

### Sección privada

- Dashboard.
- Módulos.
- Detalle de módulo.
- Lecciones.
- Laboratorio de código Python.
- Progreso.
- Configuración.
- Perfil.
- Cambio de contraseña.
- Eliminación de cuenta.

La estructura de rutas web equivalente es:

```text
/
 /register
 /login
 /platform/dashboard
 /platform/modules
 /platform/module/:id
 /platform/laboratory
 /platform/progress
 /platform/settings
 /platform/settings/profile
 /platform/settings/change-password
 /platform/settings/delete-account
```

En Flutter estas rutas deben adaptarse a una navegación móvil, pero deben conservar el mismo flujo funcional.

---

## 5. Backend existente

El backend de EduCode está construido con Node.js y Express y está desplegado en Railway.

Flutter debe consumir el backend mediante HTTP.

Las rutas disponibles son:

### Autenticación

```http
POST /auth/register
POST /auth/login
GET  /auth/me
PUT  /auth/profile
PUT  /auth/change-password
DELETE /auth/account
```

### Módulos

```http
GET /modules
GET /modules/:id
```

### Progreso

```http
GET  /progress
POST /progress/lessons/complete
DELETE /progress
```

### Configuración

```http
GET /settings
PUT /settings
```

### Laboratorio

```http
POST /execute
```

Todas las rutas privadas requieren el token JWT obtenido durante el inicio de sesión.

El token debe enviarse utilizando:

```http
Authorization: Bearer TOKEN
```

---

## 6. Reglas importantes de seguridad

Nunca colocar dentro de la aplicación Flutter:

- `SUPABASE_SERVICE_ROLE_KEY`.
- Claves privadas del backend.
- Contraseñas.
- Credenciales administrativas.
- Variables secretas de Railway.
- Variables secretas de Supabase.

Flutter debe comunicarse con el backend de Railway.

No conectar directamente Flutter con tablas privadas de Supabase si el backend ya proporciona las rutas necesarias.

La aplicación móvil debe guardar únicamente el token de sesión y los datos básicos del usuario en almacenamiento local seguro.

---

## 7. URLs del backend

La aplicación debe soportar dos ambientes:

### Desarrollo local con emulador Android

Si el backend se ejecuta localmente en el puerto 3000:

```text
http://10.0.2.2:3000
```

No utilizar `localhost` desde el emulador Android.

### Producción

La aplicación debe utilizar la URL pública del backend desplegado en Railway:

```text
https://URL-REAL-DE-RAILWAY
```

La URL de producción debe centralizarse en un archivo de configuración y no repetirse en cada pantalla.

Ejemplo conceptual:

```dart
class AppConfig {
  static const String apiBaseUrl = 'https://URL-REAL-DE-RAILWAY';
}
```

No inventar una URL. Si todavía no está configurada en el proyecto, dejarla claramente identificada para reemplazarla posteriormente.

---

## 8. Proyecto Flutter actual

El proyecto fue generado inicialmente con la plantilla estándar de Flutter.

Actualmente contiene una aplicación contador de ejemplo en:

```text
lib/main.dart
```

La pantalla contador debe reemplazarse progresivamente por la aplicación EduCode.

No borrar las carpetas nativas necesarias:

```text
android/
ios/
web/
windows/
linux/
macos/
```

El objetivo inicial es Android, utilizando un teléfono Android físico conectado mediante USB.

---

## 9. Dispositivo principal de pruebas

La aplicación se probará principalmente en un teléfono Android físico.

Debe funcionar correctamente en pantallas pequeñas y medianas.

Se debe considerar:

- Diferentes tamaños de pantalla.
- Barra de estado del teléfono.
- Barra de navegación inferior del sistema.
- Orientación vertical.
- Teclado virtual.
- Desplazamiento vertical.
- Campos de contraseña.
- Gestos táctiles.
- Botones suficientemente grandes.
- Lectura cómoda de textos.
- Manejo de errores de conexión.
- Indicadores de carga.
- Mensajes claros para el usuario.

La interfaz no debe depender de tamaños fijos que provoquen overflow.

Evitar errores como:

```text
RenderFlex overflowed
Bottom overflowed
Pixel overflow
```

Usar diseños responsivos con:

- `SafeArea`.
- `SingleChildScrollView`.
- `ListView`.
- `Expanded`.
- `Flexible`.
- `LayoutBuilder`.
- `MediaQuery` cuando sea necesario.

---

## 10. Arquitectura Flutter deseada

Organizar el código de manera profesional y escalable:

```text
lib/
├── main.dart
├── app.dart
├── core/
│   ├── config/
│   │   └── app_config.dart
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_texts.dart
│   │   └── app_constants.dart
│   ├── theme/
│   │   └── app_theme.dart
│   ├── routing/
│   │   └── app_router.dart
│   ├── network/
│   │   └── api_client.dart
│   ├── storage/
│   │   └── storage_service.dart
│   └── services/
│       ├── auth_service.dart
│       ├── modules_service.dart
│       ├── progress_service.dart
│       └── settings_service.dart
├── models/
│   ├── auth_user.dart
│   ├── module.dart
│   ├── lesson.dart
│   ├── progress.dart
│   ├── achievement.dart
│   └── app_settings.dart
├── features/
│   ├── home/
│   ├── auth/
│   │   ├── login/
│   │   └── register/
│   ├── platform/
│   │   ├── dashboard/
│   │   ├── modules/
│   │   ├── laboratory/
│   │   ├── progress/
│   │   └── settings/
│   └── shell/
│       └── mobile_shell.dart
└── shared/
    ├── widgets/
    ├── dialogs/
    ├── loading/
    ├── errors/
    └── extensions/
```

No colocar toda la aplicación dentro de `main.dart`.

`main.dart` debe encargarse únicamente de iniciar la aplicación.

---

## 11. Dependencias recomendadas

Agregar solo las dependencias realmente necesarias y mantener sus versiones en `pubspec.yaml`.

Dependencias iniciales recomendadas:

- `http` para llamadas HTTP.
- `shared_preferences` o almacenamiento seguro para sesión.
- `flutter_secure_storage` para guardar el token de forma más segura.
- `provider`, `riverpod` o una solución equivalente para estado, si resulta necesario.
- Una biblioteca para editar código si el laboratorio requiere edición avanzada.
- Una biblioteca de gráficos si el dashboard necesita gráficos.

No agregar dependencias innecesarias sin justificar su uso.

Antes de instalar una dependencia, revisar si Flutter puede resolver el problema utilizando sus widgets nativos.

Después de modificar `pubspec.yaml`, ejecutar:

```powershell
flutter pub get
```

---

## 12. Tema visual de EduCode

La identidad visual debe basarse en la versión web.

Colores principales identificados:

```text
Verde principal: #10B981
Azul:            #3B82F6
Morado:          #8B5CF6
Amarillo:        #F59E0B
Rojo:            #EF4444
Cian:            #06B6D4
Texto oscuro:    #1E293B
Texto secundario:#64748B
Fondo claro:     #F8FAFC
Fondo oscuro:    #0F172A
Superficie dark: #1E293B
```

El color principal de EduCode es el verde:

```text
#10B981
```

El diseño debe utilizar:

- Bordes redondeados.
- Tarjetas limpias.
- Espaciado cómodo.
- Fondos claros.
- Sombras sutiles.
- Iconografía clara.
- Jerarquía visual.
- Mensajes de estado visibles.
- Diseño moderno y educativo.

La aplicación debe tener tema claro y tema oscuro.

---

## 13. Navegación móvil

La versión web utiliza un sidebar.

En Android se debe utilizar una navegación móvil, preferiblemente:

- `NavigationBar` inferior.
- Menú lateral desplegable solo cuando sea necesario.
- AppBar con título y acciones.
- Navegación mediante rutas nombradas o una solución organizada.

Navegación principal recomendada:

```text
Inicio
Módulos
Laboratorio
Progreso
Configuración
```

La barra inferior no debe mostrar demasiadas opciones. La pantalla de configuración puede contener opciones secundarias.

El usuario autenticado debe poder cambiar entre las secciones principales sin perder su estado.

---

## 14. Pantallas a desarrollar

### 14.1 Inicio público

Debe incluir:

- Nombre EduCode.
- Descripción de la plataforma.
- Botón para iniciar sesión.
- Botón para registrarse.
- Presentación visual de aprendizaje de Python.
- Diseño adaptado para teléfono.

### 14.2 Inicio de sesión

Campos:

- Correo electrónico.
- Contraseña.

Funciones:

- Validar campos obligatorios.
- Validar formato del correo.
- Mostrar y ocultar contraseña.
- Mostrar estado de carga.
- Mostrar errores del backend.
- Guardar la sesión al iniciar correctamente.
- Redirigir al área privada.

### 14.3 Registro

Campos:

- Nombre.
- Correo electrónico.
- Contraseña.
- Confirmación de contraseña.
- Aceptación de términos.

Validaciones:

- Todos los campos son obligatorios.
- Correo válido.
- Contraseñas iguales.
- Contraseña de mínimo 8 caracteres.
- Términos aceptados.

Después del registro exitoso, guardar el token y dirigir al área privada.

### 14.4 Dashboard

Debe mostrar:

- Saludo personalizado.
- Nombre del usuario.
- Resumen de progreso.
- XP.
- Lecciones completadas.
- Módulos completados.
- Lecciones pendientes.
- Racha, si el backend la proporciona.
- Acceso rápido a módulos.
- Actividad reciente, si existe.
- Gráficos o indicadores adaptados a móvil.

### 14.5 Lista de módulos

Mostrar cada módulo con:

- Nombre.
- Descripción.
- Icono.
- Color.
- Dificultad.
- Cantidad de lecciones.
- Lecciones completadas.
- Porcentaje de avance.
- Estado:
  - No iniciado.
  - En progreso.
  - Completado.
- XP.

Módulos actuales:

1. Introducción a Python.
2. Variables.
3. Tipos de datos.
4. Operadores.
5. Condicionales.
6. Bucles.

### 14.6 Detalle de módulo

Mostrar:

- Nombre del módulo.
- Descripción.
- Dificultad.
- Progreso.
- Lista de lecciones.
- Duración de cada lección.
- Estado de cada lección.
- Contenido teórico.
- Bloques de código.
- Botón para marcar como completada.
- Navegación entre lecciones.

El contenido de las lecciones puede incluir elementos con esta estructura:

```json
[
  {
    "type": "text",
    "value": "Contenido explicativo"
  },
  {
    "type": "code",
    "value": "print('Hola, mundo')"
  }
]
```

La interfaz Flutter debe renderizar correctamente ambos tipos.

### 14.7 Laboratorio Python

Debe permitir:

- Elegir un módulo de práctica.
- Cargar un código inicial.
- Editar el código.
- Ejecutar el código.
- Mostrar salida estándar.
- Mostrar errores.
- Mostrar tiempo de ejecución.
- Mostrar código de salida.
- Limpiar la consola.
- Restaurar el código original.
- Mostrar estado de ejecución.
- Informar errores de conexión.
- Informar sesión expirada.

El código se envía al backend mediante:

```http
POST /execute
```

Body:

```json
{
  "code": "print('Hola, mundo')"
}
```

Respuesta esperada:

```json
{
  "stdout": "...",
  "stderr": "...",
  "output": "...",
  "exitCode": 0,
  "executionTime": 120
}
```

Nunca ejecutar código Python directamente dentro del teléfono para reemplazar el backend existente.

### 14.8 Progreso

Mostrar:

- Progreso general.
- Progreso por módulo.
- Lecciones completadas.
- Lecciones pendientes.
- XP.
- Módulos completados.
- Logros.
- Barras o indicadores visuales.
- Estado vacío cuando todavía no hay progreso.

### 14.9 Configuración

Incluir:

- Datos del perfil.
- Editar nombre.
- Editar biografía.
- Cambiar contraseña.
- Modo oscuro.
- Preferencias de notificaciones.
- Idioma, si el backend lo soporta.
- Eliminar cuenta.
- Cerrar sesión.

---

## 15. Autenticación y sesión

Implementar un servicio de autenticación centralizado.

Debe permitir:

- Registrar.
- Iniciar sesión.
- Obtener usuario actual.
- Verificar si existe sesión.
- Cerrar sesión.
- Actualizar perfil.
- Cambiar contraseña.
- Eliminar cuenta.

El token debe enviarse automáticamente en las peticiones privadas.

Cuando el backend devuelva HTTP 401:

1. Eliminar la sesión local.
2. Mostrar un mensaje apropiado.
3. Redirigir al login.

El usuario no debe tener que iniciar sesión nuevamente después de cerrar y abrir la aplicación, salvo que el token haya expirado o haya cerrado sesión.

---

## 16. Manejo de estados

Cada pantalla que consuma datos debe manejar:

- Estado inicial.
- Cargando.
- Datos cargados.
- Estado vacío.
- Error de red.
- Error del servidor.
- Sesión expirada.
- Acción exitosa.
- Acción en progreso.

No mostrar pantallas completamente vacías mientras se espera la respuesta del servidor.

Utilizar indicadores de carga claros.

Los mensajes deben estar en español.

---

## 17. Manejo de errores

Los errores deben ser entendibles para un usuario final.

Ejemplos:

```text
No se pudo conectar con el servidor.
Tu sesión expiró. Inicia sesión nuevamente.
El correo o la contraseña son incorrectos.
Todos los campos son obligatorios.
La lección no pudo marcarse como completada.
No se pudo cargar el módulo.
```

No mostrar únicamente excepciones técnicas como:

```text
SocketException
FormatException
ClientException
```

Esos errores pueden registrarse internamente, pero la interfaz debe mostrar mensajes amigables.

---

## 18. Reglas de implementación

- Mantener el código en español cuando se trate de textos visibles.
- Usar nombres de clases y variables en inglés o español de forma consistente.
- Preferir nombres claros.
- Evitar duplicar lógica.
- Crear componentes reutilizables.
- No construir widgets gigantescos.
- Separar UI, modelos, servicios y estado.
- No realizar llamadas HTTP directamente dentro de widgets complejos.
- No insertar claves privadas.
- No crear datos falsos como solución definitiva.
- Los datos de módulos y progreso deben provenir del backend.
- Usar datos simulados únicamente durante el desarrollo inicial y marcarlos claramente.
- No eliminar funcionalidades existentes sin autorización.
- No modificar el backend salvo que sea estrictamente necesario y se solicite explícitamente.
- No modificar el proyecto Angular.
- No crear cambios en despliegues de Vercel o Railway sin autorización.
- Mantener compatibilidad con Android.

---

## 19. Plan de desarrollo por fases

### Fase 1: Base del proyecto

- Reemplazar la plantilla contador.
- Crear `main.dart`.
- Crear `app.dart`.
- Crear tema claro y oscuro.
- Crear colores globales.
- Crear navegación inicial.
- Crear pantalla de inicio pública.
- Configurar el proyecto para Android.

### Fase 2: Autenticación

- Configurar cliente HTTP.
- Configurar almacenamiento local.
- Implementar login.
- Implementar registro.
- Implementar cierre de sesión.
- Implementar persistencia de sesión.
- Implementar manejo de HTTP 401.

### Fase 3: Plataforma principal

- Crear shell móvil.
- Crear navegación inferior.
- Crear AppBar reutilizable.
- Crear dashboard.
- Crear tarjetas de estadísticas.
- Crear estado de carga y errores.

### Fase 4: Módulos y lecciones

- Crear modelos.
- Consumir `/modules`.
- Consumir `/modules/:id`.
- Crear lista de módulos.
- Crear detalle de módulo.
- Renderizar textos y bloques de código.
- Marcar lecciones completadas.
- Sincronizar con `/progress`.

### Fase 5: Progreso

- Consumir resumen de progreso.
- Mostrar indicadores.
- Mostrar logros.
- Mostrar avance por módulo.
- Actualizar el dashboard.

### Fase 6: Laboratorio

- Crear selector de módulo.
- Crear editor de código.
- Ejecutar código mediante `/execute`.
- Mostrar consola.
- Mostrar errores.
- Agregar restaurar código y limpiar consola.

### Fase 7: Configuración

- Perfil.
- Cambio de contraseña.
- Preferencias.
- Modo oscuro.
- Eliminar cuenta.
- Cerrar sesión.

### Fase 8: Pruebas

- Probar en teléfono Android físico.
- Probar login.
- Probar registro.
- Probar carga de módulos.
- Probar completar lección.
- Probar sincronización de progreso.
- Probar laboratorio.
- Probar modo oscuro.
- Probar cierre de sesión.
- Corregir errores visuales.
- Ejecutar `flutter analyze`.
- Ejecutar `flutter test`.
- Generar APK.

---

## 20. Verificación técnica obligatoria

Después de realizar cambios importantes, ejecutar:

```powershell
flutter pub get
flutter analyze
flutter test
```

Cuando exista un dispositivo Android conectado:

```powershell
flutter devices
flutter run
```

Antes de entregar:

```powershell
flutter build apk --release
```

El APK esperado se encontrará normalmente en:

```text
build\app\outputs\flutter-apk\app-release.apk
```

No considerar una fase terminada si existen errores de compilación.

---

## 21. Entregable académico

El proyecto debe permitir preparar los siguientes entregables:

### Código fuente

Repositorio GitHub del proyecto Flutter.

### APK

Archivo instalable para Android.

### Informe final

El informe debe incluir:

1. Características específicas implementadas para dispositivos móviles.
2. Arquitectura de la aplicación.
3. Conexión con el backend existente.
4. Capturas de la aplicación.
5. Descripción de las funcionalidades.
6. Comparación entre Angular Web y Flutter Mobile.
7. Prueba de usabilidad con al menos 3 usuarios.
8. Tareas realizadas por los usuarios.
9. Tiempo de respuesta.
10. Tasa de errores.
11. Nivel de satisfacción.
12. Conclusiones.
13. Enlace al repositorio.
14. Enlace al APK.

---

## 22. Evaluación de usabilidad

Cuando la aplicación esté funcional, preparar una prueba con mínimo 3 usuarios reales.

Tareas sugeridas:

1. Crear una cuenta.
2. Iniciar sesión.
3. Encontrar el módulo de Variables.
4. Abrir una lección.
5. Marcar una lección como completada.
6. Revisar el progreso.
7. Ejecutar código en el laboratorio.
8. Cambiar una preferencia.
9. Cerrar sesión.

Registrar:

- Tiempo que tarda cada usuario.
- Si completa la tarea.
- Errores cometidos.
- Ayuda solicitada.
- Comentarios.
- Nivel de satisfacción.
- Dificultades observadas.

No inventar resultados. Los datos deberán recolectarse cuando la app esté lista.

---

## 23. Criterios de aceptación

La aplicación se considerará funcional cuando:

- Compile correctamente.
- Se ejecute en un teléfono Android.
- Permita registrar usuarios.
- Permita iniciar sesión.
- Mantenga la sesión.
- Muestre información real del backend.
- Muestre los módulos.
- Muestre las lecciones.
- Permita marcar lecciones.
- Sincronice el progreso.
- Muestre el dashboard.
- Permita ejecutar código mediante el backend.
- Permita cerrar sesión.
- Maneje errores de conexión.
- No exponga claves privadas.
- No presente overflow visual.
- Tenga navegación móvil usable.
- Posea tema claro y oscuro.
- Genere un APK instalable.

---

## 24. Primera tarea de Codex

Antes de implementar funcionalidades complejas:

1. Inspeccionar todo el proyecto Flutter.
2. Revisar `pubspec.yaml`.
3. Revisar la versión de Flutter y Dart.
4. Revisar el backend existente y sus rutas.
5. Crear la estructura de carpetas propuesta.
6. Reemplazar la pantalla contador.
7. Crear el tema visual de EduCode.
8. Crear navegación básica.
9. Crear la pantalla inicial pública.
10. Verificar que compile en Android.
11. No implementar todavía todo el sistema en un único archivo.
12. Informar claramente qué archivos fueron creados o modificados.
13. Ejecutar `flutter analyze` después de los cambios.

La implementación debe hacerse por fases pequeñas, verificables y funcionales.