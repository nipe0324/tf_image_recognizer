# =======================================
# TensorFlow
# =======================================
import tensorflow as tf
import numpy as np

import sys
sys.path.append('./../recognizer')
import model

# =======================================
# Flask app
# =======================================

from flask import Flask, jsonify, render_template, request, redirect, url_for
import numpy as np

app = Flask(__name__)

@app.route('/')
def index():
    title = "ようこそ"
    return render_template('index.html', title=title)

if __name__ == '__main__':
    app.debug = True
    app.run(host='0.0.0.0')
