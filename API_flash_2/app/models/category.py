from app.extensions import db

class Category(db.Model):
    __tablename__ = 'Categories'

    id = db.Column(db.String, primary_key=True)
    user_id = db.Column(db.String, db.ForeignKey('Users.id'), nullable=False)
    name = db.Column(db.String)
    type = db.Column(db.String)
    icon_id = db.Column(db.String)
