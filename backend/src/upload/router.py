from fastapi import APIRouter, Depends, File, UploadFile
from sqlalchemy.orm import Session
from src.utils.db import get_db
from src.upload import controller
from src.user.dtos import UserCreatedResponse
from src.utils.helpers import is_authenticated


upload_routes = APIRouter(prefix="/screenshot")


@upload_routes.post("/upload")
async def upload_image(
    file: UploadFile = File(...),
    user: UserCreatedResponse = Depends(is_authenticated),
    db: Session = Depends(get_db),
):
    return await controller.upload_image(file, db, user)


@upload_routes.get("/get_images")
def get_images(db: Session = Depends(get_db)):
    return controller.get_tags_with_preview(db)
