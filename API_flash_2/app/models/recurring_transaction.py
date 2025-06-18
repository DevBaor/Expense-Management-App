from app.extensions import db

class RecurringTransaction(db.Model):
    __tablename__ = 'RecurringTransactions'

    id = db.Column(db.String, primary_key=True)
    user_id = db.Column(db.String, db.ForeignKey('Users.id'), nullable=False)
    category_id = db.Column(db.String, db.ForeignKey('Categories.id'))
    amount = db.Column(db.Numeric(18, 2))
    wallet_id = db.Column(db.String, db.ForeignKey('Wallets.id'))
    note = db.Column(db.Text)
    transaction_id_list = db.Column(db.Text)
    repeat_option_id = db.Column(db.String, db.ForeignKey('RepeatOptions.id'))
    is_finished = db.Column(db.Integer)
