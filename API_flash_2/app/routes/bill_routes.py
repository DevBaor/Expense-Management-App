from flask import Blueprint, request, jsonify
from ..models.bill import Bill, db
from ..schemas.bill_schema import BillSchema
import uuid

bill_bp = Blueprint('bill_bp', __name__)

bill_schema = BillSchema()
bills_schema = BillSchema(many=True)

@bill_bp.route('/bills', methods=['POST'])
def create_bill():
    data = request.json
    new_bill = Bill(
        id=data['id'],
        user_id=data['user_id'],
        category_id=data.get('category_id'),
        amount=data.get('amount'),
        note=data.get('note'),
        wallet_id=data.get('wallet_id'),
        repeat_option_id=data.get('repeat_option_id'),
        is_finished=data.get('is_finished', 0),
        due_dates=data.get('due_dates'),
        paid_due_dates=data.get('paid_due_dates'),
        transaction_ids=data.get('transaction_ids')
    )
    db.session.add(new_bill)
    db.session.commit()
    return bill_schema.jsonify(new_bill), 201

@bill_bp.route('/bills', methods=['GET'])
def get_bills():
    bills = Bill.query.all()
    return bills_schema.jsonify(bills), 200

@bill_bp.route('/bills/<string:bill_id>', methods=['GET'])
def get_bill(bill_id):
    bill = Bill.query.get_or_404(bill_id)
    return bill_schema.jsonify(bill), 200

@bill_bp.route('/bills/<string:bill_id>', methods=['PUT'])
def update_bill(bill_id):
    bill = Bill.query.get_or_404(bill_id)
    data = request.json
    bill.user_id = data.get('user_id', bill.user_id)
    bill.category_id = data.get('category_id', bill.category_id)
    bill.amount = data.get('amount', bill.amount)
    bill.note = data.get('note', bill.note)
    bill.wallet_id = data.get('wallet_id', bill.wallet_id)
    bill.repeat_option_id = data.get('repeat_option_id', bill.repeat_option_id)
    bill.is_finished = data.get('is_finished', bill.is_finished)
    bill.due_dates = data.get('due_dates', bill.due_dates)
    bill.paid_due_dates = data.get('paid_due_dates', bill.paid_due_dates)
    bill.transaction_ids = data.get('transaction_ids', bill.transaction_ids)
    db.session.commit()
    return bill_schema.jsonify(bill), 200

@bill_bp.route('/bills/<string:bill_id>', methods=['DELETE'])
def delete_bill(bill_id):
    bill = Bill.query.get_or_404(bill_id)
    db.session.delete(bill)
    db.session.commit()
    return jsonify({'message': 'Bill deleted'}), 200
