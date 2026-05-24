# ZenFit · Cómo se conecta la base de datos con el backend

> Explicación técnica de cómo el backend (Spring Boot) se conecta a la base de datos (PostgreSQL en Supabase) y cómo el esquema se crea automáticamente con migraciones.

---

## 🏗️ Visión general

```
┌──────────────────────────┐    JDBC + SSL (puerto 5432)    ┌─────────────────────────┐
│  Backend Spring Boot     │ ─────────────────────────────► │  PostgreSQL 16          │
│  (Render Docker)         │                                 │  Supabase Session Pooler│
│  • HikariCP pool de 5    │ ◄───────────────────────────── │  • IPv4 obligatorio     │
│  • Hibernate 6 (JPA)     │   ResultSets / metadata         │  • SSL obligatorio      │
│  • Flyway 10             │                                 │  • 28 tablas            │
└──────────────────────────┘                                 └─────────────────────────┘
                ▲
                │ Variables de entorno (Render)
                │
        DB_URL · DB_USERNAME · DB_PASSWORD
```

**Resumen en una línea**: el backend tiene un *connection pool* (HikariCP) que abre y mantiene unas pocas conexiones JDBC contra el servidor PostgreSQL hospedado en Supabase. Las credenciales se inyectan como variables de entorno desde el panel de Render.

---

## 🧩 Piezas que hacen posible la conexión

### 1. Driver JDBC de PostgreSQL

En `backend/pom.xml`:

```xml
<dependency>
    <groupId>org.postgresql</groupId>
    <artifactId>postgresql</artifactId>
    <scope>runtime</scope>
</dependency>
```

Es la librería de Java que sabe "hablar" con PostgreSQL por TCP. Sin ella, Spring no podría abrir el socket a Supabase.

### 2. Configuración del datasource

En `backend/src/main/resources/application-prod.yml` (perfil de producción):

```yaml
spring:
  datasource:
    url: ${DB_URL}                              # jdbc:postgresql://...supabase...:5432/postgres?sslmode=require
    username: ${DB_USERNAME}                    # postgres.<project-ref>
    password: ${DB_PASSWORD}                    # contraseña de Supabase
    driver-class-name: org.postgresql.Driver
    hikari:
      maximum-pool-size: 5                      # máximo 5 conexiones abiertas a la vez
      minimum-idle: 1                           # mantiene siempre 1 conexión "caliente"
      connection-timeout: 30000                 # 30s para abrir conexión (cold start de Supabase)
```

Spring Boot detecta automáticamente esta configuración y crea un **HikariCP** (el pool de conexiones más rápido de Java). HikariCP mantiene N conexiones abiertas para que cada petición HTTP no tenga que volver a hacer el handshake TCP + TLS (que es lento).

En desarrollo local se usa `application.yml` que apunta a `localhost:15432` (Postgres en Docker).

### 3. Variables de entorno (las credenciales reales)

El YAML usa `${DB_URL}` etc. como **placeholders**. Los valores reales viven en el dashboard de Render (Environment Variables):

| Variable | Formato | Ejemplo |
|----------|---------|---------|
| `DB_URL` | URL JDBC completa | `jdbc:postgresql://aws-0-eu-west-1.pooler.supabase.com:5432/postgres?sslmode=require` |
| `DB_USERNAME` | `postgres.<project-ref>` | `postgres.abcdefghijklmnop` |
| `DB_PASSWORD` | string aleatorio | *(se ve solo al crearlo en Supabase)* |

> ⚠️ **Importante: NUNCA estas variables están en el repo de Git**. El archivo `application-prod.yml` solo tiene placeholders, jamás valores reales.

#### ¿Por qué Session Pooler y no la URL directa de Supabase?

Supabase ofrece 3 modos de conexión:

| Modo | Puerto | IP | Uso |
|------|--------|----|----|
| Direct | 5432 | **IPv6** | Solo si tu servidor tiene IPv6 |
| Session Pooler | 5432 | **IPv4** | ✅ El que usamos |
| Transaction Pooler | 6543 | IPv4 | Para apps serverless con muchas conexiones cortas |

