from app.extensions import ma
from ..models.transaction import Transaction

class TransactionSchema(ma.SQLAlchemyAutoSchema):
    class Meta:
        model = Transaction
        load_instance = True
        include_fk = True
