from fastapi import Depends, File, UploadFile
from sqlalchemy.orm import Session
from src.utils.db import get_db
import cloudinary.uploader
from PIL import Image
import io
import pytesseract
from src.upload.models import Screenshot


async def upload_to_cloudinary(file_bytes):
    print("inside the api")
    result = cloudinary.uploader.upload(file_bytes, folder="screenshots")

    return {"url": result["secure_url"], "public_id": result["public_id"]}


def generate_tags(text):
    words = text.lower().split()
    return list(set([w for w in words if len(w) > 3]))


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
