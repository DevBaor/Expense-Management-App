from flask import Blueprint, request, jsonify
from app.models.event import Event, db
from app.schemas.event_schema import EventSchema
import uuid
from datetime import datetime
def parse_datetime(dt_str):
    if dt_str is None:
        return None
    try:
        return datetime.fromisoformat(dt_str)
    except ValueError:
        return None
event_bp = Blueprint('event_bp', __name__)
event_schema = EventSchema()
events_schema = EventSchema(many=True)

@event_bp.route('/events', methods=['POST'])
def create_event():
    data = request.json
    end_date = parse_datetime(data.get('end_date'))
    new_event = Event(
        id=data.get('id') or str(uuid.uuid4()),
        user_id=data['user_id'],
        name=data.get('name'),
        icon_path=data.get('icon_path'),
        end_date=end_date,
        wallet_id=data.get('wallet_id'),
        is_finished=data.get('is_finished', 0),
        spent=data.get('spent', 0),
        finished_by_hand=data.get('finished_by_hand', 0),
        autofinish=data.get('autofinish', 0),
        transaction_id_list=data.get('transaction_id_list')
    )
    db.session.add(new_event)
    db.session.commit()
    return event_schema.jsonify(new_event), 201

@event_bp.route('/events', methods=['GET'])
def get_events():
    events = Event.query.all()
    return events_schema.jsonify(events), 200

@event_bp.route('/events/<string:event_id>', methods=['GET'])
def get_event(event_id):
    event = Event.query.get_or_404(event_id)
    return event_schema.jsonify(event), 200

@event_bp.route('/events/<string:event_id>', methods=['PUT'])
def update_event(event_id):
    event = Event.query.get_or_404(event_id)
    data = request.json
    event.user_id = data.get('user_id', event.user_id)
    event.name = data.get('name', event.name)
    event.icon_path = data.get('icon_path', event.icon_path)
    event.end_date = data.get('end_date', event.end_date)
    event.wallet_id = data.get('wallet_id', event.wallet_id)
    event.is_finished = data.get('is_finished', event.is_finished)
    event.spent = data.get('spent', event.spent)
    event.finished_by_hand = data.get('finished_by_hand', event.finished_by_hand)
    event.autofinish = data.get('autofinish', event.autofinish)
    event.transaction_id_list = data.get('transaction_id_list', event.transaction_id_list)
    db.session.commit()
    return event_schema.jsonify(event), 200

@event_bp.route('/events/<string:event_id>', methods=['DELETE'])
def delete_event(event_id):
    event = Event.query.get_or_404(event_id)
    db.session.delete(event)
    db.session.commit()
    return jsonify({'message': 'Event deleted'}), 200

@event_bp.route('/events/user/<string:user_id>', methods=['GET'])
def get_events_by_user(user_id):
    events = Event.query.filter_by(user_id=user_id).all()
    return events_schema.jsonify(events), 200
