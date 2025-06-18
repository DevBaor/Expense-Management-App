from flask import Blueprint, request, jsonify
from app.models.transaction import Transaction, db
from app.schemas.transaction_schema import TransactionSchema
import uuid
from datetime import datetime
transaction_bp = Blueprint('transaction_bp', __name__)
transaction_schema = TransactionSchema()
transactions_schema = TransactionSchema(many=True)

@transaction_bp.route('/transactions', methods=['POST'])
def create_transaction():
    data = request.json

    # Parse chuỗi date thành datetime nếu có
    date_str = data.get('date')
    date_obj = None
    if date_str:
        try:
            date_obj = datetime.fromisoformat(date_str)
        except ValueError:
            # Có thể log hoặc trả lỗi nếu định dạng không đúng
            return {"error": "Invalid date format"}, 400

    new_transaction = Transaction(
        id=data['id'],
        user_id=data['user_id'],
        amount=data.get('amount'),
        extra_amount_info=data.get('extra_amount_info'),
        date=date_obj,  # Truyền đối tượng datetime
        note=data.get('note'),
        currency_id=data.get('currency_id'),
        category_id=data.get('category_id'),
        budget_id=data.get('budget_id'),
        event_id=data.get('event_id'),
        bill_id=data.get('bill_id'),
        contact=data.get('contact'),
        wallet_id=data.get('wallet_id')
    )
    db.session.add(new_transaction)
    db.session.commit()
    return transaction_schema.jsonify(new_transaction), 201

@transaction_bp.route('/transactions', methods=['GET'])
def get_transactions():
    transactions = Transaction.query.all()
    return transactions_schema.jsonify(transactions), 200

@transaction_bp.route('/transactions/<string:transaction_id>', methods=['GET'])
def get_transaction(transaction_id):
    transaction = Transaction.query.get_or_404(transaction_id)
    return transaction_schema.jsonify(transaction), 200

@transaction_bp.route('/transactions/<string:transaction_id>', methods=['PUT'])
def update_transaction(transaction_id):
    transaction = Transaction.query.get_or_404(transaction_id)
    data = request.json

    if "date" in data and isinstance(data["date"], str):
        try:
            data["date"] = datetime.fromisoformat(data["date"])
        except ValueError:
            return jsonify({"error": "Ngày không đúng định dạng ISO"}), 400

    transaction.user_id = data.get('user_id', transaction.user_id)
    transaction.amount = data.get('amount', transaction.amount)
    transaction.extra_amount_info = data.get('extra_amount_info', transaction.extra_amount_info)
    transaction.date = data.get('date', transaction.date)
    transaction.note = data.get('note', transaction.note)
    transaction.currency_id = data.get('currency_id', transaction.currency_id)
    transaction.category_id = data.get('category_id', transaction.category_id)
    transaction.budget_id = data.get('budget_id', transaction.budget_id)
    transaction.event_id = data.get('event_id', transaction.event_id)
    transaction.bill_id = data.get('bill_id', transaction.bill_id)
    transaction.contact = data.get('contact', transaction.contact)
    transaction.wallet_id = data.get('wallet_id', transaction.wallet_id)

    db.session.commit()
    return transaction_schema.jsonify(transaction), 200

@transaction_bp.route('/transactions/<string:transaction_id>', methods=['DELETE'])
def delete_transaction(transaction_id):
    transaction = Transaction.query.get_or_404(transaction_id)
    db.session.delete(transaction)
    db.session.commit()
    return jsonify({'message': 'Transaction deleted'}), 200

@transaction_bp.route('/transactions/user/<string:user_id>', methods=['GET'])
def get_transactions_by_user(user_id):
    transactions = Transaction.query.filter_by(user_id=user_id).all()
    return transactions_schema.jsonify(transactions), 200
