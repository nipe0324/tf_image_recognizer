# =======================================
# TensorFlow
# =======================================
import tensorflow as tf
import numpy as np

import sys
sys.path.append('./../recognizer')
import model

# TODO: launch recognizer
# input_data = tf.placeholder(tf.string)
# decoded = tf.image.decode_jpeg(input_data, channels=3)
# resized = tf.image.resize_images(decoded, 64, 64)
# inputs = tf.expand_dims(tf.image.per_image_whitening(decoded), 0)
# logits = model.inference(decoded)
# softmax = tf.nn.softmax(logits)

# variable_averages = tf.train.ExponentialMovingAverage(model.MOVING_AVERAGE_DECAY)
# variables_to_restore = variable_averages.variables_to_restore()
# saver = tf.train.Saver(variables_to_restore)
# ckpt = tf.train.get_checkpoint_state('/tmp/my_model_train')
# saver.restore(sess, ckpt.model_checkpoint_path)

# =======================================
# Flask app
# =======================================

from flask import Flask, jsonify, render_template, request, redirect, url_for
import numpy as np
import json
import base64

app = Flask(__name__)

@app.route('/')
def index():
    title = "ようこそ"
    return render_template('index.html', title=title)

@app.route('/api', methods=['POST'])
def api():
    # TODO: return predicted label
    # results = []
    # ops = softmax
    # image = request.form.getlist('image')
    # output = sess.run(ops, feed_dict={input_data: base64.b64decode(image.split(',')[1])})
    return jsonify(results='test')

if __name__ == '__main__':
    app.debug = True
    app.run(host='0.0.0.0')

