# ZenFit — Documentación técnica para la memoria

> Contenido listo para copiar a las secciones **5.1**, **5.2** y **5.3** de la memoria del Proyecto Intermodular DAM.
> Refleja **exactamente** lo que hemos construido: Spring Boot + PostgreSQL + Vue 3 (NO Firebase, NO SQLite, NO MVVM).

---

## 5.1 — Arquitectura del sistema

ZenFit sigue una **arquitectura cliente-servidor en 3 capas** desplegada en la nube, con un **API REST** como contrato único entre clientes y servidor.

### 5.1.1 Visión general

```
┌────────────────────────────┐    HTTPS + JWT     ┌──────────────────────────┐    JDBC + SSL     ┌────────────────────┐
│  Cliente web (Vue 3 SPA)   │ ─────────────────► │  API REST (Spring Boot)  │ ────────────────► │  PostgreSQL 16     │
│  Render Static Site         │                    │  Render Docker            │                    │  Supabase           │
│  • Vue 3 + Vite             │ ◄───────────────── │  • Spring Security + JWT  │ ◄──────────────── │  • Flyway migrations│
│  • Vue Router               │   JSON responses   │  • Spring Data JPA        │   ResultSets      │  • 28 tablas        │
│  • Axios (interceptors)     │                    │  • Hibernate 6            │                    │  • Datos seed       │
└────────────────────────────┘                    └──────────────────────────┘                    └────────────────────┘
                                                                │
                                                                │ (futuro)
                                                                ▼
                                                  ┌──────────────────────────┐
                                                  │  Cliente móvil (Android) │
                                                  │  • Kotlin + Retrofit      │
                                                  │  • Consume la misma API   │
                                                  └──────────────────────────┘
```

### 5.1.2 Componentes principales

- **Cliente web (Vue 3 SPA)**
  - Aplicación de página única construida con **Vue 3 + Vite + Vue Router**.
  - Estado global mediante **composables** propios (`useAuth`, `useTheme`) en lugar de Vuex/Pinia, manteniendo la base mínima.
  - Comunicación con el backend a través de **Axios** con dos interceptores:
    - *Request:* añade automáticamente el `Bearer <accessToken>` a cada petición autenticada.
    - *Response:* refresca el `accessToken` con el `refreshToken` ante un 401, reintenta la petición original transparentemente (patrón *single-flight* para no lanzar refresh duplicados en paralelo).
  - Tema claro/oscuro mediante variables CSS aplicadas con la clase `dark` en `<html>`, persistido en `localStorage`.
  - Generación de exports **JSON / Excel (xlsx) / PDF (jspdf)** del lado del cliente con *dynamic imports* para no inflar el bundle inicial (las librerías pesadas se descargan solo cuando el usuario pulsa el botón correspondiente).

- **API REST (Spring Boot 3.3.5 sobre Java 21)**
  - Patrón arquitectónico **por capas**:
    - `Controller` — endpoints REST (`@RestController`), validación con Jakarta Bean Validation.
    - `Service` — lógica de negocio, anotado con `@Transactional`.
    - `Repository` — acceso a datos con Spring Data JPA.
    - `Entity` / `DTO` — entidades JPA mapeadas a tablas + DTOs (Java `record`) para la API.
  - Seguridad con **Spring Security + JWT (jjwt 0.12.6)**:
    - *Access token* (JWT firmado HS256, vida corta).
    - *Refresh token* (UUID aleatorio guardado en BBDD, rotación en cada uso, revocable).
    - Tokens de reseteo de contraseña independientes (`password_reset_tokens`, 30 min TTL).
  - **CORS** restringido a los orígenes de Render y `localhost` para desarrollo.
  - **GlobalExceptionHandler** que devuelve estructuras de error uniformes (`ApiError`).

- **Base de datos (PostgreSQL 16)**
  - Esquema gestionado por **Flyway** con migraciones versionadas (V1 → V9).
  - Uso intensivo de **tipos avanzados de Postgres**: `UUID` como PK, `JSONB` para preferencias y payloads de IA, `TEXT[]` para grupos musculares y equipamiento, `ENUM` nativos para roles, dificultades, tipos de entrenamiento, etc.
  - Función `set_updated_at()` + triggers `BEFORE UPDATE` para mantener `updated_at` actualizado automáticamente.
  - Integridad referencial completa con `ON DELETE CASCADE` allá donde el borrado debe propagarse (todos los datos vinculados a un `user_id`).
  - En producción se despliega en **Supabase** (PostgreSQL 16 gestionado) usando el *Session Pooler* sobre IPv4 puerto 5432 con `sslmode=require`.

