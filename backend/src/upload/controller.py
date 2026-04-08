from fastapi import Depends, File, UploadFile
from sqlalchemy.orm import Session
from src.utils.db import get_db
import cloudinary.uploader
from PIL import Image
import io
import pytesseract
from src.upload.models import Screenshot
from typing import List, Dict
from sqlalchemy import func, select
from keybert import KeyBERT
import re


def clean_text(text):
    text = text.lower()
    text = re.sub(r"[^\w\s]", " ", text)  # remove symbols
    text = re.sub(r"\s+", " ", text).strip()

    return text


kw_model = KeyBERT()


async def upload_to_cloudinary(file_bytes):
    print("inside the api")
    result = cloudinary.uploader.upload(file_bytes, folder="screenshots")

    return {"url": result["secure_url"], "public_id": result["public_id"]}


def generate_tags(text):
    text = clean_text(text)

    if len(text) < 5:
        return []

    try:
        keywords = kw_model.extract_keywords(text, top_n=5)
        return [kw[0] for kw in keywords]
    except Exception:
        return []


async def upload_image(file: UploadFile = File(...), db: Session = Depends(get_db)):
    contents = await file.read()
    image = Image.open(io.BytesIO(contents))

    image = image.convert("L")

    text = pytesseract.image_to_string(image)

    # 5. Generate tags from text
    tags = generate_tags(text)

    cloud_data = await upload_to_cloudinary(contents)

    new_item = Screenshot(
        image_url=cloud_data["url"],
        public_id=cloud_data["public_id"],
        extracted_text=text,
        tags=tags,
    )

    db.add(new_item)
    db.commit()
    db.refresh(new_item)

    return {"text": text, "tags": tags}


def get_tags_with_preview(db: Session) -> List[Dict]:
    # 1. Convert the ARRAY tags into rows
    tag_column = func.unnest(Screenshot.tags).label("tag")

    # 2. Build the select statement
    stmt = (
        select(tag_column, Screenshot.image_url)
        .distinct(tag_column)  # DISTINCT ON each tag
        .order_by(tag_column, Screenshot.created_at.desc())  # pick latest image
    )

    # 3. Execute the query
    results = db.execute(stmt).all()

    # 4. Convert to JSON-friendly list
    return [{"tag": row.tag, "preview": row.image_url} for row in results]
