from app.extensions import ma
from ..models.event import Event

class EventSchema(ma.SQLAlchemyAutoSchema):
    class Meta:
        model = Event
        load_instance = True
