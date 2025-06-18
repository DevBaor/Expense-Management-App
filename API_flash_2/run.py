from app import create_app
from app.models import db
from app.extensions import db
from app.models.bill import Bill
from app.models.budget import Budget
from app.models.repeat_option import RepeatOption
from app.models.category import Category
from app.models.user import User
from app.models.transaction import Transaction
from app.models.wallet import Wallet
from app.models.event import Event
from app.models.recurring_transaction import RecurringTransaction
from flask_cors import CORS
from flask import Flask, render_template
from flask import send_from_directory
import os

app = create_app()

CORS(app)
# Tạo database và các bảng nếu chưa có
with app.app_context():
    db.create_all()

if __name__ == '__main__':
    app.run(debug=True)