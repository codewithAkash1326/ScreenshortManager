# Screenshot Manager

FastAPI backend for uploading screenshots, extracting text with Tesseract OCR, tagging them automatically, and storing metadata (image URL, tags, extracted text) in PostgreSQL.

## Features
- Upload images and push bytes to Cloudinary storage.
- Run OCR via Tesseract to extract text from screenshots.
- Auto-generate tags from extracted text.
- List tags with a preview image for quick browsing.
- Basic user registration/login with JWT issuance.

## Tech stack
- FastAPI, SQLAlchemy
- PostgreSQL (Supabase-compatible connection string)
- Cloudinary for image storage
- Tesseract OCR via `pytesseract`
- JWT via PyJWT

## Prerequisites
- Python 3.9+
- PostgreSQL instance (local or Supabase)
- Tesseract binary installed (macOS: `brew install tesseract`)
- Cloudinary account (cloud name, API key, secret)

## Setup
```bash
cd backend
python -m venv venv
source venv/bin/activate  # Windows: venv\\Scripts\\activate
pip install -r requirement.txt
```

Create a `.env` file in `backend/`:
```
DB_CONNECTION=postgresql://USER:PASS@HOST:5432/DBNAME?sslmode=require
CLOUD_NAME=your_cloudinary_cloud_name
API_KEY=your_cloudinary_api_key
SECRET_KEY=your_cloudinary_secret
TOKEN_SECRET_KEY=your_jwt_secret
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=60
```

## Running
```bash
cd backend
uvicorn main:app --reload
```
API base URL: `http://127.0.0.1:8000`

## Key endpoints
- `POST /screenshot/upload` — multipart upload field `file`; runs OCR, uploads to Cloudinary, saves DB record.
- `GET /screenshot/get_images` — returns tags with a preview image URL.
- `POST /user/register` — create user.
- `POST /user/login` — returns JWT token; rejects extra fields with a custom 400 payload.

## Migrations
Alembic is configured. To create and apply a migration:
```bash
cd backend
alembic revision -m "message"
alembic upgrade head
```

## Notes
- Ensure Tesseract is on your PATH (`tesseract --version`).
- If using Supabase, keep `sslmode=require` in `DB_CONNECTION`.
- See `.gitignore` for files that should stay out of version control.
