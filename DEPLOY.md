# 🚀 Despliegue de ZenFit (Supabase + Render)

Guía paso a paso para poner ZenFit en producción **gratis**:

- **Base de datos** → Supabase (PostgreSQL gestionado)
- **Backend** → Render (Web Service con Docker)
- **Frontend** → Render (Static Site)

> Orden recomendado: **Supabase → Backend → Frontend → ajustar CORS**.
> Hazlo en ese orden porque cada paso necesita datos del anterior.

---

## 1️⃣ Base de datos en Supabase

1. Entra en <https://supabase.com> → **Start your project** → regístrate (puedes usar GitHub).
2. **New project**:
   - **Name**: `zenfit`
   - **Database Password**: genera una y **GUÁRDALA** (la necesitarás). Evita caracteres raros como `@ : / #` para no complicar la URL.
   - **Region**: elige la más cercana (p. ej. `West EU (Ireland)`).
   - Crea el proyecto y espera ~2 min a que aprovisione.
3. Ve a **Project Settings** (engranaje) → **Database** → sección **Connection string** → pestaña **Session pooler** (NO uses "Transaction pooler", da problemas con migraciones).
4. Apunta estos datos del bloque que aparece:
   - **Host**: algo como `aws-0-eu-west-1.pooler.supabase.com`
   - **Port**: `5432`
   - **Database**: `postgres`
   - **User**: algo como `postgres.abcdwxyzproject` (¡incluye el punto y el ref!)
   - **Password**: la que generaste en el paso 2

Con eso construye la **URL JDBC** (la usarás en Render):

```
jdbc:postgresql://<HOST>:5432/postgres?sslmode=require
```

Ejemplo real:
```
jdbc:postgresql://aws-0-eu-west-1.pooler.supabase.com:5432/postgres?sslmode=require
```

> No tienes que crear tablas a mano: **Flyway las creará solas** la primera vez que arranque el backend (las 21 tablas + el catálogo de ejercicios).

---

## 2️⃣ Backend en Render

1. Entra en <https://render.com> → regístrate con **GitHub** y autoriza el acceso al repo `samaulo75-hash/Zenfit-Claude`.
2. **New +** → **Web Service** → conecta el repositorio `Zenfit-Claude`.
3. Configura:
   | Campo | Valor |
   |---|---|
   | **Name** | `zenfit-backend` |
   | **Region** | la misma zona que Supabase si puedes |
   | **Branch** | `main` |
   | **Root Directory** | `backend` |
   | **Runtime** | `Docker` |
   | **Instance Type** | `Free` |
4. En **Environment Variables** añade (botón *Add Environment Variable*):

   | Key | Value |
   |---|---|
   | `SPRING_PROFILES_ACTIVE` | `prod` |
   | `DB_URL` | la URL JDBC del paso 1 (`jdbc:postgresql://...?sslmode=require`) |
   | `DB_USERNAME` | el user de Supabase (`postgres.<ref>`) |
   | `DB_PASSWORD` | la contraseña de Supabase |
   | `JWT_SECRET` | una cadena larga y aleatoria (mín. 40 caracteres) |
   | `CORS_ALLOWED_ORIGINS` | déjalo en `*` temporalmente (lo afinamos en el paso 4) |

5. **Create Web Service**. Render construirá la imagen Docker (tarda ~5-8 min la primera vez).
6. Cuando termine verás algo como `https://zenfit-backend.onrender.com`. **Apunta esa URL.**
7. Comprueba que vive: abre `https://zenfit-backend.onrender.com/swagger-ui.html` → debe cargar la documentación de la API.

> ⚠️ **Free tier**: el backend se "duerme" tras 15 min sin tráfico. La primera petición después tarda 30-60 s en despertar. Es normal.

---

## 3️⃣ Frontend en Render

1. En Render: **New +** → **Static Site** → mismo repositorio `Zenfit-Claude`.
2. Configura:
   | Campo | Valor |
   |---|---|
   | **Name** | `zenfit-frontend` |
   | **Branch** | `main` |
   | **Root Directory** | `frontend` |
   | **Build Command** | `npm ci && npm run build` |
   | **Publish Directory** | `dist` |
3. **Environment Variables**:
   | Key | Value |
   |---|---|
   | `VITE_API_BASE_URL` | la URL del backend del paso 2 (`https://zenfit-backend.onrender.com`) |
4. **Create Static Site**. Cuando termine tendrás algo como `https://zenfit-frontend.onrender.com`. **Apunta esa URL.**
5. **Routing SPA (importante)**: ve a la pestaña **Redirects/Rewrites** del static site y añade una regla:
   - **Source**: `/*`
   - **Destination**: `/index.html`
   - **Action**: `Rewrite`

   (Sin esto, recargar en `/dashboard` o `/blog/...` daría 404.)

---

## 4️⃣ Ajustar CORS (cerrar el círculo)

Ahora que conoces la URL real del frontend:

1. Vuelve al **backend** en Render → **Environment** → edita `CORS_ALLOWED_ORIGINS`:
   ```
   https://zenfit-frontend.onrender.com
   ```
   (sin barra final; si quieres varios orígenes, sepáralos por comas)
2. Guarda → Render redesplegará el backend automáticamente (~3-5 min).

---

## ✅ Verificación final

1. Abre `https://zenfit-frontend.onrender.com`
2. La primera carga puede tardar (backend despertando). Regístrate.
3. Completa perfil, crea un hábito, registra sueño, completa un workout.
4. En Supabase → **Table Editor** verás tus datos en las tablas `users`, `habits`, etc.

---

## 🩺 Problemas frecuentes

| Síntoma | Causa / Solución |
|---|---|
| Backend no arranca, log `password authentication failed` | `DB_USERNAME` mal: debe ser `postgres.<ref>` exacto del Session Pooler. |
| Backend log `Connection refused` / timeout BBDD | Usaste "Direct connection" (IPv6). Cambia a **Session pooler** (IPv4). |
| Login/registro falla con error CORS en consola del navegador | `CORS_ALLOWED_ORIGINS` no coincide **exactamente** con la URL del frontend (sin `/` final). |
| Recargar `/dashboard` da 404 | Falta la regla Rewrite `/* → /index.html` en el static site. |
| Flyway error "found non-empty schema" | En Supabase SQL Editor: `DROP SCHEMA public CASCADE; CREATE SCHEMA public;` y redeploya el backend (¡solo si la BBDD está vacía!). |
| Primera petición tarda mucho | Normal en free tier (backend dormido). Considera un cron externo que haga ping cada 14 min. |

---

## 🔄 Despliegues posteriores

Cada vez que hagas `git push` a `main`, Render **redespliega automáticamente** backend y frontend. No hay que hacer nada más.
