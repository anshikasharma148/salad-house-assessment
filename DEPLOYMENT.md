# Deployment Guide

This guide covers deploying the Inventory Management System to various platforms.

## Quick Deploy Options

### Option 1: Railway (Recommended - Easiest)

1. **Sign up** at [railway.app](https://railway.app)
2. **Create New Project** → "Deploy from GitHub repo"
3. **Connect your GitHub repository**
4. **Add PostgreSQL** service (Railway will auto-create)
5. **Set Environment Variables:**
   - `DATABASE_URL` (auto-set by Railway)
   - `SECRET_KEY_BASE` (generate: `mix phx.gen.secret`)
   - `PORT` (Railway sets this automatically)
6. **Deploy** - Railway will auto-detect and deploy

**Frontend on Vercel:**
1. Sign up at [vercel.com](https://vercel.com)
2. Import your GitHub repo
3. Set root directory to `frontend`
4. Add environment variable:
   - `REACT_APP_API_URL` = your Railway backend URL (e.g., `https://your-app.railway.app/api`)
5. Deploy

---

### Option 2: Render

**Backend:**
1. Sign up at [render.com](https://render.com)
2. Create **New Web Service** → Connect GitHub
3. Settings:
   - **Build Command:** `cd backend && mix deps.get && mix compile`
   - **Start Command:** `cd backend && mix phx.server`
   - **Environment:** Elixir
4. Add **PostgreSQL** database
5. Set environment variables:
   - `DATABASE_URL` (from PostgreSQL service)
   - `SECRET_KEY_BASE` (generate: `mix phx.gen.secret`)
   - `MIX_ENV=prod`
6. Deploy

**Frontend:**
1. Create **New Static Site** → Connect GitHub
2. Settings:
   - **Build Command:** `cd frontend && npm install && npm run build`
   - **Publish Directory:** `frontend/build`
3. Add environment variable:
   - `REACT_APP_API_URL` = your Render backend URL
4. Deploy

---

### Option 3: Fly.io

**Backend:**
1. Install Fly CLI: `curl -L https://fly.io/install.sh | sh`
2. Sign up: `fly auth signup`
3. Initialize: `cd backend && fly launch`
4. Add PostgreSQL: `fly postgres create`
5. Attach database: `fly postgres attach <db-name>`
6. Deploy: `fly deploy`

**Frontend:**
- Deploy to Vercel or Netlify (same as Railway option)

---

## Environment Variables

### Backend (Production)
```
DATABASE_URL=postgresql://user:pass@host:port/dbname
SECRET_KEY_BASE=your-secret-key-here
PORT=4000
MIX_ENV=prod
```

### Frontend (Production)
```
REACT_APP_API_URL=https://your-backend-url.com/api
```

---

## Generate Secret Key

Run this command to generate a secure secret key:
```bash
cd backend
mix phx.gen.secret
```

---

## Database Migrations

After deployment, run migrations:
```bash
# Railway/Render
mix ecto.migrate

# Or via platform CLI
```

---

## Post-Deployment Checklist

- [ ] Backend is running and accessible
- [ ] Database migrations completed
- [ ] Frontend API URL points to backend
- [ ] CORS is configured correctly
- [ ] Test creating an item
- [ ] Test recording a movement
- [ ] Test negative stock prevention

---

## Troubleshooting

**Backend won't start:**
- Check DATABASE_URL is correct
- Verify SECRET_KEY_BASE is set
- Check logs for errors

**Frontend can't connect:**
- Verify REACT_APP_API_URL is correct
- Check CORS settings in backend
- Ensure backend URL includes `/api` path

**Database connection errors:**
- Verify DATABASE_URL format
- Check database is running
- Verify network access

