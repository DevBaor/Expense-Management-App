from app.extensions import db

class Transaction(db.Model):
    __tablename__ = 'Transactions'

    id = db.Column(db.String, primary_key=True)
    user_id = db.Column(db.String, db.ForeignKey('Users.id'), nullable=False)
    amount = db.Column(db.Numeric(15, 2))
    extra_amount_info = db.Column(db.Numeric(15, 2))
    date = db.Column(db.DateTime)
    note = db.Column(db.Text)
    currency_id = db.Column(db.String)
    category_id = db.Column(db.String, db.ForeignKey('Categories.id'))
    budget_id = db.Column(db.String, db.ForeignKey('Budgets.id'))
    event_id = db.Column(db.String, db.ForeignKey('Events.id'))
    bill_id = db.Column(db.String, db.ForeignKey('Bills.id'))
    contact = db.Column(db.String)
    wallet_id = db.Column(db.String, db.ForeignKey('Wallets.id'))
