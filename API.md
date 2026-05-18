# 📡 ZenFit — Guía de integración de la API (para el cliente Android)

Este documento es para quien desarrolle la **app Android** (u otro cliente).
**No necesitas la base de datos ni credenciales de Supabase.** Solo consumes la API REST.

---

## 1. Datos básicos

| Dato | Valor |
|---|---|
| **Base URL** | `https://zenfit-backend-ofv0.onrender.com` |
| **Formato** | JSON (`Content-Type: application/json`) |
| **Auth** | JWT (Bearer token en cabecera `Authorization`) |
| **Documentación viva** | `https://zenfit-backend-ofv0.onrender.com/swagger-ui.html` |
| **OpenAPI (para generar cliente)** | `https://zenfit-backend-ofv0.onrender.com/v3/api-docs` |

> ⚠️ **Plan gratuito**: el backend se "duerme" tras 15 min sin uso. La **primera
> petición** puede tardar 30-60 s en responder (arranque en frío). Configura
> timeouts de **60 segundos** en Retrofit/OkHttp.

---

## 2. Flujo de autenticación (JWT)

1. **Registro** o **Login** → el backend devuelve `accessToken` + `refreshToken`.
2. En cada petición protegida envías la cabecera:
   `Authorization: Bearer <accessToken>`
3. El `accessToken` caduca a los **15 min**. Cuando una petición devuelva **401**,
   llama a `/auth/refresh` con el `refreshToken` para obtener tokens nuevos.
4. El `refreshToken` es de **un solo uso** (al usarlo se invalida y recibes otro).

### Respuesta de auth (`AuthResponse`)
```json
{
  "accessToken": "eyJhbGciOiJIUzUxMiJ9...",
  "refreshToken": "uuid.uuid",
  "tokenType": "Bearer",
  "expiresInSeconds": 900,
  "user": {
    "id": "uuid",
    "email": "ana@zenfit.dev",
    "fullName": "Ana López",
    "avatarUrl": null,
    "role": "USER",
    "plan": "FREE",
    "emailVerified": false,
    "createdAt": "2026-05-18T18:00:00Z"
  }
}
```

---

## 3. Endpoints

### 🔓 Públicos (sin token)

| Método | Ruta | Body | Descripción |
|---|---|---|---|
| POST | `/auth/register` | `{ "email", "password", "fullName" }` | Crea cuenta. `password` mín. 8 car. |
| POST | `/auth/login` | `{ "email", "password" }` | Inicia sesión |
| POST | `/auth/refresh` | `{ "refreshToken" }` | Renueva tokens |
| POST | `/auth/logout` | `{ "refreshToken" }` | Revoca el refresh token (204) |

### 🔒 Protegidos (requieren `Authorization: Bearer <accessToken>`)

**Usuario / Perfil**
| Método | Ruta | Descripción |
|---|---|---|
| GET | `/users/me` | Datos del usuario actual |
| GET | `/users/me/profile` | Perfil de bienestar |
| PUT | `/users/me/profile` | Actualiza perfil `{ dateOfBirth, gender, heightCm, weightKg, fitnessGoal, activityLevel, medicalNotes }` |

**Hábitos**
| Método | Ruta | Descripción |
|---|---|---|
| GET | `/habits` | Lista hábitos (incluye `completedToday`, `currentStreak`, `totalCompletions`) |
| POST | `/habits` | Crea `{ name, description, frequency, targetPerPeriod, color, icon }` |
| PUT | `/habits/{id}` | Edita un hábito |
| DELETE | `/habits/{id}` | Elimina un hábito |
| POST | `/habits/{id}/toggle?date=YYYY-MM-DD` | Marca/desmarca hecho ese día (date opcional = hoy) |

**Sueño**
| Método | Ruta | Descripción |
|---|---|---|
| GET | `/sleep-logs?limit=30` | Historial de sueño |
| POST | `/sleep-logs` | Guarda `{ sleepDate, durationMinutes, quality (1-5), notes }` (upsert por fecha) |
| DELETE | `/sleep-logs/{id}` | Elimina un registro |

**Fitness**
| Método | Ruta | Descripción |
|---|---|---|
| GET | `/exercises` | Catálogo de ejercicios |
| GET | `/workouts` | Catálogo de rutinas (con sus ejercicios) |
| GET | `/workouts/{id}` | Detalle de una rutina |
| GET | `/workout-sessions?limit=20` | Historial de sesiones del usuario |
| POST | `/workout-sessions` | Registra sesión `{ workoutId, durationSeconds, caloriesBurned, perceivedEffort, notes }` |

**Dashboard**
| Método | Ruta | Descripción |
|---|---|---|
| GET | `/dashboard` | Resumen agregado (entrenos, hábitos hoy, racha, último sueño, sesiones recientes) |

---

## 4. Errores

Todos los errores devuelven el mismo formato JSON:
```json
{
  "timestamp": "2026-05-18T18:29:05Z",
  "status": 401,
  "error": "Unauthorized",
  "message": "Authentication required",
  "path": "/users/me",
  "fieldErrors": null
}
```
- **400** validación (mira `fieldErrors`) · **401** token inválido/ausente
- **403** sin permisos · **404** no existe · **409** conflicto (email ya registrado)

---

## 5. Notas para Android (Kotlin + Retrofit)

- **No hay problema de CORS** en Android (CORS es solo de navegadores).
- Usa **HTTPS** (ya lo es); Android bloquea HTTP en claro por defecto.
- Pon timeouts altos por el arranque en frío del free tier:
  ```kotlin
  val client = OkHttpClient.Builder()
      .connectTimeout(60, TimeUnit.SECONDS)
      .readTimeout(60, TimeUnit.SECONDS)
      .build()
  ```
- Implementa un **Interceptor** que añada `Authorization: Bearer <token>` y un
  **Authenticator** que llame a `/auth/refresh` cuando reciba 401.
- Puedes **autogenerar el cliente** desde el OpenAPI (`/v3/api-docs`) con
  OpenAPI Generator si quieres acelerar.

---

## 6. Para probar rápido (sin Android)

Importa la colección desde Swagger o prueba con `curl`:
```bash
# Registro
curl -X POST https://zenfit-backend-ofv0.onrender.com/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@zenfit.dev","password":"Password123","fullName":"Test"}'

# Usar el accessToken devuelto:
curl https://zenfit-backend-ofv0.onrender.com/users/me \
  -H "Authorization: Bearer <accessToken>"
```
