from fastapi import Depends
from fastapi.responses import JSONResponse
from src.utils.db import get_db
from sqlalchemy.orm import Session
from src.user.dtos import UserRegisterPayload, UserLogin
from src.upload.dtos import CommonResponse, ErrorResponse
from src.user.models import User
from fastapi import HTTPException
from pwdlib import PasswordHash
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
        return JSONResponse(
            status_code=400,
            content=CommonResponse(
                data=None,
                error=ErrorResponse(code="000", message="user name can not be empty"),
            ).dict(),
        )

    if body.name == "":
        return JSONResponse(
            status_code=400,
            content=CommonResponse(
                data=None,
                error=ErrorResponse(code="000", message="Name can not be empty"),
            ).dict(),
        )

    if body.email == "":
        return JSONResponse(
            status_code=400,
            content=CommonResponse(
                data=None,
                error=ErrorResponse(code="000", message="Email can not be empty"),
            ).dict(),
        )

    if body.password == "":
        return JSONResponse(
            status_code=400,
            content=CommonResponse(
                data=None,
                error=ErrorResponse(code="000", message="Password cannot be empty"),
            ).dict(),
        )

    is_user_name_exist = db.query(User).filter(User.user_name == body.user_name).first()
    if is_user_name_exist:
        return JSONResponse(
            status_code=400,
            content=CommonResponse(
                data=None,
                error=ErrorResponse(code="000", message="user name already exist"),
            ).dict(),
        )

    is_user_email_exist = db.query(User).filter(User.email == body.email).first()
    if is_user_email_exist:
        return JSONResponse(
            status_code=400,
            content=CommonResponse(
                data=None,
                error=ErrorResponse(code="000", message="email already exists"),
            ).dict(),
        )

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

    return JSONResponse(
        status_code=201,
        content=CommonResponse(
            data={
                "user_id": new_user.user_id,
                "user_name": new_user.user_name,
                "email": new_user.email,
            },
            error=ErrorResponse(code="000", message="No error"),
        ).dict(),
    )


def login(body: UserLogin, db: Session = Depends(get_db)):
    is_user_exist = db.query(User).filter(body.user_name == User.user_name).first()

    if body.user_name == "":
        return JSONResponse(
            status_code=400,
            content=CommonResponse(
                data=None,
                error=ErrorResponse(code="400", message="User can not be emty"),
            ).dict(),
        )

    if body.password == "":
        return JSONResponse(
            status_code=400,
            content=CommonResponse(
                data=None,
                error=ErrorResponse(code="400", message="Passowrd cannot be empty"),
            ).dict(),
        )

    if not is_user_exist:
        return JSONResponse(
            status_code=400,
            content=CommonResponse(
                data=None,
                error=ErrorResponse(code="400", message="No user found"),
            ).dict(),
        )

    user = db.query(User).filter(User.user_name == body.user_name).first()
    hashed_password = user.hash_password
    password_match = verify_password(body.password, hashed_password)

    if not password_match:
        return JSONResponse(
            status_code=400,
            content=CommonResponse(
                data=None,
                error=ErrorResponse(code="400", message="Passowrd is incorrect"),
            ).dict(),
        )

    exp_time = datetime.now() + timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)

    token = jwt.encode(
        {"_id": user.user_id, "exp_time": int(exp_time.timestamp())},
        settings.TOKEN_SECRET_KEY,
        algorithm=settings.ALGORITHM,
    )

    data = [
        {
            "messagge": "Login succesfully",
            "token": token,
            "user_name": user.user_name,
            "user_id": user.user_id,
        }
    ]

    return JSONResponse(
        status_code=200,
        content=CommonResponse(
            data=data, error=ErrorResponse(code="000", message="no error")
        ).dict(),
    )
