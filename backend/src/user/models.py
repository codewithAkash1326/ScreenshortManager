from src.utils.db import Base
from sqlalchemy import Column, String, Integer


class User(Base):
    __tablename__ = "user"
    user_id = Column(Integer, primary_key=True)
    name = Column(String)
    email = Column(String)
    user_name = Column(String)
    hash_password = Column(String)