- **Cliente móvil (Android)** — *previsto, no implementado en esta primera entrega*. Consumirá la misma API REST con Retrofit + Kotlin, reutilizando los DTOs ya definidos.

### 5.1.3 Patrón arquitectónico

ZenFit **no usa MVVM** (que es típico de aplicaciones móviles), sino:

- **Backend → arquitectura por capas + REST API stateless**. Cada petición lleva su propio JWT, no hay sesiones en servidor (`SessionCreationPolicy.STATELESS`).
- **Frontend → componentes Vue + composables**. La separación es:
  - *Views* (`/views/*.vue`) — páginas completas asociadas a rutas.
  - *Components* (`/components/*`) — bloques reutilizables (cards, layouts, player, etc.).
  - *Composables* (`/composables/*.js`) — lógica reactiva compartida.
  - *Services* (`/services/*.js`) — wrappers sobre el cliente Axios para hablar con la API.
  - *Lib* (`/lib/*.js`) — utilidades transversales (storage, preferences, dataExporter).

### 5.1.4 Flujo de datos principal

1. El usuario interactúa con un **componente Vue** (por ejemplo, abre la calculadora de sueño y elige hora de despertar).
2. El componente llama a un **service** del frontend (p. ej. `authService.changePassword`).
3. El service usa el cliente **Axios** preconfigurado, que adjunta el JWT.
4. La petición llega al **Controller** de Spring Boot, que valida el `@RequestBody`.
5. El Controller delega en el **Service**, que ejecuta la lógica de negocio dentro de una transacción (`@Transactional`).
6. El Service usa los **Repositories** de Spring Data JPA, que generan las consultas SQL contra **PostgreSQL**.
7. La respuesta se serializa como **JSON** mediante un **DTO** (`record`) que no expone campos sensibles (como el `passwordHash`).
8. Axios recibe la respuesta y actualiza el estado reactivo del componente, lo que provoca el *re-render* de la vista.

---

## 5.2 — Requisitos de instalación y uso

### 5.2.1 Para el desarrollo

| Herramienta | Versión | Función |
|-------------|---------|---------|
| **JDK** | 21 (recomendado) o 25 | Compilación y ejecución del backend |
| **Maven Wrapper** | incluido en el repo (`mvnw`) | Build, dependencias, plugins. No requiere instalación de Maven global |
| **Node.js** | 18.x o superior | Ejecución del frontend Vue/Vite |
| **npm** | 9 o superior | Gestor de dependencias del frontend |
| **Docker Desktop** | 4.x | Postgres local y pgAdmin vía `docker-compose.yml` |
| **Git** | 2.30+ | Control de versiones |
| **IDE recomendado** | IntelliJ IDEA (backend) + VS Code (frontend) | Desarrollo |
| **Cuenta GitHub** | — | Hosting del repositorio |
| **Cuenta Render** | Plan Free | Despliegue de frontend (Static Site) y backend (Docker) |
| **Cuenta Supabase** | Plan Free | PostgreSQL gestionado en producción |

### 5.2.2 Levantar el entorno local

```bash
# 1) Postgres + pgAdmin
docker compose up -d                  # postgres en :15432, pgadmin en :5050

# 2) Backend (la primera vez tras tocar código)
cd backend
./mvnw -DskipTests clean spring-boot:run     # arranca en http://localhost:8080
                                              # Flyway aplica V1..V9 automáticamente

# 3) Frontend
cd frontend
npm install
npm run dev                            # arranca en http://localhost:5173
```

Variables de entorno requeridas:

- **Backend** (`backend/src/main/resources/application-dev.properties` / variables de Render):
  - `DB_URL`, `DB_USERNAME`, `DB_PASSWORD` (Postgres)
  - `JWT_SECRET` (clave HMAC para firmar tokens)
  - `JWT_ACCESS_TOKEN_EXPIRATION_MS`, `JWT_REFRESH_TOKEN_EXPIRATION_MS`
  - `CORS_ORIGINS` (lista separada por coma)
- **Frontend** (`frontend/.env`):
  - `VITE_API_BASE_URL` (p. ej. `http://localhost:8080` en desarrollo, URL de Render en producción)

### 5.2.3 Para producción

- **Frontend**: Render Static Site → conectado al repo, auto-deploy en cada push a `main`. Build command: `npm install && npm run build`. Publish directory: `frontend/dist`.
- **Backend**: Render Docker → conectado al `Dockerfile` del backend, auto-deploy en cada push. El plan Free duerme tras 15 min de inactividad y tarda ~30-60 s en el primer arranque (cold start); por eso el cliente Axios tiene `timeout: 60000`.
- **BBDD**: Supabase Session Pooler en `aws-0-eu-west-1.pooler.supabase.com:5432` con `sslmode=require`.

