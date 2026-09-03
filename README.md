# MAP — Master Artist Platform

Plataforma multi-tenant SaaS para que artistas musicales gestionen su presencia digital: sitio web, canciones, eventos, tienda, blog y más.

## Arquitectura

```
Cabitaxx/
├── Backend/          # API REST Node.js + Express + MySQL
├── Frontend/         # SPA React + Vite + Tailwind
├── database.sql      # Schema completo (47 tablas)
├── seed_data.sql     # Seed base (artistas demo, roles, permisos)
├── seed-demo.sql     # Seed contenido demo para Cabitaxx
└── README.md
```

- **Backend**: Express 4, mysql2 (raw SQL), JWT auth, Cloudinary, Winston.
- **Frontend**: React 18, React Router v6, Tailwind CSS v3, react-helmet-async, Axios.

## Requisitos

- Node.js >= 18
- MySQL >= 8.0 (puerto 3307 por defecto en este proyecto)
- npm o yarn

## Variables de entorno

### Backend (`Backend/.env`)

```env
NODE_ENV=development
PORT=4000

DB_HOST=localhost
DB_PORT=3307
DB_NAME=map_platform
DB_USER=root
DB_PASSWORD=Santimajo101219@

JWT_ACCESS_SECRET=tu_access_secret
JWT_REFRESH_SECRET=tu_refresh_secret
JWT_ACCESS_EXPIRES_IN=15m
JWT_REFRESH_EXPIRES_IN=7d

CLOUDINARY_CLOUD_NAME=
CLOUDINARY_API_KEY=
CLOUDINARY_API_SECRET=

SMTP_HOST=
SMTP_PORT=587
SMTP_USER=
SMTP_PASS=
MAIL_FROM=no-reply@map.mastercode.co

CORS_ORIGIN=http://localhost:5173
CLIENT_URL=http://localhost:5173
```

### Frontend (`Frontend/.env`)

```env
VITE_API_URL=/api/v1
VITE_CLIENT_URL=http://localhost:5173
VITE_ARTIST_SLUG=cabitaxx
```

## Instalacion

### 1. Base de datos

```bash
mysql -u root -p < Backend/database.sql
mysql -u root -p map_platform < Backend/seed_data.sql
mysql -u root -p map_platform < Backend/seed-demo.sql
```

### 2. Backend

```bash
cd Backend
npm install
npm run dev
```

API disponible en `http://localhost:4000`.

### 3. Frontend

```bash
cd Frontend
npm install
npm run dev
```

Frontend disponible en `http://localhost:5173`.

## Comandos

### Backend

| Comando | Descripcion |
|---------|-------------|
| `npm run dev` | Inicia servidor con nodemon |
| `npm start` | Inicia servidor en produccion |
| `npm run lint` | Ejecuta ESLint |
| `npm test` | Ejecuta tests Jest |

### Frontend

| Comando | Descripcion |
|---------|-------------|
| `npm run dev` | Inicia Vite dev server |
| `npm run build` | Build de produccion |
| `npm run preview` | Preview del build |
| `npm run lint` | Ejecuta ESLint |
| `npm test` | Ejecuta tests Vitest |

## Credenciales demo

| Rol | Email | Password |
|-----|-------|----------|
| Superadmin | admin@mastercode.co | Mastercode2026! |

Artista demo: slug `cabitaxx`.

## Rutas publicas

- `/` — Home
- `/canciones` — Listado de canciones
- `/canciones/:slug` — Detalle de cancion
- `/eventos` — Listado de eventos
- `/eventos/:slug` — Detalle de evento
- `/blog` — Blog
- `/blog/:slug` — Post del blog
- `/noticias` — Noticias
- `/noticias/:slug` — Noticia
- `/tienda` — Tienda
- `/tienda/:slug` — Producto
- `/galeria` — Galeria
- `/videos` — Videos
- `/videos/:slug` — Detalle de video
- `/albumes` — Albumes
- `/albumes/:slug` — Detalle de album
- `/contacto` — Contacto
- `/carrito` — Carrito de compras
- `/checkout` — Checkout (Mercado Pago / Stripe mock)

## Rutas admin

- `/admin` — Dashboard
- `/admin/canciones` — Gestion de canciones
- `/admin/eventos` — Gestion de eventos
- `/admin/tienda` — Gestion de productos
- `/admin/pedidos` — Ordenes
- `/admin/noticias` — Noticias
- `/admin/galeria` — Galeria
- `/admin/newsletter` — Newsletter
- `/admin/publicaciones` — Publicaciones
- `/admin/analiticas` — Analiticas
- `/admin/configuracion` — Configuracion
- `/admin/albumes` — Gestion de albumes
- `/admin/videos` — Gestion de videos

