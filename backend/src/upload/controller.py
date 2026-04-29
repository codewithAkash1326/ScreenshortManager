from fastapi import Depends, File, UploadFile, Request
from fastapi.responses import JSONResponse
from sqlalchemy.orm import Session
from sqlalchemy import func

from src.utils.db import get_db
import cloudinary.uploader
from PIL import Image as PILImage
from src.user.dtos import User
import io
import pytesseract
from src.upload.models import Image, Tag, ImageTag
from src.upload.dtos import ErrorResponse, CommonResponse
from typing import List, Dict
from sqlalchemy import func, select
from keybert import KeyBERT
from src.utils.helpers import is_authenticated
import re


def clean_text(text):
    text = text.lower()
    text = re.sub(r"[^\w\s]", " ", text)
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


def save_image_with_tags(db, user_id, image_url, tags):
    # Step 1: Save image
    new_image = Image(user_id=user_id, image_url=image_url)
    db.add(new_image)
    db.commit()
    db.refresh(new_image)

    # Step 2: Get existing tags
    existing_tags = db.query(Tag).filter(Tag.name.in_(tags)).all()

    existing_tag_names = {tag.name for tag in existing_tags}

    # Step 3: Create missing tags
    new_tags = []
    for tag_name in tags:
        if tag_name not in existing_tag_names:
            tag = Tag(name=tag_name)
            db.add(tag)
            new_tags.append(tag)

    db.commit()

    # Step 4: Combine all tags
    all_tags = existing_tags + new_tags

    # Step 5: Insert into mapping table
    for tag in all_tags:
        db.add(ImageTag(image_id=new_image.id, tag_id=tag.id))

    db.commit()

    return JSONResponse(
        status_code=200,
        content=CommonResponse(
            data={"tags": tags},
            error=ErrorResponse(code=200, message="image uploaded succesfully"),
        ).dict(),
    )


async def upload_image(
    file: UploadFile = File(...),
    db: Session = Depends(get_db),
    user: User = Depends(is_authenticated),
):
    contents = await file.read()
    image = PILImage.open(io.BytesIO(contents))

    image = image.convert("L")

    text = pytesseract.image_to_string(image)

    tags = generate_tags(text)

    cloud_data = await upload_to_cloudinary(contents)

    return save_image_with_tags(db, user.user_id, cloud_data["url"], tags)


def search_image(
    query, db: Session = Depends(get_db), user: User = Depends(is_authenticated)
):

    if not query.strip():
        return JSONResponse(
            status_code=400,
            content=CommonResponse(
                data=None,
                error=ErrorResponse(code=400, message="Query cannot be empty"),
            ).dict(),
        )

    stmt = (
        select(Image.image_url)
        .join(ImageTag, Image.id == ImageTag.image_id)
        .join(Tag, Tag.id == ImageTag.tag_id)
        .where(Image.user_id == user.user_id, Tag.name.ilike(f"%{query}%"))
    )

    res = db.execute(stmt).scalars().all()

    if not res:
        return JSONResponse(
            status_code=404,
            content=CommonResponse(
                data=[],
                error=ErrorResponse(code=404, message="No results found"),
            ).dict(),
        )

    return JSONResponse(
        status_code=200,
        content=CommonResponse(data=res, error=None).dict(),
    )


def get_tags_with_preview(
    db: Session, user: User = Depends(is_authenticated)
) -> List[Dict]:

    stmt = (
        select(func.string_agg(Tag.name, ", ").label("tags"), Image.image_url)
        .join(ImageTag, Image.id == ImageTag.image_id)
        .join(Tag, Tag.id == ImageTag.tag_id)
        .where(Image.user_id == user.user_id)
        .group_by(Image.image_url)
    )

    results = db.execute(stmt).all()
    data = []

    print(results)

    for tags_str, image_url in results:

        data.append(
            {
                "image_url": image_url,
                "tags": [tag.strip() for tag in tags_str.split(",")],
            }
        )

    if not results:
        return JSONResponse(
            status_code=404,
            content=CommonResponse(
                data=[], error=ErrorResponse(code=404, message="No results found")
            ).dict(),
        )

    return JSONResponse(
        status_code=200, content=CommonResponse(data=data, error=None).dict()
    )