### 5.2.4 Para el usuario final

- **Navegador web moderno** con soporte ES2020+ (Chrome / Edge / Firefox / Safari / Brave, versiones de los últimos 2 años).
- **Conexión a Internet** (requerida en toda la experiencia web; la web no es PWA offline).
- **Resolución mínima recomendada**: 360 × 640 px (móvil) — diseño responsive verificado en escritorio, tablet y móvil.
- **JavaScript habilitado** y **cookies / localStorage** habilitados (la sesión se guarda en `localStorage`).

> El **cliente Android** (cuando se implemente) requerirá Android 8.0 (API 26) o superior. Como consumirá la misma API REST, los requisitos de servidor son los mismos.

---

## 5.3 — Modelado de datos (Diagrama de base de datos)

ZenFit utiliza **PostgreSQL 16** con un **esquema relacional normalizado**. A continuación se detallan todas las tablas reales del sistema agrupadas por dominio funcional, junto con sus campos, tipos y descripciones.

### 5.3.0 Convenciones generales

- **PK** = clave primaria. Todas las PK son `UUID` generadas con `gen_random_uuid()`.
- **FK** = clave foránea. Las FK a `users(id)` usan `ON DELETE CASCADE` para borrar todos los datos del usuario al eliminar su cuenta.
- **`created_at`** y **`updated_at`** son `TIMESTAMPTZ` automáticos (este último mantenido por un trigger `BEFORE UPDATE`).

### 5.3.1 Tipos enumerados (ENUM nativos de PostgreSQL)

| ENUM | Valores |
|------|---------|
| `user_role` | `USER`, `ADMIN` |
| `plan_type` | `FREE`, `PREMIUM` |
| `gender_type` | `MALE`, `FEMALE`, `OTHER`, `PREFER_NOT_TO_SAY` |
| `fitness_goal` | `LOSE_WEIGHT`, `GAIN_MUSCLE`, `IMPROVE_ENDURANCE`, `MAINTAIN`, `REDUCE_STRESS`, `BETTER_SLEEP`, `TONE_BODY`, `INCREASE_STRENGTH`, `INCREASE_FLEXIBILITY`, `IMPROVE_POSTURE`, `INCREASE_ENERGY`, `BUILD_HABITS` |
| `activity_level` | `SEDENTARY`, `LIGHT`, `MODERATE`, `ACTIVE`, `VERY_ACTIVE` |
| `difficulty_level` | `BEGINNER`, `INTERMEDIATE`, `ADVANCED` |
| `workout_type` | `STRENGTH`, `CARDIO`, `HIIT`, `YOGA`, `MOBILITY`, `STRETCHING`, `RECOVERY` |
| `meditation_type` | `GUIDED`, `BREATHING`, `MINDFULNESS`, `RELAXATION`, `SLEEP` |
| `mood_type` | `VERY_BAD`, `BAD`, `NEUTRAL`, `GOOD`, `VERY_GOOD` |
| `habit_frequency` | `DAILY`, `WEEKLY`, `CUSTOM` |
| `diet_goal` | `LOSE_WEIGHT`, `GAIN_MUSCLE`, `MAINTAIN`, `BALANCED`, `VEGETARIAN`, `VEGAN` |
| `meal_type` | `BREAKFAST`, `LUNCH`, `DINNER`, `SNACK` |
| `ai_reco_type` | `WORKOUT`, `MEDITATION`, `REST`, `HABIT`, `NUTRITION` |
| `notification_type` | `REMINDER`, `ACHIEVEMENT`, `RECOMMENDATION`, `SYSTEM`, `CHALLENGE` |

### 5.3.2 Dominio: Usuarios y autenticación

#### Tabla `users` — Cuentas de usuario

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `id` | UUID (PK) | Identificador único |
| `email` | VARCHAR(255) UNIQUE | Email de login (único) |
| `password_hash` | VARCHAR(255) | Contraseña hasheada con BCrypt |
| `full_name` | VARCHAR(150) | Nombre completo mostrado en la UI |
| `avatar_url` | VARCHAR(500) | URL de avatar (opcional) |
| `role` | user_role | `USER` por defecto, `ADMIN` para administradores |
| `plan` | plan_type | `FREE` o `PREMIUM` |
| `active` | BOOLEAN | Si la cuenta está activa (soft-delete opcional) |
| `email_verified` | BOOLEAN | Si el email ha sido verificado |
| `last_login_at` | TIMESTAMPTZ | Última vez que inició sesión |
| `created_at` / `updated_at` | TIMESTAMPTZ | Auditoría temporal |

