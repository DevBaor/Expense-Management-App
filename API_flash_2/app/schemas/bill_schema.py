from app.extensions import ma
from ..models.bill import Bill

class BillSchema(ma.SQLAlchemyAutoSchema):
    class Meta:
        model = Bill
        load_instance = True
