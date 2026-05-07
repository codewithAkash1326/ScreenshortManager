import firebase_admin
from firebase_admin import credentials

cred = credentials.Certificate(
    "capturely-fea53-firebase-adminsdk-fbsvc-d136e45380.json"
)

firebase_admin.initialize_app(cred)