from app.extensions import ma
from ..models.recurring_transaction import RecurringTransaction

class RecurringTransactionSchema(ma.SQLAlchemyAutoSchema):
    class Meta:
        model = RecurringTransaction
        load_instance = True
