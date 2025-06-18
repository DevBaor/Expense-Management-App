from flask import Blueprint, request, jsonify
from ..models.user import User, db
from ..schemas.user_schema import UserSchema


user_bp = Blueprint('user_bp', __name__)
user_schema = UserSchema()
users_schema = UserSchema(many=True)

@user_bp.route('/users', methods=['POST'])
def create_user():
    data = request.json
    new_user = User(
        id=data['id'],
        username=data.get('username'),
        current_wallet_id=data.get('current_wallet_id')
    )
    db.session.add(new_user)
    db.session.commit()
    return user_schema.jsonify(new_user), 201

@user_bp.route('/users', methods=['GET'])
def get_users():
    users = User.query.all()
    return users_schema.jsonify(users), 200

@user_bp.route('/users/<string:user_id>', methods=['GET'])
def get_user(user_id):
    user = User.query.get_or_404(user_id)
    return user_schema.jsonify(user), 200

@user_bp.route('/users/<string:user_id>', methods=['PUT'])
def update_user(user_id):
    user = User.query.get_or_404(user_id)
    data = request.json
    user.username = data.get('username', user.username)
    user.current_wallet_id = data.get('current_wallet_id', user.current_wallet_id)
    db.session.commit()
    return user_schema.jsonify(user), 200

@user_bp.route('/users/<string:user_id>', methods=['DELETE'])
def delete_user(user_id):
    user = User.query.get_or_404(user_id)
    db.session.delete(user)
    db.session.commit()
    return jsonify({'message': 'User deleted'}), 200
