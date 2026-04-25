from fastapi import APIRouter, Depends, File, UploadFile
from sqlalchemy.orm import Session
from src.utils.db import get_db
from src.user.dtos import User
from src.upload import controller
from src.upload.dtos import CommonResponse
from src.utils.helpers import is_authenticated


screenshot_routes = APIRouter(prefix="/screenshot")


@screenshot_routes.post("/upload")
async def upload_image(
    file: UploadFile = File(...),
    user: User = Depends(is_authenticated),
    db: Session = Depends(get_db),
):
    return await controller.upload_image(file, db, user)


@screenshot_routes.get("/get_images")
def get_images(user: User = Depends(is_authenticated), db: Session = Depends(get_db)):
    return controller.get_tags_with_preview(db, user)


@screenshot_routes.get(
    "/search",
)
def search_image(
    query: str = "",
    db: Session = Depends(get_db),
    user: User = Depends(is_authenticated),
):
    return controller.search_image(query, db, user)
