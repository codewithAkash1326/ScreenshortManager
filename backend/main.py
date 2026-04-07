from fastapi import FastAPI
from src.utils.db import Base, engine
from src.upload.router import upload_routes
from src.utils.cloudinary import init_cloudinary

init_cloudinary()

Base.metadata.create_all(bind=engine)
app = FastAPI()
app.include_router(upload_routes)
