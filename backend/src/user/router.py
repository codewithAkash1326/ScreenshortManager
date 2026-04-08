from fastapi import APIRouter, Depends, status, HTTPException
from sqlalchemy.orm import Session
from src.utils.db import get_db
from src.user.dtos import UserRegisterPayload, UserLogin
from src.user import controller

user_routes = APIRouter(prefix="/user")


@user_routes.post("/register", status_code=status.HTTP_201_CREATED)
def register_user(body: UserRegisterPayload, db: Session = Depends(get_db)):
    return controller.register_user(body, db)


@user_routes.post("/login", status_code=status.HTTP_200_OK)
def login(body: UserLogin, db: Session = Depends(get_db)):
    extra_fields = set((body.model_extra or {}).keys())

    if extra_fields:
        raise HTTPException(
            status_code=400,
            detail={
                "error": "Extra fields not allowed",
                "extra_fields": list(extra_fields),
                "code": 400,
            },
        )
    return controller.login(body, db)
