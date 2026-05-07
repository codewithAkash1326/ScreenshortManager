from src.utils.db import Base
from sqlalchemy import Column, String, Integer


class User(Base):
    __tablename__ = "user"

    user_id = Column(Integer, primary_key=True)

    name = Column(String)
    email = Column(String, unique=True)
    user_name = Column(String)

    firebase_uid = Column(String, unique=True, nullable=False)

    auth_provider = Column(String, default="email")
