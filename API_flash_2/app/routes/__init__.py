from .user_routes import user_bp
from .bill_routes import bill_bp
from .wallet_routes import wallet_bp
from .category_routes import category_bp
from .transaction_routes import transaction_bp
from .budget_routes import budget_bp
from .repeat_option_routes import repeat_option_bp
from .recurring_transaction_routes import recurring_transaction_bp
from .event_routes import event_bp

# import các blueprint khác nếu có

def register_routes(app):
    app.register_blueprint(user_bp)
    app.register_blueprint(bill_bp)
    app.register_blueprint(wallet_bp)
    app.register_blueprint(category_bp)
    app.register_blueprint(transaction_bp)
    app.register_blueprint(budget_bp)
    app.register_blueprint(repeat_option_bp)
    app.register_blueprint(recurring_transaction_bp)
    app.register_blueprint(event_bp)
