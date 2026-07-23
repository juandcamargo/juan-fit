# Juan Fit

App personal de fitness y nutrición. Una sola página (`index.html`), sin build ni dependencias de servidor — funciona sola con almacenamiento local del navegador, y opcionalmente se sincroniza entre dispositivos usando Supabase.

Este README son los pasos para dejarla desplegada en Vercel con Supabase conectado. Tarda unos 10-15 minutos la primera vez.

## 1. Crear el proyecto en Supabase (gratis)

1. Ve a [supabase.com](https://supabase.com) → crea una cuenta (con GitHub es lo más rápido) → **New project**.
2. Elige cualquier nombre y contraseña de base de datos (no la necesitarás luego, Supabase la guarda). Espera ~2 minutos a que se cree.
3. En el menú lateral, ve a **SQL Editor** → **New query**, pega todo el contenido del archivo [`schema.sql`](./schema.sql) de esta carpeta, y dale **Run**. Esto crea la tabla `app_state` con seguridad por usuario (nadie más puede ver tus datos, ni siquiera con la llave pública).
4. Copia dos valores — la forma más simple es con el botón **"Connect"** (arriba del dashboard del proyecto) → pestaña **"Framework"** → deja cualquier framework seleccionado (no importa cuál, los valores son los mismos) → baja hasta el paso **"Set environment variables"**. Ahí vas a ver:
   - **`SUPABASE_URL`** (formato `https://xxxxx.supabase.co`)
   - **`SUPABASE_PUBLISHABLE_KEY`** (empieza con `sb_publishable_...`) — esta es la que usamos como "anon key" en el código.
   - Ignora **`SUPABASE_SECRET_KEY`** — esa nunca se usa en el navegador ni se pega en este proyecto.
5. Ve a **Authentication** (ícono en la barra lateral) y confirma que **Email** esté activado (lo está por defecto). No hace falta contraseña: la app usa "magic link" (un enlace que llega al correo).
6. Busca dentro de Authentication la sección de **URL Configuration** (el nombre exacto puede variar un poco según la versión del panel). Dejaremos esto pendiente hasta el paso 3 (necesitas la URL final de Vercel primero) — hay una nota más abajo recordándotelo. Si no la encuentras, entra directo a `https://supabase.com/dashboard/project/TU-PROJECT-REF/auth/url-configuration` (reemplaza `TU-PROJECT-REF` por el que aparece en tu Project URL, la parte antes de `.supabase.co`).

## 2. Subir el código a GitHub (repo público)

**Opción más simple — sin usar la terminal:**

1. Ve a [github.com/new](https://github.com/new), ponle un nombre (por ejemplo `juan-fit`), déjalo **Public**, no marques ninguna opción de inicialización, y dale **Create repository**.
2. En la página que aparece, busca el enlace **"uploading an existing file"**.
3. Arrastra los archivos `index.html`, `schema.sql` y este `README.md` (todo lo que hay en esta carpeta) y dale **Commit changes**.

**Opción con terminal (si prefieres):**

```bash
cd /Users/usuariomac/Desktop/juan-fit-web
git remote add origin https://github.com/TU-USUARIO/juan-fit.git
git branch -M main
git push -u origin main
```
(Te pedirá iniciar sesión en GitHub la primera vez — sigue las instrucciones en pantalla.)

## 3. Desplegar en Vercel (gratis)

1. Ve a [vercel.com](https://vercel.com) → **Sign up** → elige "Continue with GitHub" (más simple, conecta ambas cuentas de una vez).
2. **Add New → Project** → busca el repo `juan-fit` que acabas de crear → **Import**.
3. No cambies ninguna configuración (es HTML puro, Vercel lo detecta solo) → **Deploy**.
4. En 30-60 segundos te da una URL tipo `https://juan-fit-xxxx.vercel.app`. Esa es tu app.

**Ahora vuelve a Supabase** (paso pendiente del punto 1.6): ve a **Authentication → URL Configuration** y en **Site URL** pon esa URL de Vercel (`https://juan-fit-xxxx.vercel.app`). Agrégala también en **Redirect URLs**. Sin esto, el enlace mágico del correo no te devolverá correctamente a la app.

## 4. Conectar la app con Supabase

1. Abre `index.html` (en tu computador, o directo en GitHub con el botón de editar ✏️).
2. Busca estas dos líneas (cerca del inicio del segundo `<script>`):
   ```js
   const SUPABASE_URL = '';
   const SUPABASE_ANON_KEY = '';
   ```
3. Pega ahí el **Project URL** y la **Publishable key** que copiaste en el paso 1.4.
4. Guarda, sube el cambio a GitHub (arrastrando el archivo de nuevo, o `git add -A && git commit -m "conectar supabase" && git push`). Vercel vuelve a desplegar solo en unos segundos.

## 5. Usar la app en tu iPhone

1. Abre la URL de Vercel en **Safari** (no en la app de Claude ni en Chrome).
2. Te pedirá tu correo la primera vez — escríbelo, revisa tu bandeja de entrada, toca el enlace. Quedas conectado.
3. Toca **Compartir → Agregar a pantalla de inicio**.
4. Abre siempre desde ese ícono. Tus datos ahora viven en Supabase (con respaldo en el navegador), así que sobreviven a reinstalar la app, cambiar de teléfono, o que Safari limpie su almacenamiento local.

## Notas de seguridad

- El repo es público, así que cualquiera puede ver el código — incluida la `anon public key` de Supabase. Esto es **normal y seguro** en Supabase: esa llave por sí sola no deja leer ni escribir nada; solo funciona combinada con haber iniciado sesión con tu correo, gracias a las políticas de seguridad (Row Level Security) del archivo `schema.sql`. Nunca subas la contraseña de la base de datos ni ninguna "service role key" — esas si son secretas y no aparecen en este proyecto.
- Si algún día quieres borrar tu acceso, puedes eliminar tu usuario desde **Authentication → Users** en Supabase.

## Actualizar la app más adelante

Para cualquier cambio futuro: edita `index.html`, súbelo a GitHub (arrastrando el archivo o con `git push`), y Vercel lo despliega automáticamente en segundos. No hay que tocar nada en Supabase salvo que cambie la estructura de datos.
