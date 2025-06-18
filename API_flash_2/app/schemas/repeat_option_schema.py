from app.extensions import ma
from ..models.repeat_option import RepeatOption

class RepeatOptionSchema(ma.SQLAlchemyAutoSchema):
    class Meta:
        model = RepeatOption
        load_instance = True
