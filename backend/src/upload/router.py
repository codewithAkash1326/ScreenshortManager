from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from src.utils.db import get_db
from src.upload import controller

upload_routes = APIRouter(prefix="/upload")


@upload_routes.get("/file")
def upload_post(db: Session = Depends(get_db)):
    return controller.upload_image()
