from pydantic import BaseModel, ConfigDict


class UserLogin(BaseModel):
    model_config = ConfigDict(extra="allow")

    token: str


class User(BaseModel):
    email: str
    user_id: int
