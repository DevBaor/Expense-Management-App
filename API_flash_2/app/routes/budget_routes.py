from flask import Blueprint, request, jsonify
from app.models.budget import Budget, db
from app.schemas.budget_schema import BudgetSchema
from datetime import datetime
budget_bp = Blueprint('budget_bp', __name__)
budget_schema = BudgetSchema()
budgets_schema = BudgetSchema(many=True)

@budget_bp.route('/budgets', methods=['POST'])
def create_budget():
    data = request.json
    begin_date = datetime.fromisoformat(data['begin_date']) if data.get('begin_date') else None
    end_date = datetime.fromisoformat(data['end_date']) if data.get('end_date') else None
    new_budget = Budget(
        id=data['id'],
        user_id=data['user_id'],
        category_id=data.get('category_id'),
        amount=data.get('amount'),
        spent=data.get('spent'),
        wallet_id=data.get('wallet_id'),
        is_finished=data.get('is_finished', 0),
        begin_date=begin_date,
        end_date=end_date,
        is_repeat=data.get('is_repeat', 0),
        label=data.get('label')
    )
    db.session.add(new_budget)
    db.session.commit()
    return budget_schema.jsonify(new_budget), 201

@budget_bp.route('/budgets', methods=['GET'])
def get_budgets():
    budgets = Budget.query.all()
    return budgets_schema.jsonify(budgets), 200

@budget_bp.route('/budgets/<string:budget_id>', methods=['GET'])
def get_budget(budget_id):
    budget = Budget.query.get_or_404(budget_id)
    return budget_schema.jsonify(budget), 200
@budget_bp.route('/budgets/<string:budget_id>', methods=['PUT'])
def update_budget(budget_id):
    budget = Budget.query.get_or_404(budget_id)
    data = request.json

    budget.user_id = data.get('user_id', budget.user_id)
    budget.category_id = data.get('category_id', budget.category_id)

    # Ép kiểu an toàn
    if 'amount' in data:
        budget.amount = float(data['amount'])
    if 'spent' in data:
        budget.spent = float(data['spent'])
    if 'is_finished' in data:
        budget.is_finished = int(data['is_finished'])  # đảm bảo là 0 hoặc 1

    budget.wallet_id = data.get('wallet_id', budget.wallet_id)
    budget.begin_date = data.get('begin_date', budget.begin_date)
    budget.end_date = data.get('end_date', budget.end_date)
    budget.is_repeat = data.get('is_repeat', budget.is_repeat)
    budget.label = data.get('label', budget.label)

    db.session.commit()
    return budget_schema.jsonify(budget), 200


@budget_bp.route('/budgets/<string:budget_id>', methods=['DELETE'])
def delete_budget(budget_id):
    budget = Budget.query.get_or_404(budget_id)
    db.session.delete(budget)
    db.session.commit()
    return jsonify({'message': 'Budget deleted'}), 200
@budget_bp.route('/budgets/user/<string:user_id>', methods=['GET'])
def get_budgets_by_user(user_id):
    budgets = Budget.query.filter_by(user_id=user_id).all()
    now = datetime.now()
    for budget in budgets:
        if budget.end_date and budget.end_date < now and not budget.is_finished:
            budget.is_finished = 1
    db.session.commit()
    return budgets_schema.jsonify(budgets), 200
@budget_bp.route('/budgets/category/<string:category_id>', methods=['GET'])
def get_budgets_by_category(category_id):
    budgets = Budget.query.filter_by(category_id=category_id).all()
    return budgets_schema.jsonify(budgets), 200
