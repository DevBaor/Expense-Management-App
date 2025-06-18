from app.extensions import db

class RepeatOption(db.Model):
    __tablename__ = 'RepeatOptions'

    id = db.Column(db.String, primary_key=True)
    user_id = db.Column(db.String, db.ForeignKey('Users.id'), nullable=False)
    frequency = db.Column(db.String)
    range_amount = db.Column(db.Integer)
    extra_amount_info = db.Column(db.String)
    begin_datetime = db.Column(db.DateTime)
    type = db.Column(db.String)
    extra_type_info = db.Column(db.String)
