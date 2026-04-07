from fastapi import APIRouter, Depends, File, UploadFile
from sqlalchemy.orm import Session
from src.utils.db import get_db
from src.upload import controller

upload_routes = APIRouter(prefix="/upload")


@upload_routes.post("/file")
async def upload_image(file: UploadFile = File(...), db: Session = Depends(get_db)):
    return await controller.upload_image(file, db)
