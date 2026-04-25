from pydantic import BaseModel
from typing import Any, Optional


class ErrorResponse(BaseModel):
    code: int
    message: str


class CommonResponse(BaseModel):
    data: Optional[Any] = None
    error: Optional[ErrorResponse] = None
