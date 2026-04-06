from fastapi import Depends
from sqlalchemy.orm import Session
from src.utils.db import get_db


def upload_image(db: Session = Depends(get_db)):
    return {"data": "image uploaded"}
