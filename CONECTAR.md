# ZenFit · Cómo conectarte al proyecto

> Documento para compartir con el equipo. Incluye URLs, cómo entrar a la web, cómo correr el código localmente y cómo solucionar los problemas más típicos.

---

## 🌐 URLs de producción

| Recurso | URL | Notas |
|---------|-----|-------|
| **Web pública (lo más fácil)** | https://zenfit-frontend.onrender.com | Lista para usar, solo abre el enlace |
| **API REST (backend)** | https://zenfit-backend-ofv0.onrender.com | Devuelve JSON |
| **Swagger UI (documentación API interactiva)** | https://zenfit-backend-ofv0.onrender.com/swagger-ui.html | Para probar endpoints con clicks |
| **OpenAPI JSON** | https://zenfit-backend-ofv0.onrender.com/v3/api-docs | Para importar en Postman/Insomnia |
| **Health check** | https://zenfit-backend-ofv0.onrender.com/actuator/health | Devuelve `{"status":"UP"}` cuando está sano |

---

## ✅ Estado actual

El servicio **está vivo y operativo** (verificado el 24/05/2026):

- Frontend → HTTP 200 OK
- Backend → `POST /auth/login` responde con validación correcta
- Base de datos (Supabase) → conectada, todas las tablas creadas (V1–V9)