#### Tabla `refresh_tokens` — Tokens de refresco JWT

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `id` | UUID (PK) | Identificador único |
| `user_id` | UUID (FK → users.id) | Usuario propietario |
| `token` | VARCHAR(500) UNIQUE | UUID aleatorio que actúa como refresh token |
| `expires_at` | TIMESTAMPTZ | Fecha de expiración |
| `revoked` | BOOLEAN | Marcado a `true` al rotarlo o cerrar sesión |
| `created_at` | TIMESTAMPTZ | Cuándo se generó |

#### Tabla `password_reset_tokens` — Tokens "olvidé mi contraseña"

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `id` | UUID (PK) | Identificador único |
| `user_id` | UUID (FK → users.id) | Usuario que solicita el reset |
| `token` | VARCHAR(120) UNIQUE | Token aleatorio Base64URL (48 bytes) |
| `expires_at` | TIMESTAMPTZ | TTL 30 minutos |
| `used` | BOOLEAN | Marcado a `true` al consumirlo |
| `created_at` | TIMESTAMPTZ | Cuándo se generó |

### 5.3.3 Dominio: Perfil de bienestar

#### Tabla `wellness_profiles` — 1:1 con `users`

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `user_id` | UUID (PK + FK → users.id) | Identificador y FK al usuario |
| `date_of_birth` | DATE | Fecha de nacimiento |
| `gender` | gender_type | Género |
| `height_cm` | NUMERIC(5,2) | Altura en centímetros (0 < x < 300) |
| `weight_kg` | NUMERIC(5,2) | Peso en kg (0 < x < 500) |
| `fitness_goal` | fitness_goal | Objetivo principal (12 valores) |
| `activity_level` | activity_level | Nivel de actividad diario |
| `medical_notes` | TEXT | Notas médicas/lesiones (opcional) |
| `preferences` | JSONB | Configuración libre clave-valor |
| `created_at` / `updated_at` | TIMESTAMPTZ | Auditoría |

### 5.3.4 Dominio: Fitness (ejercicios, rutinas y sesiones)

#### Tabla `exercises` — Catálogo global de ejercicios

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `id` | UUID (PK) | Identificador único |
| `name` | VARCHAR(150) | Nombre del ejercicio |
| `description` | TEXT | Descripción corta |
| `instructions` | TEXT | Pasos numerados (añadido en V9) |
| `tips` | TEXT | Tip de técnica (añadido en V9) |
| `video_url` | VARCHAR(500) | Enlace de búsqueda en YouTube |
| `image_url` | VARCHAR(500) | URL de imagen (opcional) |
| `difficulty` | difficulty_level | `BEGINNER` / `INTERMEDIATE` / `ADVANCED` |
| `estimated_seconds` | INTEGER | Duración aproximada por serie |
| `muscle_groups` | TEXT[] | Grupos musculares (array) |
| `equipment` | TEXT[] | Material necesario (array) |
| `is_premium` | BOOLEAN | Si requiere plan PREMIUM |
| `created_at` / `updated_at` | TIMESTAMPTZ | Auditoría |

> 87 ejercicios precargados (V2 + V8).

#### Tabla `workouts` — Rutinas predefinidas

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `id` | UUID (PK) | Identificador único |
| `name` | VARCHAR(150) | Nombre de la rutina |
| `description` | TEXT | Descripción |
| `type` | workout_type | Tipo (FUERZA, CARDIO, HIIT, YOGA, MOBILITY, STRETCHING, RECOVERY) |
| `difficulty` | difficulty_level | Dificultad |
| `estimated_duration_minutes` | INTEGER | Duración prevista |
| `image_url` | VARCHAR(500) | Imagen (opcional) |
| `is_premium` | BOOLEAN | Si requiere plan PREMIUM |
| `created_by` | UUID (FK → users.id) | NULL para rutinas del catálogo, autor para personalizadas |
| `created_at` / `updated_at` | TIMESTAMPTZ | Auditoría |

> ~100 rutinas precargadas tras V8 (~15 por tipo).

#### Tabla `workout_exercises` — Relación N:M con metadata

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `id` | UUID (PK) | Identificador único |
| `workout_id` | UUID (FK → workouts.id) | Rutina contenedora |
| `exercise_id` | UUID (FK → exercises.id) | Ejercicio asociado |
| `position` | INTEGER | Orden dentro de la rutina (UNIQUE con workout_id) |
| `sets` | INTEGER | Número de series |
| `reps` | INTEGER | Repeticiones por serie (NULL si es por duración) |
| `duration_seconds` | INTEGER | Segundos por serie (NULL si es por reps) |
| `rest_seconds` | INTEGER | Descanso entre series |
| `notes` | TEXT | Notas específicas (opcional) |

