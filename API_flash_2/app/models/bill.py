from app.extensions import db

class Bill(db.Model):
    __tablename__ = 'Bills'

    id = db.Column(db.String, primary_key=True)
    user_id = db.Column(db.String, db.ForeignKey('Users.id'), nullable=False)
    category_id = db.Column(db.String, db.ForeignKey('Categories.id'))
    amount = db.Column(db.Numeric(15, 2))
    note = db.Column(db.Text)
    wallet_id = db.Column(db.String, db.ForeignKey('Wallets.id'))
    repeat_option_id = db.Column(db.String, db.ForeignKey('RepeatOptions.id'))
    is_finished = db.Column(db.Integer)
    due_dates = db.Column(db.Text)
    paid_due_dates = db.Column(db.Text)
    transaction_ids = db.Column(db.Text)
