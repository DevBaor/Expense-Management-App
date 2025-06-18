from flask import Blueprint, request, jsonify
from app.models.repeat_option import RepeatOption, db
from app.schemas.repeat_option_schema import RepeatOptionSchema
import uuid
repeat_option_bp = Blueprint('repeat_option_bp', __name__)
repeat_option_schema = RepeatOptionSchema()
repeat_options_schema = RepeatOptionSchema(many=True)

@repeat_option_bp.route('/repeat_options', methods=['POST'])
def create_repeat_option():
    data = request.json
    new_repeat_option = RepeatOption(
        id=data['id'],
        name=data.get('name'),
        value=data.get('value'),
        label=data.get('label'),
        key=data.get('key'),
        unit=data.get('unit'),
        time=data.get('time')
    )
    db.session.add(new_repeat_option)
    db.session.commit()
    return repeat_option_schema.jsonify(new_repeat_option), 201

@repeat_option_bp.route('/repeat_options', methods=['GET'])
def get_repeat_options():
    repeat_options = RepeatOption.query.all()
    return repeat_options_schema.jsonify(repeat_options), 200

@repeat_option_bp.route('/repeat_options/<string:repeat_option_id>', methods=['GET'])
def get_repeat_option(repeat_option_id):
    repeat_option = RepeatOption.query.get_or_404(repeat_option_id)
    return repeat_option_schema.jsonify(repeat_option), 200

@repeat_option_bp.route('/repeat_options/<string:repeat_option_id>', methods=['PUT'])
def update_repeat_option(repeat_option_id):
    repeat_option = RepeatOption.query.get_or_404(repeat_option_id)
    data = request.json
    repeat_option.name = data.get('name', repeat_option.name)
    repeat_option.value = data.get('value', repeat_option.value)
    repeat_option.label = data.get('label', repeat_option.label)
    repeat_option.key = data.get('key', repeat_option.key)
    repeat_option.unit = data.get('unit', repeat_option.unit)
    repeat_option.time = data.get('time', repeat_option.time)
    db.session.commit()
    return repeat_option_schema.jsonify(repeat_option), 200

@repeat_option_bp.route('/repeat_options/<string:repeat_option_id>', methods=['DELETE'])
def delete_repeat_option(repeat_option_id):
    repeat_option = RepeatOption.query.get_or_404(repeat_option_id)
    db.session.delete(repeat_option)
    db.session.commit()
    return jsonify({'message': 'RepeatOption deleted'}), 200