## API SEO

- `GET /sitemap.xml` — Sitemap XML del artista
- `GET /robots.txt` — Robots.txt
- `GET /api/v1/seo/:artist_slug` — Metadatos SEO del artista

## Pagos

- Checkout con soporte para **Mercado Pago** (mock listo para integrar credenciales reales) y Stripe mock.
- Endpoints: `POST /api/v1/payments/checkout`, `GET /api/v1/payments/status`, `GET /api/v1/payments/success`, `GET /api/v1/payments/failure`, `GET /api/v1/payments/pending`
- Frontend: flujo de 4 pasos (envio -> resumen -> pago -> confirmacion) con pagina intermedia `/pagos/mercado-pago`.

## Comunidad

- Comentarios: `POST /api/v1/community/comments`
- Likes: `POST /api/v1/community/likes`
- Seguir artista: `POST /api/v1/community/follows`

## Planes SaaS

El middleware `checkPlan` habilita features segun el plan almacenado en `artist_settings` (`key = 'plan'`):

| Plan | Features |
|------|----------|
| free | Canciones, eventos, blog |
| pro | + Tienda, analiticas |
| enterprise | + Newsletter, videos |

## Convenciones

- **Backend**: `feature.layer.js` (dot.case) para archivos nuevos. Raw SQL, sin ORM.
- **Frontend**: imports con alias `@/`. Contextos con `createContext` + hook `use*()`.
- **Multi-tenant**: rutas publicas usan `:artist_slug` en URL.
- **Tenant resolution**: header `X-Artist-Slug`, subdominio o query param `?artist=slug`.

## Roadmap

- [x] Service worker (offline caching) — PWA lista
- [ ] Integracion real Cloudinary / SMTP
- [x] Pasarela de pagos (Mercado Pago mock lista)
- [ ] Multi-idioma (i18n)

## Despliegue en produccion

### Frontend — Netlify

1. Conecta el repositorio en Netlify.
2. Configura el build:
   - **Base directory**: `Frontend`
   - **Build command**: `npm run build`
   - **Publish directory**: `Frontend/dist`
3. Variables de entorno en Netlify:
   - `VITE_API_URL` = `/api/v1`
   - `VITE_CLIENT_URL` = `https://cabitaxx.netlify.app`
   - `VITE_ARTIST_SLUG` = `cabitaxx`
4. El archivo `netlify.toml` en la raiz del proyecto redirige todas las rutas a `index.html` para SPA.

### Backend — Railway

1. Conecta el repositorio en Railway.
2. Crea un servicio MySQL en Railway.
3. Crea el servicio Node.js:
   - **Root directory**: `Backend`
   - **Start command**: lo define `railway.json` → `node migrate.js && node seed.js && node src/server.js` (corre migración + seed antes de levantar el API).
4. Variables de entorno en Railway:
   - `DATABASE_URL` o `DB_HOST`/`DB_PORT`/`DB_USER`/`DB_PASSWORD`/`DB_NAME` (se inyectan automáticamente desde MySQL).
   - `DB_SSL=true` (managed MySQL).
   - `JWT_ACCESS_SECRET` = genera un secreto seguro de 32+ chars.
   - `JWT_REFRESH_SECRET` = genera un secreto seguro de 32+ chars.
   - `CLIENT_URL` = `https://cabitaxx.netlify.app`
   - `CORS_ORIGIN` = `https://cabitaxx.netlify.app`
   - `ADMIN_EMAIL`, `ADMIN_NAME`, `ADMIN_PASSWORD` para que `seed.js` cree/actualice el admin inicial.
5. Cada deploy corre migrate + seed de forma idempotente, así que no es necesario correr `railway run npm run migrate` manualmente.

### Base de datos — MySQL (Railway)

1. Crea una base de datos MySQL en Railway.
2. Las variables de conexión se inyectan automáticamente al servicio Node.js.
3. La migración inicial corre como parte del `startCommand` definido en `railway.json` (`node migrate.js`).
4. Los datos iniciales (roles, permisos, artista `cabaxx`, admin, cupón de bienvenida) corren con `node seed.js` en el mismo arranque.

### Credenciales demo (produccion)

| Rol | Email | Password |
|-----|-------|----------|
| Superadmin | admin@mastercode.co | Mastercode2026! |

Artista demo: slug `cabitaxx`.

