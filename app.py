from flask import Flask, jsonify

app = Flask(__name__)

@app.route("/")
def home():
    return "Welcome to ACEest Fitness & Gym"

@app.route("/members")
def members():
    return jsonify({
        "members": [
            {"id": 1, "name": "Rahul", "plan": "Monthly"},
            {"id": 2, "name": "Anita", "plan": "Quarterly"}
        ]
    })

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
