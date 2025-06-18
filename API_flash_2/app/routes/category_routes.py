from flask import Blueprint, request, jsonify
from app.models.category import Category, db
from app.schemas.category_schema import CategorySchema
import uuid

category_bp = Blueprint('category_bp', __name__)
category_schema = CategorySchema()
categories_schema = CategorySchema(many=True)

@category_bp.route('/categories', methods=['POST'])
def create_category():
    data = request.json
    new_category = Category(
        id=data['id'],
        user_id=data['user_id'],
        name=data.get('name'),
        type=data.get('type'),
        icon_id=data.get('icon_id')
    )
    db.session.add(new_category)
    db.session.commit()
    return category_schema.jsonify(new_category), 201

@category_bp.route('/categories', methods=['GET'])
def get_categories():
    categories = Category.query.all()
    return categories_schema.jsonify(categories), 200

@category_bp.route('/categories/<string:category_id>', methods=['GET'])
def get_category(category_id):
    category = Category.query.get_or_404(category_id)
    return category_schema.jsonify(category), 200

@category_bp.route('/categories/<string:category_id>', methods=['PUT'])
def update_category(category_id):
    category = Category.query.get_or_404(category_id)
    data = request.json
    category.user_id = data.get('user_id', category.user_id)
    category.name = data.get('name', category.name)
    category.type = data.get('type', category.type)
    category.icon_id = data.get('icon_id', category.icon_id)
    db.session.commit()
    return category_schema.jsonify(category), 200

@category_bp.route('/categories/<string:category_id>', methods=['DELETE'])
def delete_category(category_id):
    category = Category.query.get_or_404(category_id)
    db.session.delete(category)
    db.session.commit()
    return jsonify({'message': 'Category deleted'}), 200
@category_bp.route('/categories/user/<string:user_id>', methods=['GET'])
def get_categories_by_user(user_id):
    categories = Category.query.filter_by(user_id=user_id).all()
    return categories_schema.jsonify(categories), 200
