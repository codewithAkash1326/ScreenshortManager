from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", extra="ignore")

    DB_CONNECTION: str

    CLOUD_NAME: str
    API_KEY: str
    SECRET_KEY: str


settings = Settings()
