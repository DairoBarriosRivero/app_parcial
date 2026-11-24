# 📱 app_parcial - TikTok Style Video Feed & Firebase Auth

Aplicación móvil desarrollada con **Flutter**, **Dart** y **Firebase**, diseñada con la estética inmersiva de **TikTok** (Dark Mode Material 3, degradados neón y animaciones fluidas). Cuenta con un feed de reproducción continua de videos verticales y un sistema completo de autenticación multi-proveedor gestionado con **GoRouter**.

---

## 🎬 Enlaces de los Videos del Feed (Muestra Pública)

Los videos reproducidos en el Feed utilizan URLs públicas y compatibles al 100% con el paquete `video_player`:

1. 🦋 **Video 1 (Mariposa Slow Motion)**: `https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4`
2. 🐝 **Video 2 (Naturaleza y Polinización)**: `https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4`
3. 🐰 **Video 3 (Big Buck Bunny Trailer)**: `https://media.w3.org/2010/05/bunny/trailer.mp4`
4. 🐉 **Video 4 (Sintel Epic Movie Trailer)**: `https://media.w3.org/2010/05/sintel/trailer.mp4`
5. 🚀 **Video 5 (Futuristic Tech Trailer)**: `https://media.w3.org/2010/05/video/movie_300.mp4`

---

## 🚀 Funcionalidades Principales

### 1. Métodos de Autenticación con Firebase
- **Correo y Contraseña**:
  - Registro validado con `createUserWithEmailAndPassword`.
  - Guardado del nombre de usuario con `updateDisplayName`.
  - Inicio de sesión seguro con `signInWithEmailAndPassword`.
  - Manejo completo de errores en español (correo duplicado, contraseña débil, credenciales incorrectas, etc.).
  - Recuperación de contraseña mediante correo electrónico (`sendPasswordResetEmail`).
- **Google Sign-In**:
  - Integración nativa con `GoogleSignIn` y `GoogleAuthProvider`.
  - En Web utiliza `signInWithPopup(GoogleAuthProvider())` para máxima compatibilidad sin bloqueos de cookies de terceros.
- **Facebook Login**:
  - Integración con `FacebookAuth` y `FacebookAuthProvider`.
  - Flujo OAuth oficial con alcance de perfil público.
- **Cierre de Sesión Unificado**:
  - Cierra la sesión activa en Firebase Auth, Google y Facebook simultáneamente.

### 2. Navegación y Control de Acceso (`GoRouter`)
- Rutas declarativas:
  - `/login`: Pantalla de inicio de sesión.
  - `/registro`: Pantalla de creación de cuenta.
  - `/feed`: Feed principal de videos.
- **Redirección reactiva (`refreshListenable`)**:
  - Si el usuario **no está autenticado**, únicamente puede ver `/login` y `/registro`. Si intenta acceder al `/feed`, es redirigido a `/login`.
  - Si el usuario **inicia sesión**, es redirigido de forma inmediata al `/feed`.
  - Si el usuario **cierra sesión**, regresa automáticamente a `/login` y no puede volver atrás sin autenticarse.

### 3. Feed de Videos Estilo TikTok
- Pantalla completa con desplazamiento vertical fluido mediante `PageView.builder`.
- **Gestión eficiente de recursos**: Reproduce automáticamente el video en pantalla y pausa/libera los controladores anteriores.
- **Interacciones táctiles**:
  - Toque en la pantalla para pausar/reanudar con indicador animado central.
  - Botón de **Me gusta** reactivo (cambia a rojo TikTok e incrementa contador).
  - Botón de **Comentarios** que abre un *Modal Bottom Sheet* interactivo con lista de comentarios y campo para redactar nuevos.
  - Botón de **Compartir** con notificación emergente de confirmación.
  - Disco de vinilo con animación de rotación continua.
  - Botón de **Perfil / Logout** en la barra superior con información del usuario conectado.

---

## 🛠️ Tecnologías y Paquetes Utilizados

| Paquete | Versión | Propósito |
| :--- | :--- | :--- |
| **`flutter`** | 3.47+ / Dart 3.13+ | SDK principal |
| **`firebase_core`** | ^5.2.0 | Inicialización de servicios de Firebase |
| **`firebase_auth`** | ^7.1.0 | Autenticación de usuarios |
| **`google_sign_in`** | ^6.2.1 | Integración con Google Identity |
| **`flutter_facebook_auth`** | ^7.3.3 | SDK de Facebook Login |
| **`video_player`** | ^2.14.1 | Reproducción multimedia de videos |
| **`go_router`** | ^18.1.4 | Navegación reactiva y control de acceso |

---

## ⚙️ Configuración del `.gitignore` (Políticas de Entrega)

Para cumplir con la solicitud del docente de no subir archivos multimedia pesados al repositorio Git, el archivo `.gitignore` incluye:

```gitignore
# Archivos de video y multimedia pesada
*.mp4
*.mov
*.avi
*.mkv
*.webm
*.flv
*.wmv
*.m4v
*.3gp
videos/
assets/videos/
*.mp4.zip
*.mov.zip
```

---

## 📦 Cómo Clonar y Ejecutar el Proyecto

1. **Clonar el repositorio**:
   ```bash
   git clone https://github.com/TU_USUARIO/app_parcial.git
   cd app_parcial
   ```

2. **Instalar dependencias**:
   ```bash
   flutter pub get
   ```

3. **Ejecutar en tu dispositivo o navegador**:
   ```bash
   # En navegador Chrome / Edge
   flutter run -d chrome

   # En emulador o dispositivo Android
   flutter run
   ```

---

## 👨‍💻 Autor

- **Desarrollador**: Dairo Barrios
- **Proyecto**: Parcial Flutter & Firebase - `app_parcial`
