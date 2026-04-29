from sqlalchemy import Column, Integer, String, DateTime, ForeignKey
from src.utils.db import Base
from datetime import datetime


class Image(Base):
    __tablename__ = "images"

    id = Column(Integer, primary_key=True, autoincrement=True)
    user_id = Column(Integer, ForeignKey("user.user_id", ondelete="CASCADE"))
    image_url = Column(String, nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)


class Tag(Base):
    __tablename__ = "tags"

    id = Column(Integer, primary_key=True)
    name = Column(String, unique=True, nullable=False)


class ImageTag(Base):
    __tablename__ = "image_tags"

    image_id = Column(
        Integer, ForeignKey("images.id", ondelete="CASCADE"), primary_key=True
    )
    tag_id = Column(
        Integer, ForeignKey("tags.id", ondelete="CASCADE"), primary_key=True
    )
