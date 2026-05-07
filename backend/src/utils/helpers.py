from fastapi import Request, Depends, HTTPException, status
from sqlalchemy.orm import Session
from src.utils.db import get_db
from src.utils.settings import settings
from src.user.models import User
import jwt
from jwt import InvalidTokenError , ExpiredSignatureError


def is_authenticated(request: Request, db: Session = Depends(get_db)):

    try:
        headers = request.headers
        token = headers.get("Authorization")

        if not token:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED, detail="token is empty"
            )

        data = jwt.decode(token, settings.TOKEN_SECRET_KEY,  algorithms=[settings.ALGORITHM],)

        user_id = data.get("_id")

        user = db.query(User).filter(User.user_id == user_id).first()

        if not user:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED, detail="User not exixts"
            )

        return User(user_name=user.user_name, user_id=user.user_id)
    except ExpiredSignatureError:
        raise HTTPException(401, "Token expired")
    
    except InvalidTokenError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED, detail="you are unauthorizedssss"
        )
