from pydantic import BaseModel, ConfigDict


class UserRegisterPayload(BaseModel):
    name: str
    user_name: str
    email: str
    password: str


class UserLogin(BaseModel):
    model_config = ConfigDict(extra="allow")

    user_name: str
    password: str


class User(BaseModel):
    user_name: str
    user_id: int
