from flask import Blueprint, request, jsonify
from ..models.wallet import Wallet, db
from ..schemas.wallet_schema import WalletSchema

wallet_bp = Blueprint('wallet_bp', __name__)
wallet_schema = WalletSchema()
wallets_schema = WalletSchema(many=True)

@wallet_bp.route('/wallets', methods=['POST'])
def create_wallet():
    data = request.json
    new_wallet = Wallet(
        id=data['id'],
        user_id=data['user_id'],
        name=data['name'],
        amount=data['amount'],
        currency_id=data['currency_id'],
        icon_id=data['icon_id']
    )
    db.session.add(new_wallet)
    db.session.commit()
    return wallet_schema.jsonify(new_wallet), 201

@wallet_bp.route('/wallets', methods=['GET'])
def get_wallets():
    wallets = Wallet.query.all()
    return wallets_schema.jsonify(wallets), 200

@wallet_bp.route('/wallets/<string:wallet_id>', methods=['GET'])
def get_wallet(wallet_id):
    wallet = Wallet.query.get_or_404(wallet_id)
    return wallet_schema.jsonify(wallet), 200

@wallet_bp.route('/wallets/<string:wallet_id>', methods=['PUT'])
def update_wallet(wallet_id):
    wallet = Wallet.query.get_or_404(wallet_id)
    data = request.json
    wallet.user_id = data.get('user_id', wallet.user_id)
    wallet.name = data.get('name', wallet.name)
    wallet.amount = data.get('amount', wallet.amount)
    wallet.currency_id = data.get('currency_id', wallet.currency_id)
    wallet.icon_id = data.get('icon_id', wallet.icon_id)
    db.session.commit()
    return wallet_schema.jsonify(wallet), 200

@wallet_bp.route('/wallets/<string:wallet_id>', methods=['DELETE'])
def delete_wallet(wallet_id):
    wallet = Wallet.query.get_or_404(wallet_id)
    db.session.delete(wallet)
    db.session.commit()
    return jsonify({'message': 'Wallet deleted'}), 200

@wallet_bp.route('/wallets/user/<string:user_id>', methods=['GET'])
def get_wallets_by_user(user_id):
    wallets = Wallet.query.filter_by(user_id=user_id).all()
    return wallets_schema.jsonify(wallets), 200
