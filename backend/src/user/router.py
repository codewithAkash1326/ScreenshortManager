from fastapi import APIRouter, Depends, status, HTTPException
from fastapi.responses import JSONResponse
from src.upload.dtos import CommonResponse, ErrorResponse
from sqlalchemy.orm import Session
from src.utils.db import get_db
from src.user.dtos import UserRegisterPayload, UserLogin
from src.user import controller

user_routes = APIRouter(prefix="/user")


@user_routes.post(
    "/register",
)
def register_user(body: UserRegisterPayload, db: Session = Depends(get_db)):
    return controller.register_user(body, db)


@user_routes.post("/login")
def login(body: UserLogin, db: Session = Depends(get_db)):
    extra_fields = set((body.model_extra or {}).keys())

    if extra_fields:
        return JSONResponse(
            status_code=400,
            content=CommonResponse(
                data=None,
                error=ErrorResponse(code="400", message="Extra feild is not allowed"),
            ).dict(),
        )

    return controller.login(body, db)
