# Deploy Backend to Render

## Step-by-Step Guide

### 1. Sign up / Login to Render
- Go to [render.com](https://render.com)
- Sign up or login with your GitHub account

### 2. Create PostgreSQL Database
1. Click **"New +"** → **"PostgreSQL"**
2. Name: `inventory-house-db`
3. Database: `inventory_house`
4. User: `inventory_house`
5. Region: Choose closest to you
6. Plan: **Free** (for testing)
7. Click **"Create Database"**
8. **Save the Internal Database URL** - you'll need it later

### 3. Deploy Backend Service
1. Click **"New +"** → **"Web Service"**
2. Connect your GitHub repository: `salad-house-assessment`
3. Configure:
   - **Name:** `inventory-house-backend`
   - **Environment:** `Elixir`
   - **Region:** Same as database
   - **Branch:** `main`
   - **Root Directory:** `backend` (important!)
   - **Build Command:** `mix deps.get && MIX_ENV=prod mix compile`
   - **Start Command:** `MIX_ENV=prod mix phx.server`

4. **Environment Variables:**
   - `MIX_ENV` = `prod`
   - `DATABASE_URL` = (Copy from your PostgreSQL service → "Internal Database URL")
   - `SECRET_KEY_BASE` = (Generate: `cd backend && mix phx.gen.secret`)
   - `PORT` = `4000` (Render sets this automatically, but include it)

5. Click **"Create Web Service"**

### 4. Run Database Migrations
After the service is deployed:
1. Go to your backend service
2. Click **"Shell"** tab
3. Run:
   ```bash
   MIX_ENV=prod mix ecto.migrate
   ```

### 5. Update Frontend API URL
1. Go to your **Vercel** project dashboard
2. **Settings** → **Environment Variables**
3. Update `REACT_APP_API_URL`:
   - Value: `https://inventory-house-backend.onrender.com/api`
   - (Replace with your actual Render backend URL)
4. **Save** - Vercel will auto-redeploy

### 6. Update CORS (if needed)
If your Render URL is different, add it to CORS:
1. In Render backend service → **Environment** tab
2. Add environment variable:
   - Key: `CORS_ORIGIN`
   - Value: `https://salad-house-assessment.vercel.app`
3. Redeploy

## Your URLs:
- **Frontend:** https://salad-house-assessment.vercel.app
- **Backend:** https://inventory-house-backend.onrender.com (your actual URL)
- **API Endpoint:** https://inventory-house-backend.onrender.com/api

## Troubleshooting

**Backend won't start:**
- Check `DATABASE_URL` is correct
- Verify `SECRET_KEY_BASE` is set
- Check build logs for errors

**Database connection errors:**
- Use **Internal Database URL** (not External)
- Verify database is running
- Check network access

**CORS errors:**
- Verify `CORS_ORIGIN` env var includes your Vercel URL
- Check backend logs for CORS errors