Render Free Tier solo da **IPv4 saliente**, por eso usamos el **Session Pooler**. La URL `db.<ref>.supabase.co:5432` no funcionaría.

### 4. Flyway: el esquema se crea solo

En `backend/src/main/resources/application-prod.yml`:

```yaml
spring:
  flyway:
    enabled: true
    locations: classpath:db/migration
    baseline-on-migrate: true
```

Flyway lee los archivos SQL versionados en `backend/src/main/resources/db/migration/` y los aplica en orden:

```
V1__initial_schema.sql           ← 21 tablas + 11 enums + función set_updated_at
V2__seed_catalog.sql              ← 12 ejercicios, 5 rutinas, 5 meditaciones iniciales
V3__diets.sql                     ← Tablas diet_plans y diet_meals
V4__diets_extra.sql               ← saved_diets + 15 dietas más
V5__more_fitness_goals.sql        ← 6 valores nuevos al enum fitness_goal
V6__password_reset_tokens.sql     ← Tokens para "olvidé mi contraseña"
V7__foods_and_custom_diets.sql    ← Catálogo de alimentos + dietas personalizadas
V8__more_workouts_catalog.sql     ← 65 ejercicios más + ~100 rutinas extra
V9__exercise_guides.sql           ← Pasos paso a paso + tips por ejercicio
```

Cuando el backend arranca:

1. Spring Boot abre la conexión a Supabase
2. **Flyway** consulta su tabla interna `flyway_schema_history` para ver qué versiones ya están aplicadas
3. Ejecuta las migraciones que falten **en orden**
4. Si alguna migración falla, **el backend NO arranca** (failsafe)
5. Si todo va bien, registra cada versión aplicada en `flyway_schema_history`

Esto significa que cualquier persona que clone el repo y arranque el backend tendrá **automáticamente** el esquema correcto. Sin scripts manuales, sin pasos olvidados.

### 5. Hibernate (JPA): mapea las clases Java a tablas SQL

Cada clase con `@Entity` representa una tabla:

```java
// backend/src/main/java/com/zenfit/user/User.java
@Entity
@Table(name = "users")              // ← nombre de la tabla en BBDD
public class User {

    @Id
    @Column(name = "id", columnDefinition = "uuid")
    private UUID id;

    @Column(name = "email", nullable = false, unique = true, length = 255)
    private String email;

    @Column(name = "password_hash", nullable = false, length = 255)
    private String passwordHash;

    @Column(name = "full_name", nullable = false, length = 150)
    private String fullName;

    @Enumerated(EnumType.STRING)
    @JdbcTypeCode(SqlTypes.NAMED_ENUM)
    @Column(name = "role", nullable = false, columnDefinition = "user_role")
    private UserRole role;

    // ... el resto de campos
}
```

Cuando un service llama `userRepository.findByEmail("hola@ejemplo.com")`, Hibernate **genera dinámicamente** este SQL:

```sql
SELECT u.id, u.email, u.password_hash, u.full_name, u.role, ...
FROM users u
WHERE u.email = ?;
```

…lo envía por la conexión HikariCP a Supabase, recibe el `ResultSet`, y reconstruye un objeto Java `User`.

### 6. `ddl-auto: validate` (modo seguro)

```yaml
spring:
  jpa:
    hibernate:
      ddl-auto: validate
```

Al arrancar, Hibernate **compara las tablas reales** con las anotaciones `@Entity`. Si no coinciden (por ejemplo, falta una columna o el tipo es distinto), **el backend falla al arrancar** con un error claro.

| Valor | Comportamiento | Cuándo usar |
|-------|----------------|-------------|
| `validate` | Solo comprueba que coincidan | ✅ Producción y dev (lo que usamos) |
| `update` | Modifica la BBDD para encajar con las @Entity | ⚠️ Peligroso, descontrolado |
| `create` | Borra y recrea todo cada arranque | ⚠️ Solo tests aislados |
| `none` | No hace nada | OK si confías 100% en Flyway |

Combinado con Flyway, este enfoque es **muy seguro**: Flyway controla los cambios estructurales (siempre versionados en SQL), y Hibernate solo valida que el código encaja con esa estructura.

### 7. Spring Data Repositories (queries casi sin escribir SQL)

