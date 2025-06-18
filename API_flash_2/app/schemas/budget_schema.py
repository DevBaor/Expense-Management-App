from app.extensions import ma
from ..models.budget import Budget

class BudgetSchema(ma.SQLAlchemyAutoSchema):
    class Meta:
        model = Budget
        load_instance = True
        include_fk = True