> Si parece "caído", lee la sección **[Cold start](#-importante-cold-start-del-plan-free-de-render)** más abajo. **Casi siempre** es eso, no una caída real.

---

## 🟢 Opción 1 — Usar la web desplegada (más fácil)

Solo abre en tu navegador:

> ### 👉 https://zenfit-frontend.onrender.com

1. Crea tu cuenta con `Registrarse → Crear cuenta gratis`
2. Inicia sesión
3. Ya estás dentro

**No necesitas instalar nada.** La web ya carga la API correcta automáticamente.

---

## 🟡 Opción 2 — Correr el frontend en tu máquina apuntando al backend de producción

Útil si quieres trabajar en el código del frontend sin levantar tu propio backend.

### Requisitos

- **Node.js 18** o superior (`node --version`)
- **Git**

### Pasos

```bash
# 1. Clona el repo
git clone https://github.com/samaulo75-hash/Zenfit-Claude.git
cd Zenfit-Claude/frontend

# 2. Instala dependencias
npm install

# 3. Crea el archivo .env apuntando al backend de producción
echo VITE_API_BASE_URL=https://zenfit-backend-ofv0.onrender.com > .env

# 4. Arranca el dev server
npm run dev
```

Abre **http://localhost:5173** en el navegador. Cualquier cambio en el código se recargará en caliente.

---

## 🔴 Opción 3 — Levantar TODO en local (frontend + backend + BBDD)

Para desarrollo "full stack" sin depender de Render.

### Requisitos extra

- **JDK 21** o superior (`java -version`)
- **Docker Desktop** (para PostgreSQL local)

### Pasos

```powershell
# 1. Clona y entra
git clone https://github.com/samaulo75-hash/Zenfit-Claude.git
cd Zenfit-Claude

# 2. Levanta PostgreSQL + pgAdmin
docker compose up -d

# 3. Backend (Spring Boot en :8080)
cd backend
.\mvnw.cmd -DskipTests spring-boot:run
# Espera a que Tomcat arranque y Flyway aplique las migraciones V1..V9

# 4. (En otra terminal) Frontend (Vite en :5173)
cd ../frontend
# Crea .env apuntando al backend LOCAL
echo VITE_API_BASE_URL=http://localhost:8080 > .env
npm install
npm run dev
```

Abre **http://localhost:5173**. Tu base de datos local viene **vacía**: regístrate para crear tu primera cuenta.

---

## ⚠️ IMPORTANTE: Cold start del plan free de Render

> Si al entrar te aparece **"Network Error"**, **"No se conecta"**, o tarda muchísimo en cargar la primera vez — **NO ESTÁ CAÍDO**. Es esto:

El backend está alojado en **Render Free Tier**, que pone el servidor en pausa tras **15 minutos sin tráfico**. La primera petición tras la pausa tarda **30-60 segundos** en despertar el contenedor.

### Cómo identificarlo

- Llevas más de 15 min sin que nadie use la app → es muy probable que esté dormido
- Sales del login con error de red → primer intento despertó al servidor
- **El segundo intento (10-30s después) debería funcionar normalmente**

### Qué hacer

1. **Espera 30-60 segundos** y vuelve a intentar
2. La web te avisará con un banner azul abajo: *"Conectando con el servidor… puede tardar unos segundos"*
3. Si quieres forzar que despierte antes, abre directamente:
   - https://zenfit-backend-ofv0.onrender.com/actuator/health
   - La primera carga tarda; espera a que devuelva `{"status":"UP"}`

### Verificación manual desde terminal

Para confirmar que el backend está vivo:

```powershell
# PowerShell (Windows)
curl https://zenfit-backend-ofv0.onrender.com/auth/login `
  -X POST `
  -H "Content-Type: application/json" `
  -d '{"email":"test@test.com","password":"x"}'
```

```bash
# Bash (Linux / Mac)
curl https://zenfit-backend-ofv0.onrender.com/auth/login \
  -X POST \
  -H "Content-Type: application/json" \
  -d '{"email":"test@test.com","password":"x"}'
```

**Respuesta esperada** (después de los 30-60s del cold start):

```json
{
  "timestamp": "2026-05-24T15:31:44Z",
  "status": 401,
  "error": "Unauthorized",
  "message": "Invalid email or password",
  "path": "/auth/login"
}
```

Si recibes esa respuesta → **el backend funciona perfectamente** (solo te dice que esas credenciales no son válidas, lo cual es correcto porque ese usuario no existe).

---

## 📚 Endpoints principales de la API

Todos parten de `https://zenfit-backend-ofv0.onrender.com`.

### 🔐 Autenticación

| Método | Endpoint | Cuerpo | Descripción |
|--------|----------|--------|-------------|
| POST | `/auth/register` | `{email, password, fullName}` | Crear cuenta |
| POST | `/auth/login` | `{email, password}` | Iniciar sesión, devuelve `{accessToken, refreshToken, user}` |
| POST | `/auth/refresh` | `{refreshToken}` | Renovar el access token |
| POST | `/auth/logout` | `{refreshToken}` | Cerrar sesión |
| POST | `/auth/forgot-password` | `{email}` | Solicitar reseteo de contraseña |
| POST | `/auth/reset-password` | `{token, newPassword}` | Aplicar nueva contraseña |
| POST | `/auth/change-password` *(auth)* | `{currentPassword, newPassword}` | Cambiar contraseña estando logueado |

### 👤 Usuario

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| GET | `/users/me` | Mi información |
| PATCH | `/users/me` | Actualizar nombre |
| GET | `/users/me/profile` | Perfil de bienestar |
| PUT | `/users/me/profile` | Actualizar perfil |
| GET | `/users/me/export` | Descargar todos mis datos en JSON |
| DELETE | `/users/me` | Eliminar mi cuenta |

### 🏋️ Fitness

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| GET | `/workouts` | Lista de rutinas (con filtros opcionales) |
| GET | `/workouts/{id}` | Detalle de una rutina |
| GET | `/workouts/sessions` | Mi historial de sesiones |
| POST | `/workouts/sessions` | Registrar una sesión completada |

### 🥗 Dietas

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| GET | `/diets` | Catálogo de planes de dieta |
| GET | `/diets/recommended` | Recomendadas según mi objetivo |
| GET | `/diets/saved` | Mis dietas guardadas |
| POST | `/diets/{id}/save` | Guardar una dieta como favorita |
| DELETE | `/diets/{id}/save` | Quitar de favoritas |
| GET | `/diets/mine` | Mis dietas personalizadas |
| POST | `/diets/mine` | Crear dieta personalizada |
| PUT | `/diets/mine/{id}` | Editar dieta |
| DELETE | `/diets/mine/{id}` | Eliminar dieta |
| GET | `/foods` | Catálogo de alimentos (con `?q=` para buscar) |

### 🛌 Sueño

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| GET | `/sleep` | Mi historial de sueño |
| POST | `/sleep` | Registrar día de sueño |
| DELETE | `/sleep/{id}` | Borrar registro |

### ✅ Hábitos

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| GET | `/habits` | Mis hábitos |
| POST | `/habits` | Crear hábito |
| PATCH | `/habits/{id}` | Actualizar |
| DELETE | `/habits/{id}` | Borrar |
| POST | `/habits/{id}/toggle` | Marcar/desmarcar hoy |

### 📊 Dashboard

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| GET | `/dashboard` | Resumen agregado de mi semana |

> Para detalles completos (todos los campos, respuestas, códigos de error) ver **Swagger UI** en https://zenfit-backend-ofv0.onrender.com/swagger-ui.html o el archivo `API.md` del repositorio.

---

## 🔑 Autenticación: cómo usar el token

Todas las rutas excepto las marcadas como públicas requieren un **JWT Bearer Token**.

### Flujo

```
1. POST /auth/login con email+password
   ⮕ recibes { accessToken, refreshToken, user }

2. Para cada petición autenticada, añade el header:
   Authorization: Bearer <accessToken>

3. Cuando el accessToken expire (15 min):
   POST /auth/refresh con { refreshToken }
   ⮕ recibes un nuevo par de tokens
```

### Ejemplo con curl

```bash
# 1) Login
RESPONSE=$(curl -s https://zenfit-backend-ofv0.onrender.com/auth/login \
  -X POST \
  -H "Content-Type: application/json" \
  -d '{"email":"miemail@gmail.com","password":"mipass1234"}')

TOKEN=$(echo $RESPONSE | jq -r '.accessToken')

# 2) Llamar a un endpoint autenticado
curl https://zenfit-backend-ofv0.onrender.com/users/me \
  -H "Authorization: Bearer $TOKEN"
```

---

## 🐞 Solución de problemas frecuentes

### "Network Error" o "No se conecta"

➡️ **Causa más probable**: cold start del backend (lee la sección de arriba). Espera 30-60s.

➡️ Si tras 60s persiste: comprueba con `curl` el endpoint `/auth/login`. Si devuelve HTTP 401 con JSON → backend OK, problema en el cliente. Si no responde nada en 90s → entonces sí está realmente caído.

### "CORS error" en consola del navegador

➡️ El backend solo acepta orígenes registrados. Los aceptados son:
- `http://localhost:5173` (Vite dev)
- `http://localhost:4173` (Vite preview)
- `https://zenfit-frontend.onrender.com` (producción)

Si trabajas en otro origen, dime y lo añado al `application.yml`.

### "401 Unauthorized" tras un rato

➡️ Tu `accessToken` expiró (vive 15 min). Llama a `POST /auth/refresh` con tu `refreshToken` para conseguir uno nuevo. **El cliente web lo hace automáticamente vía interceptor de Axios.**

### "404 Not Found" en un endpoint

➡️ Revisa el método HTTP exacto. Por ejemplo `POST /workouts/sessions`, no `GET`. Consulta Swagger para asegurarte.

### "Cargo la web pero todo se ve en blanco"

➡️ Caché del navegador. **Ctrl+Shift+R** (hard refresh) en Chrome/Brave/Firefox o **Cmd+Shift+R** en Mac.

### "Necesito un endpoint que no existe"

➡️ Mándale un mensaje a Samuel diciendo qué endpoint te falta y para qué lo necesitas.

---

## 📞 Contacto

Cualquier duda o bug, contactad con **Samuel López** (samaulo75-hash en GitHub).

**Repositorio:** https://github.com/samaulo75-hash/Zenfit-Claude
