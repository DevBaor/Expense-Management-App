from app.extensions import db

class Event(db.Model):
    __tablename__ = 'Events'

    id = db.Column(db.String, primary_key=True)
    user_id = db.Column(db.String, db.ForeignKey('Users.id'), nullable=False)
    name = db.Column(db.String)
    icon_path = db.Column(db.String)
    end_date = db.Column(db.DateTime)
    wallet_id = db.Column(db.String, db.ForeignKey('Wallets.id'))
    is_finished = db.Column(db.Integer)
    spent = db.Column(db.Numeric(15, 2))
    finished_by_hand = db.Column(db.Integer)
    autofinish = db.Column(db.Integer)
    transaction_id_list = db.Column(db.Text)
