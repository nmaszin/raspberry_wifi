from flask import Flask, abort
import wifi

INTERFACE = 'wlp3s0'
PORT = 9997


app = Flask(__name__)

@app.route('/', methods=['GET'])
def list_available_networks():
    networks = wifi.get_available_networks(INTERFACE)

    return {
        'networks': networks
    }

@app.route('/', methods=['POST'])
def connect_to_network():
    ssid = request.form['ssid']
    password = request.form['password']

    if wifi.try_to_connect(ssid, password):
        return {
            'message': 'Successfully connected'
        }
    else:
        return abort(400, {
            'message': 'Could not connect'
        })



def main():
    app.run(host='0.0.0.0', port=PORT)

if __name__ == '__main__':
    main()

