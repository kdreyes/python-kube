from flask import Flask, jsonify
from datetime import datetime

app = Flask(__name__)

@app.route('/api/data', methods=['GET'])
def get_data():
    # Get the current timestamp
    current_time = datetime.now().isoformat()

    # Define a static message
    message = "Automate all the things!"

    # Create a JSON payload
    data = {
        "message": message,
        "timestamp": current_time
    }

    return jsonify(data)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
