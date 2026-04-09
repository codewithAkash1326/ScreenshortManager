from fastapi import Request, Depends, HTTPException, status
from sqlalchemy.orm import Session
from src.utils.db import get_db
from src.utils.settings import settings
from src.user.models import User
from src.user.dtos import UserCreatedResponse
import jwt

from jwt import InvalidTokenError


def is_authenticated(request: Request, db: Session = Depends(get_db)):

    try:
        headers = request.headers
        token = headers.get("Authorization")

        if not token:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED, detail="token is empty"
            )

        data = jwt.decode(token, settings.TOKEN_SECRET_KEY, settings.ALGORITHM)

        user_id = data.get("_id")

        user = db.query(User).filter(user_id == User.user_id).first()

        if not user:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED, detail="User not exixts"
            )

        return UserCreatedResponse(user_name=user.user_name, user_id=user.user_id)

    except InvalidTokenError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED, detail="you are unauthorized"
        )
