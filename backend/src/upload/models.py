from sqlalchemy import Column, Integer, String, DateTime
from src.utils.db import Base
from sqlalchemy.dialects.postgresql import ARRAY
from datetime import datetime


class Screenshot(Base):
    __tablename__ = "screenshots"

    id = Column(Integer, primary_key=True)
    image_url = Column(String)
    public_id = Column(String)
    extracted_text = Column(String)
    tags = Column(ARRAY(String))
    created_at = Column(DateTime, default=datetime.utcnow)