#### Tabla `workout_sessions` — Historial de entrenamientos del usuario

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `id` | UUID (PK) | Identificador único |
| `user_id` | UUID (FK → users.id) | Usuario que entrena |
| `workout_id` | UUID (FK → workouts.id) | Rutina realizada (NULL si fue libre) |
| `started_at` | TIMESTAMPTZ | Inicio de la sesión |
| `completed_at` | TIMESTAMPTZ | Fin (NULL si no terminó) |
| `duration_seconds` | INTEGER | Duración real medida por el cronómetro |
| `calories_burned` | INTEGER | Kcal estimadas |
| `perceived_effort` | SMALLINT (1-10) | Esfuerzo percibido (RPE) |
| `notes` | TEXT | Notas del usuario |
| `created_at` | TIMESTAMPTZ | Auditoría |

#### Tabla `workout_session_exercises` — Detalle por ejercicio de la sesión

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `id` | UUID (PK) | Identificador único |
| `session_id` | UUID (FK → workout_sessions.id) | Sesión contenedora |
| `exercise_id` | UUID (FK → exercises.id) | Ejercicio realizado |
| `position` | INTEGER | Orden |
| `sets_completed` | INTEGER | Series efectivamente completadas |
| `reps_completed` | INTEGER | Repeticiones reales |
| `weight_kg` | NUMERIC(6,2) | Peso utilizado (futuro) |
| `duration_seconds` | INTEGER | Duración medida |

### 5.3.5 Dominio: Nutrición (dietas)

#### Tabla `diet_plans` — Planes de dieta predefinidos

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `id` | UUID (PK) | Identificador único |
| `name` | VARCHAR(150) | Nombre del plan |
| `description` | TEXT | Descripción |
| `goal` | diet_goal | Objetivo nutricional |
| `calories_per_day` | INTEGER | Calorías estimadas |
| `image_url` | VARCHAR(500) | Imagen |
| `recipe_url` | VARCHAR(500) | Enlace a recetas / vídeos (V4) |
| `is_premium` | BOOLEAN | Si requiere PREMIUM |
| `created_at` / `updated_at` | TIMESTAMPTZ | Auditoría |

#### Tabla `diet_meals` — Comidas de cada plan

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `id` | UUID (PK) | Identificador único |
| `diet_plan_id` | UUID (FK → diet_plans.id) | Plan contenedor |
| `meal_type` | meal_type | Desayuno / comida / cena / snack |
| `name` | VARCHAR(200) | Nombre del plato |
| `description` | TEXT | Descripción del plato |
| `calories` | INTEGER | Kcal de la comida |
| `position` | INTEGER | Orden dentro del día |

#### Tabla `saved_diets` — Dietas favoritas del usuario (V4)

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `user_id` | UUID (PK + FK → users.id) | Usuario |
| `diet_plan_id` | UUID (PK + FK → diet_plans.id) | Plan guardado |
| `saved_at` | TIMESTAMPTZ | Cuándo se guardó |

#### Tabla `foods` — Catálogo de alimentos (V7)

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `id` | UUID (PK) | Identificador único |
| `name` | VARCHAR(150) | Nombre del alimento |
| `category` | VARCHAR(60) | Categoría (proteínas, carbohidratos…) |
| `kcal_per_100g` | NUMERIC(6,2) | Calorías por 100 g |
| `protein_per_100g` | NUMERIC(6,2) | Proteínas por 100 g |
| `carbs_per_100g` | NUMERIC(6,2) | Hidratos por 100 g |
| `fat_per_100g` | NUMERIC(6,2) | Grasas por 100 g |
| `created_at` | TIMESTAMPTZ | Auditoría |

> 56 alimentos comunes precargados.

#### Tabla `custom_diets` — Dietas creadas por el usuario (V7)

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `id` | UUID (PK) | Identificador único |
| `user_id` | UUID (FK → users.id) | Autor |
| `name` | VARCHAR(120) | Nombre |
| `description` | TEXT | Descripción libre |
| `total_kcal` | NUMERIC(8,2) | Suma calculada de los items |
| `created_at` / `updated_at` | TIMESTAMPTZ | Auditoría |

#### Tabla `custom_diet_items` — Items de cada dieta personalizada (V7)

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `id` | UUID (PK) | Identificador único |
| `custom_diet_id` | UUID (FK → custom_diets.id) | Dieta contenedora |
| `food_id` | UUID (FK → foods.id) | Alimento del catálogo (opcional) |
| `food_name_freetext` | VARCHAR(150) | Nombre libre si no está en catálogo |
| `grams` | NUMERIC(7,2) | Cantidad en gramos |
| `kcal` | NUMERIC(7,2) | Kcal calculadas (= grams × kcal_per_100g / 100) |
| `position` | INTEGER | Orden visual |

