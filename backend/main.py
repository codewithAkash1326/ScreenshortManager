from fastapi import FastAPI
from src.utils.db import Base, engine
from src.upload.router import upload_routes

Base.metadata.create_all(bind=engine)
app = FastAPI()
app.include_router(upload_routes)
