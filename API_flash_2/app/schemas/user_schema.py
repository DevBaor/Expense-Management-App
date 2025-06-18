from app.extensions import ma
from ..models.user import User, db


class UserSchema(ma.SQLAlchemyAutoSchema):
    class Meta:
        model = User
        load_instance = True