### 5.3.6 Dominio: Sueño

#### Tabla `sleep_logs` — Registros de sueño

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `id` | UUID (PK) | Identificador único |
| `user_id` | UUID (FK → users.id) | Usuario |
| `sleep_date` | DATE | Día del registro (UNIQUE con user_id) |
| `bedtime` | TIMESTAMPTZ | Hora de acostarse |
| `wake_time` | TIMESTAMPTZ | Hora de despertar |
| `duration_minutes` | INTEGER | Minutos dormidos |
| `quality` | SMALLINT (1-5) | Calidad subjetiva |
| `notes` | TEXT | Notas |
| `created_at` | TIMESTAMPTZ | Auditoría |

### 5.3.7 Dominio: Hábitos

#### Tabla `habits` — Hábitos del usuario

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `id` | UUID (PK) | Identificador único |
| `user_id` | UUID (FK → users.id) | Usuario |
| `name` | VARCHAR(150) | Nombre del hábito |
| `description` | TEXT | Descripción |
| `frequency` | habit_frequency | DAILY / WEEKLY / CUSTOM |
| `target_per_period` | INTEGER | Objetivo por periodo |
| `color` | VARCHAR(20) | Color para la UI |
| `icon` | VARCHAR(50) | Emoji/icono |
| `active` | BOOLEAN | Activo o pausado |
| `created_at` / `updated_at` | TIMESTAMPTZ | Auditoría |

#### Tabla `habit_logs` — Marcaciones diarias

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `id` | UUID (PK) | Identificador único |
| `habit_id` | UUID (FK → habits.id) | Hábito asociado |
| `log_date` | DATE | Día (UNIQUE con habit_id) |
| `completed` | BOOLEAN | Si se completó ese día |
| `notes` | TEXT | Notas |
| `created_at` | TIMESTAMPTZ | Auditoría |

### 5.3.8 Dominio: Meditación y bienestar mental

#### Tabla `meditations` — Catálogo de meditaciones

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `id` | UUID (PK) | Identificador único |
| `title` | VARCHAR(150) | Título |
| `description` | TEXT | Descripción |
| `type` | meditation_type | Tipo |
| `duration_minutes` | INTEGER | Duración |
| `audio_url` | VARCHAR(500) | Audio guiado |
| `image_url` | VARCHAR(500) | Imagen |
| `is_premium` | BOOLEAN | Si requiere PREMIUM |
| `created_at` / `updated_at` | TIMESTAMPTZ | Auditoría |

#### Tabla `meditation_sessions` — Sesiones realizadas

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `id` | UUID (PK) | Identificador único |
| `user_id` | UUID (FK → users.id) | Usuario |
| `meditation_id` | UUID (FK → meditations.id) | Meditación (NULL si fue libre) |
| `started_at` / `completed_at` | TIMESTAMPTZ | Inicio y fin |
| `duration_seconds` | INTEGER | Duración medida |
| `mood_before` / `mood_after` | mood_type | Estado de ánimo |
| `notes` | TEXT | Notas |
| `created_at` | TIMESTAMPTZ | Auditoría |

### 5.3.9 Dominio: IA y recomendaciones

#### Tabla `ai_user_config`

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `user_id` | UUID (PK + FK → users.id) | Usuario |
| `preferences` | JSONB | Configuración libre |
| `last_run_at` | TIMESTAMPTZ | Última vez que se generaron recomendaciones |
| `created_at` / `updated_at` | TIMESTAMPTZ | Auditoría |

#### Tabla `ai_recommendations`

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `id` | UUID (PK) | Identificador único |
| `user_id` | UUID (FK → users.id) | Destinatario |
| `type` | ai_reco_type | Tipo de recomendación |
| `title` | VARCHAR(200) | Título |
| `body` | TEXT | Cuerpo |
| `payload` | JSONB | Datos adicionales |
| `generated_at` | TIMESTAMPTZ | Generada |
| `viewed_at` | TIMESTAMPTZ | Vista por el usuario |
| `acted_upon` | BOOLEAN | Si actuó sobre ella |

### 5.3.10 Dominio: Notificaciones

#### Tabla `notifications`

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `id` | UUID (PK) | Identificador único |
| `user_id` | UUID (FK → users.id) | Destinatario |
| `type` | notification_type | Tipo |
| `title` | VARCHAR(200) | Título |
| `body` | TEXT | Cuerpo |
| `data` | JSONB | Carga útil libre |
| `read` | BOOLEAN | Leída o no |
| `created_at` / `read_at` | TIMESTAMPTZ | Creación y lectura |