Los repositorios extienden `JpaRepository<Entity, ID>` y Spring genera la implementación:

```java
public interface UserRepository extends JpaRepository<User, UUID> {

    Optional<User> findByEmail(String email);          // ← Spring genera el SQL automáticamente
    boolean existsByEmail(String email);                // ← Idem
}
```

Para queries más complejas se usa `@Query`:

```java
@Query("UPDATE RefreshToken rt SET rt.revoked = true WHERE rt.user = :user AND rt.revoked = false")
int revokeAllForUser(@Param("user") User user);
```

---

## 🚀 Flujo completo al arrancar el backend

```
1. Render levanta el contenedor Docker del backend
2. Inyecta las variables de entorno DB_URL, DB_USERNAME, DB_PASSWORD, JWT_SECRET...
3. Spring Boot lee application.yml + application-prod.yml (perfil prod)
4. Sustituye los placeholders ${...} por las variables de entorno reales
5. HikariCP abre 1 conexión inicial a Supabase:
   ─► TCP handshake
   ─► TLS handshake (porque sslmode=require)
   ─► Autenticación con usuario+password
   ─► Esto puede tardar 1-3 segundos
6. Flyway se ejecuta:
   ─► SELECT version FROM flyway_schema_history
   ─► Aplica las migraciones nuevas en orden (si las hay)
   ─► Registra cada versión aplicada
7. Hibernate valida que las @Entity coinciden con las tablas reales
   ─► Si NO coinciden: ERROR, el backend no arranca
8. Spring Security se inicializa (filtros JWT, etc.)
9. Tomcat empieza a escuchar en :8080
10. Cada request HTTP:
    ─► Un Service pide una conexión a HikariCP (instantáneo, ya está caliente)
    ─► Ejecuta la query a Supabase
    ─► Devuelve la conexión al pool (no la cierra)
```

En logs típicos verás:

```
INFO  ZenfitApplication : The following 1 profile is active: "prod"
INFO  HikariDataSource  : HikariPool-1 - Starting...
INFO  HikariDataSource  : HikariPool-1 - Added connection org.postgresql.jdbc.PgConnection@xxx
INFO  HikariDataSource  : HikariPool-1 - Start completed.
INFO  Flyway            : Database: jdbc:postgresql://...supabase... (PostgreSQL 15.x)
INFO  Flyway            : Successfully validated 9 migrations (execution time 00:00.150s)
INFO  Flyway            : Current version of schema "public": 9
INFO  TomcatWebServer   : Tomcat started on port 8080 (http)
INFO  ZenfitApplication : Started ZenfitApplication in 5.234 seconds (process running for 6.012)
```

---

## 🧪 Cómo conectar tu backend LOCAL a la Supabase de producción

Para desarrollar tocando datos reales (úsalo con cuidado, son datos en producción):

### Windows PowerShell

```powershell
cd backend
$env:SPRING_PROFILES_ACTIVE = 'prod'
$env:DB_URL = 'jdbc:postgresql://aws-0-eu-west-1.pooler.supabase.com:5432/postgres?sslmode=require'
$env:DB_USERNAME = 'postgres.<tu-project-ref>'
$env:DB_PASSWORD = '<tu-password-de-supabase>'
$env:JWT_SECRET = 'cualquier-string-largo-aleatorio-de-al-menos-32-caracteres'
$env:CORS_ALLOWED_ORIGINS = 'http://localhost:5173'

.\mvnw.cmd -DskipTests spring-boot:run
```

### Linux / Mac

```bash
cd backend
export SPRING_PROFILES_ACTIVE=prod
export DB_URL='jdbc:postgresql://aws-0-eu-west-1.pooler.supabase.com:5432/postgres?sslmode=require'
export DB_USERNAME='postgres.<tu-project-ref>'
export DB_PASSWORD='<tu-password-de-supabase>'
export JWT_SECRET='cualquier-string-largo-aleatorio-de-al-menos-32-caracteres'
export CORS_ALLOWED_ORIGINS='http://localhost:5173'

./mvnw -DskipTests spring-boot:run
```

> 🔑 **Si no tienes las credenciales de Supabase**: las puedes ver/recuperar en https://dashboard.render.com → servicio `zenfit-backend-ofv0` → Environment. O en el dashboard de Supabase resetear la contraseña.

