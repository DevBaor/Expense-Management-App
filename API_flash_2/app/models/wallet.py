from app.extensions import db

class Wallet(db.Model):
    __tablename__ = 'Wallets'

    id = db.Column(db.String, primary_key=True)
    user_id = db.Column(db.String, db.ForeignKey('Users.id'), nullable=False)
    name = db.Column(db.String, nullable=False)
    amount = db.Column(db.Numeric(18, 2), nullable=False)
    currency_id = db.Column(db.String, nullable=False)
    icon_id = db.Column(db.String, nullable=False)
