from app.extensions import db

class User(db.Model):
    __tablename__ = 'Users'

    id = db.Column(db.String, primary_key=True)
    username = db.Column(db.String)
    current_wallet_id = db.Column(db.String)
