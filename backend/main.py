from fastapi import FastAPI
from src.utils.db import Base, engine
from src.upload.router import screenshot_routes
from src.user.router import user_routes
from src.utils.cloudinary import init_cloudinary
from src.upload.dtos import CommonResponse, ErrorResponse
from fastapi.responses import JSONResponse
from fastapi import Request
from fastapi.exceptions import HTTPException


init_cloudinary()

Base.metadata.create_all(bind=engine)
app = FastAPI()
app.include_router(screenshot_routes)
app.include_router(user_routes)


@app.exception_handler(HTTPException)
async def custom_http_exception_handler(request: Request, exc: HTTPException):
    return JSONResponse(
        status_code=exc.status_code,
        content=CommonResponse(
            data=None,
            error=ErrorResponse(
                code=str(exc.status_code),
                message=exc.detail,
            ),
        ).dict(),
    )