### 5.3.11 Dominio: Gamificación (logros, retos y estadísticas)

#### Tabla `achievements` — Catálogo de logros

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `id` | UUID (PK) | Identificador único |
| `code` | VARCHAR(50) UNIQUE | Código identificador (ej. `FIRST_WORKOUT`) |
| `name` | VARCHAR(150) | Nombre |
| `description` | TEXT | Descripción |
| `icon` | VARCHAR(100) | Emoji/icono |
| `points` | INTEGER | Puntos otorgados |
| `criteria` | JSONB | Criterios para desbloquearlo |
| `created_at` | TIMESTAMPTZ | Auditoría |

#### Tabla `user_achievements` — Logros desbloqueados (N:M)

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `user_id` | UUID (PK + FK → users.id) | Usuario |
| `achievement_id` | UUID (PK + FK → achievements.id) | Logro |
| `unlocked_at` | TIMESTAMPTZ | Fecha de desbloqueo |

#### Tabla `challenges` — Retos disponibles

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `id` | UUID (PK) | Identificador único |
| `name` | VARCHAR(150) | Nombre del reto |
| `description` | TEXT | Descripción |
| `start_date` / `end_date` | DATE | Vigencia |
| `target_type` | VARCHAR(50) | Tipo de objetivo |
| `target_value` | INTEGER | Valor objetivo |
| `points` | INTEGER | Puntos por completarlo |
| `is_active` | BOOLEAN | Activo o no |
| `created_at` | TIMESTAMPTZ | Auditoría |

#### Tabla `user_challenges` — Inscripción y progreso (N:M)

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `user_id` | UUID (PK + FK → users.id) | Usuario |
| `challenge_id` | UUID (PK + FK → challenges.id) | Reto |
| `progress` | INTEGER | Progreso actual |
| `completed` | BOOLEAN | Completado |
| `completed_at` | TIMESTAMPTZ | Cuándo se completó |
| `joined_at` | TIMESTAMPTZ | Cuándo se apuntó |

#### Tabla `user_stats` — Estadísticas agregadas

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `user_id` | UUID (PK + FK → users.id) | Usuario |
| `total_points` | INTEGER | Puntos acumulados |
| `current_streak_days` | INTEGER | Racha actual |
| `longest_streak_days` | INTEGER | Récord de racha |
| `total_workouts` | INTEGER | Sesiones de entrenamiento |
| `total_meditations` | INTEGER | Sesiones de meditación |
| `total_minutes_active` | INTEGER | Minutos activos totales |
| `last_activity_date` | DATE | Última actividad |
| `updated_at` | TIMESTAMPTZ | Auditoría |

### 5.3.12 Diagrama de relaciones (resumen)

```
                  ┌────────────────┐
                  │     users      │ (1)
                  └───────┬────────┘
                          │
       ┌──────────────────┼─────────────────────────────────────────┐
       │                  │                                          │
       │ (1)              │ (1:N)                                    │ (1:1)
       ▼                  ▼                                          ▼
┌──────────────┐  ┌─────────────────┐                       ┌─────────────────┐
│ refresh_     │  │ workout_sessions│                       │wellness_profiles│
│ tokens       │  └────────┬────────┘                       └─────────────────┘
│ password_    │           │
│ reset_tokens │           │ (1:N)
└──────────────┘           ▼
                  ┌──────────────────────────┐
                  │workout_session_exercises │
                  └──────────────────────────┘
                          │
                          │ FK
                          ▼
┌─────────────────┐  ┌──────────────────┐  ┌──────────────────┐
│   workouts      │──│ workout_exercises│──│   exercises      │
│  (N:1 a users)  │  │      (N:M)        │  │   (catálogo)     │
└─────────────────┘  └──────────────────┘  └──────────────────┘

users ── 1:N ── habits ── 1:N ── habit_logs
users ── 1:N ── sleep_logs
users ── N:M ── diet_plans (vía saved_diets)
users ── 1:N ── custom_diets ── 1:N ── custom_diet_items ── N:1 ── foods
users ── 1:N ── meditation_sessions ── N:1 ── meditations
users ── 1:N ── notifications, ai_recommendations
users ── N:M ── achievements (vía user_achievements)
users ── N:M ── challenges    (vía user_challenges)
users ── 1:1 ── user_stats, ai_user_config
```

### 5.3.13 Historial de migraciones (Flyway)

