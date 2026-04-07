import cloudinary
from src.utils.settings import settings


def init_cloudinary():
    cloudinary.config(
        cloud_name=settings.CLOUD_NAME,
        api_key=settings.API_KEY,
        api_secret=settings.SECRET_KEY,
    )