---

## 🧪 Cómo conectar tu backend LOCAL a una BBDD LOCAL (con Docker)

Para desarrollar sin tocar la BBDD de producción (recomendado):

```bash
# 1. Levanta PostgreSQL local con Docker
docker compose up -d
# Postgres queda en localhost:15432
# pgAdmin queda en http://localhost:5050 (admin@zenfit.dev / admin)

# 2. Arranca el backend con perfil dev (el que viene por defecto)
cd backend
./mvnw -DskipTests spring-boot:run
```

El perfil `dev` ya está configurado en `application.yml` apuntando a `localhost:15432` con las credenciales del `docker-compose.yml` (`zenfit` / `zenfit_dev_password`). Flyway aplicará las 9 migraciones automáticamente.

---

## 📋 Resumen de responsabilidades por capa

| Capa | Tecnología | Responsabilidad |
|------|-----------|-----------------|
| **Network** | TCP + TLS | Transporte seguro entre backend y BBDD |
| **Driver** | `org.postgresql:postgresql` | Hablar el protocolo PostgreSQL desde Java |
| **Connection pool** | HikariCP | Mantener N conexiones reutilizables (5 max) |
| **Schema versioning** | Flyway 10 | Crear/actualizar tablas con SQL versionado |
| **ORM** | Hibernate 6 | Mapear clases Java ↔ filas SQL |
| **Repositorio** | Spring Data JPA | Generar queries automáticas (`findBy...`) |
| **Service** | Spring `@Service` | Lógica de negocio, transacciones (`@Transactional`) |
| **Controller** | Spring `@RestController` | Recibir HTTP, devolver JSON |
| **Secrets** | Variables de entorno (Render) | Credenciales fuera del código |

---

## ❓ Preguntas frecuentes

### ¿Por qué tarda 30-60s la primera vez?

El plan **Free de Render** duerme el contenedor tras 15 min sin tráfico. Al despertar tiene que:
1. Arrancar Java
2. Cargar Spring (3-5s)
3. Abrir conexión a Supabase (que también puede estar "fría")
4. Ejecutar Flyway (validar las 9 versiones ~150ms)
5. Validar Hibernate

Total: **30-60 segundos**. El frontend muestra un banner "Conectando con el servidor…" durante este tiempo.

### ¿Cómo añado una nueva tabla?

1. Crea un archivo `V10__lo_que_sea.sql` en `backend/src/main/resources/db/migration/`
2. Escribe el `CREATE TABLE ...` dentro
3. Crea la clase `@Entity` correspondiente en Java
4. Crea el `Repository` extendiendo `JpaRepository<TuEntity, UUID>`
5. Haz commit + push → Render redeploya y Flyway aplica la migración

> ⚠️ **NUNCA** modifiques una migración ya aplicada. Crea siempre una nueva con número mayor.

### ¿Y si quiero ver los datos directamente?

- **Local**: abre pgAdmin en http://localhost:5050 (admin@zenfit.dev / admin)
- **Producción**: abre el dashboard de Supabase → **Table Editor** o **SQL Editor**

### ¿El backend tiene caché?

No tenemos Redis/Memcached. Solo el pool de conexiones de HikariCP. Cada request consulta la BBDD directamente. Para una app de este volumen es más que suficiente.

### ¿Cómo se mantiene seguridad entre frontend y backend?

- **CORS**: el backend solo acepta peticiones desde orígenes registrados (`http://localhost:5173` y `https://zenfit-frontend.onrender.com`).
- **JWT**: cada petición autenticada debe incluir `Authorization: Bearer <accessToken>`. El backend valida la firma con `JWT_SECRET`.
- **HTTPS**: todo el tráfico en producción va por TLS (Render lo gestiona automáticamente con Let's Encrypt).
- **BCrypt**: las contraseñas se guardan hasheadas con BCrypt, nunca en texto plano.

---

## 📞 Contacto

Repositorio: https://github.com/samaulo75-hash/Zenfit-Claude

Cualquier duda sobre cómo añadir entidades, migraciones o cómo funciona algo, contactad con **Samuel López**.