| Versión | Descripción | Cambios principales |
|---------|-------------|---------------------|
| **V1** | initial_schema | Esquema base completo: 21 tablas + 11 enums + función `set_updated_at` + triggers |
| **V2** | seed_catalog | Datos semilla: 12 ejercicios + 5 rutinas + 5 meditaciones + 5 logros |
| **V3** | diets | Nuevas tablas `diet_plans` y `diet_meals` + enums `diet_goal` y `meal_type` + 5 planes de dieta |
| **V4** | diets_extra | Tabla `saved_diets`, columna `recipe_url` en `diet_plans`, 15 dietas adicionales |
| **V5** | more_fitness_goals | 6 nuevos valores al enum `fitness_goal` |
| **V6** | password_reset_tokens | Tabla `password_reset_tokens` para el flujo "olvidé mi contraseña" |
| **V7** | foods_and_custom_diets | Tablas `foods`, `custom_diets`, `custom_diet_items` + seed de 56 alimentos |
| **V8** | more_workouts_catalog | 65 ejercicios nuevos + ~100 rutinas adicionales (~15 por tipo) |
| **V9** | exercise_guides | Columnas `instructions` y `tips` en `exercises` + guía paso a paso para los 87 ejercicios |

---

## Stack tecnológico completo (referencia rápida)

### Backend
- **Lenguaje**: Java 21
- **Framework**: Spring Boot 3.3.5
- **Build**: Maven Wrapper (`mvnw`)
- **ORM**: Hibernate 6 (Spring Data JPA)
- **Seguridad**: Spring Security + JWT (`io.jsonwebtoken:jjwt 0.12.6`) + BCrypt
- **Migraciones BBDD**: Flyway 10
- **Validación**: Jakarta Bean Validation
- **Documentación API**: SpringDoc OpenAPI (`/v3/api-docs`, `/swagger-ui`)
- **Boilerplate**: Lombok 1.18.38, MapStruct 1.6.3
- **DevTools**: Spring Boot DevTools (autoreload en local)
- **Logs**: SLF4J + Logback (configuración estándar)

### Frontend web
- **Framework**: Vue 3 (Composition API + `<script setup>`)
- **Build tool**: Vite 7
- **Router**: Vue Router 4
- **HTTP**: Axios
- **Estado global**: Composables propios (`useAuth`, `useTheme`) en módulos singleton
- **Estilos**: CSS puro con variables (sin Tailwind ni preprocesador)
- **Tipografías**: Bebas Neue (display) + DM Sans (body) vía Google Fonts
- **Export de datos**: `xlsx` (SheetJS), `jspdf`, `jspdf-autotable` — todas con dynamic imports

### Base de datos
- **Motor**: PostgreSQL 16
- **Local**: Docker (`postgres:16-alpine` en puerto 15432)
- **Producción**: Supabase (Session Pooler IPv4, puerto 5432, SSL)
- **Tooling**: pgAdmin 4 vía Docker Compose

### Despliegue
- **Frontend**: Render Static Site (auto-deploy desde GitHub)
- **Backend**: Render Docker (auto-deploy desde GitHub, Dockerfile personalizado)
- **BBDD**: Supabase Free
- **Repositorio**: GitHub (`samaulo75-hash/Zenfit-Claude`)

### Herramientas de desarrollo
- **Control de versiones**: Git + GitHub
- **CI/CD**: Render auto-deploy on push to `main`
- **Editores**: IntelliJ IDEA (backend), VS Code (frontend)

---

## Funcionalidades implementadas (resumen)

| Módulo | Features |
|--------|----------|
| **Autenticación** | Registro, login, JWT + refresh tokens con rotación, "olvidé mi contraseña" (sin SMTP, token visible en UI demo), cambio de contraseña, eliminar cuenta |
| **Perfil de bienestar** | Datos físicos, 12 objetivos fitness, nivel de actividad, notas médicas |
| **Hábitos** | CRUD, marcado diario, rachas, frecuencias configurables |
| **Sueño** | Registro diario + **calculadora de ciclos de 90 min** que sugiere 3 mejores horas |
| **Fitness** | 87 ejercicios con guía paso a paso, ~100 rutinas en 7 categorías, **cronómetro guiado fullscreen** con countdown automático, descansos, pausa, audio cues |
| **Dietas** | 20 planes predefinidos, marcar favoritos, **dietas personalizadas** con catálogo de 56 alimentos y **cálculo automático de calorías** |
| **Dashboard** | Resumen agregado |
| **Ajustes** | Editar nombre, cambiar contraseña, tema claro/oscuro, preferencias de UI, **exportar datos (JSON / Excel / PDF)**, eliminar cuenta, cerrar sesión |
| **Blog público** | Artículos sobre uso de la app |
| **Landing pública** | Hero, beneficios, FAQ, CTAs |

---

*Documento generado automáticamente a partir del código fuente real del proyecto en commit `f4deac4`. Refleja el estado del sistema tal como está desplegado en producción y disponible en el repositorio.*
