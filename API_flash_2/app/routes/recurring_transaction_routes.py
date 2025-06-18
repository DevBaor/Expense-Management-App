from flask import Blueprint, request, jsonify
from app.models.recurring_transaction import RecurringTransaction, db
from app.schemas.recurring_transaction_schema import RecurringTransactionSchema
import uuid
recurring_transaction_bp = Blueprint('recurring_transaction_bp', __name__)
recurring_transaction_schema = RecurringTransactionSchema()
recurring_transactions_schema = RecurringTransactionSchema(many=True)

@recurring_transaction_bp.route('/recurring_transactions', methods=['POST'])
def create_recurring_transaction():
    data = request.json
    new_recurring_transaction = RecurringTransaction(
        id=data['id'],
        user_id=data['user_id'],
        amount=data.get('amount'),
        extra_amount_info=data.get('extra_amount_info'),
        start_date=data.get('start_date'),
        note=data.get('note'),
        currency_id=data.get('currency_id'),
        category_id=data.get('category_id'),
        wallet_id=data.get('wallet_id'),
        repeat_option_id=data.get('repeat_option_id'),
        is_finished=data.get('is_finished', 0),
        transaction_ids=data.get('transaction_ids')
    )
    db.session.add(new_recurring_transaction)
    db.session.commit()
    return recurring_transaction_schema.jsonify(new_recurring_transaction), 201

@recurring_transaction_bp.route('/recurring_transactions', methods=['GET'])
def get_recurring_transactions():
    recurring_transactions = RecurringTransaction.query.all()
    return recurring_transactions_schema.jsonify(recurring_transactions), 200

@recurring_transaction_bp.route('/recurring_transactions/<string:recurring_transaction_id>', methods=['GET'])
def get_recurring_transaction(recurring_transaction_id):
    recurring_transaction = RecurringTransaction.query.get_or_404(recurring_transaction_id)
    return recurring_transaction_schema.jsonify(recurring_transaction), 200

@recurring_transaction_bp.route('/recurring_transactions/<string:recurring_transaction_id>', methods=['PUT'])
def update_recurring_transaction(recurring_transaction_id):
    recurring_transaction = RecurringTransaction.query.get_or_404(recurring_transaction_id)
    data = request.json
    recurring_transaction.user_id = data.get('user_id', recurring_transaction.user_id)
    recurring_transaction.amount = data.get('amount', recurring_transaction.amount)
    recurring_transaction.extra_amount_info = data.get('extra_amount_info', recurring_transaction.extra_amount_info)
    recurring_transaction.start_date = data.get('start_date', recurring_transaction.start_date)
    recurring_transaction.note = data.get('note', recurring_transaction.note)
    recurring_transaction.currency_id = data.get('currency_id', recurring_transaction.currency_id)
    recurring_transaction.category_id = data.get('category_id', recurring_transaction.category_id)
    recurring_transaction.wallet_id = data.get('wallet_id', recurring_transaction.wallet_id)
    recurring_transaction.repeat_option_id = data.get('repeat_option_id', recurring_transaction.repeat_option_id)
    recurring_transaction.is_finished = data.get('is_finished', recurring_transaction.is_finished)
    recurring_transaction.transaction_ids = data.get('transaction_ids', recurring_transaction.transaction_ids)
    db.session.commit()
    return recurring_transaction_schema.jsonify(recurring_transaction), 200

@recurring_transaction_bp.route('/recurring_transactions/<string:recurring_transaction_id>', methods=['DELETE'])
def delete_recurring_transaction(recurring_transaction_id):
    recurring_transaction = RecurringTransaction.query.get_or_404(recurring_transaction_id)
    db.session.delete(recurring_transaction)
    db.session.commit()
    return jsonify({'message': 'RecurringTransaction deleted'}), 200
