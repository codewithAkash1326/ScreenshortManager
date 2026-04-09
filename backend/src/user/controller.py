from fastapi import Depends
from src.utils.db import get_db
from sqlalchemy.orm import Session
from src.user.dtos import UserRegisterPayload, UserLogin
from src.user.models import User
from fastapi import HTTPException
from pwdlib import PasswordHash
from src.user.dtos import UserCreatedResponse
from datetime import datetime, timedelta
from src.utils.settings import settings
import jwt

password_hash = PasswordHash.recommended()


def get_password_hash(password):
    return password_hash.hash(password)


def verify_password(plain_password, hashed_password):
    return password_hash.verify(plain_password, hashed_password)


def register_user(body: UserRegisterPayload, db: Session = Depends(get_db)):
    if body.user_name == "":
        raise HTTPException(status_code=400, detail="UserName cannot be empty")
    if body.name == "":
        raise HTTPException(status_code=400, detail="Name cannot be empty")
    if body.email == "":
        raise HTTPException(status_code=400, detail="Email cannot be empty")
    if body.password == "":
        raise HTTPException(status_code=400, detail="password cannot be empty")

    # Evaluate the queries; a bare Query object is always truthy, so use first()
    is_user_name_exist = db.query(User).filter(User.user_name == body.user_name).first()
    if is_user_name_exist:
        raise HTTPException(status_code=400, detail="user_name already exist")

    is_user_email_exist = db.query(User).filter(User.email == body.email).first()
    if is_user_email_exist:
        raise HTTPException(status_code=400, detail="email already exist")

    hashed_password = get_password_hash(body.password)

    new_user = User(
        name=body.name,
        user_name=body.user_name,
        email=body.email,
        hash_password=hashed_password,
    )

    db.add(new_user)
    db.commit()
    db.refresh(new_user)

    return UserCreatedResponse(user_name=new_user.user_name, user_id=new_user.user_id)


def login(body: UserLogin, db: Session = Depends(get_db)):
    is_user_exist = db.query(User).filter(body.user_name == User.user_name).first()

    if body.user_name == "":
        raise HTTPException(status_code=400, detail="User can not be empty")

    if body.password == "":
        raise HTTPException(status_code=400, detail="password cannot be empty")

    if not is_user_exist:
        raise HTTPException(status_code=400, detail="No user found")

    user = db.query(User).filter(User.user_name == body.user_name).first()
    hashed_password = user.hash_password
    password_match = verify_password(body.password, hashed_password)

    if not password_match:
        raise HTTPException(status_code=400, detail="Passowrd is incorrect")

    exp_time = datetime.now() + timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)

    token = jwt.encode(
        {"_id": user.user_id, "exp_time": int(exp_time.timestamp())},
        settings.TOKEN_SECRET_KEY,
        algorithm=settings.ALGORITHM,
    )

    return {
        "messagge": "Login succesfully",
        "token": token,
        "user_details": UserCreatedResponse(
            user_name=user.user_name, user_id=user.user_id
        ),
    }
