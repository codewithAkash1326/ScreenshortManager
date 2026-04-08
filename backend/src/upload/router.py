from fastapi import APIRouter, Depends, File, UploadFile
from sqlalchemy.orm import Session
from src.utils.db import get_db
from src.upload import controller

upload_routes = APIRouter(prefix="/screenshot")


@upload_routes.post("/upload")
async def upload_image(file: UploadFile = File(...), db: Session = Depends(get_db)):
    return await controller.upload_image(file, db)


@upload_routes.get("/get_images")
def get_images(db: Session = Depends(get_db)):
    return controller.get_tags_with_preview(db)
