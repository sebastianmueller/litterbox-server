from flask import Flask
from flask import request
from flask import jsonify
import os
import socket
import json
import sys

app = Flask(__name__)
box = None

@app.route("/")
def hello():
    html = "<h3>Hello {name}!</h3>" \
           "<b>Hostname:</b> {hostname}<br/>"
    return html.format(name=os.getenv("NAME", "world"), hostname=socket.gethostname())

@app.route("/box/<boxID>/", methods=['GET', 'POST'])
def getOrRegisterBox(boxID):
    print >> sys.stderr, "getOrRegisterBox: request.is_json={}, request.method={}".format(request.is_json, request.method)
    if request.method == 'POST':
        if request.is_json:
            data = request.get_json()
            return jsonify(registerBox(boxID, data))
        else:
            return "Please send JSON (Content-Type: application/json)", 400
    else:
        return jsonify(getBox(boxID))

def registerBox(boxID, data):
    print >> sys.stderr, "registerBox {}: {}".format(boxID, data)
    global box
    box = data
    return box

def getBox(boxID):
    return box

        
if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8000)
