from app.extensions import db

class Budget(db.Model):
    __tablename__ = 'Budgets'

    id = db.Column(db.String, primary_key=True)
    user_id = db.Column(db.String, db.ForeignKey('Users.id'), nullable=False)
    category_id = db.Column(db.String, db.ForeignKey('Categories.id'))
    amount = db.Column(db.Numeric(15, 2))
    spent = db.Column(db.Numeric(15, 2))
    wallet_id = db.Column(db.String, db.ForeignKey('Wallets.id'))
    is_finished = db.Column(db.Integer)
    begin_date = db.Column(db.DateTime)
    end_date = db.Column(db.DateTime)
    is_repeat = db.Column(db.Integer)
    label = db.Column(db.String)
