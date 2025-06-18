from flask import Flask ,render_template
from .config import Config
from .extensions import db, ma
from .routes import register_routes 
from flask import send_from_directory
import os
def create_app():
    app = Flask(__name__)
    app.config.from_object(Config)

    db.init_app(app)
    ma.init_app(app)
    @app.route('/hotro')
    def hotro():
       return send_from_directory(os.path.join(app.root_path, 'templates'), 'hotro.html')
    register_routes(app)
    return app
