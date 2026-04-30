from flask import Flask, jsonify

app = Flask(__name__)

APP_VERSION = os.getenv("VERSION", "1.0")  
@app.route("/")
def home():
 return f"Welcome to ACEest Fitness & Gym - Version {APP_VERSION}"

@app.route("/version")
def version():
    return jsonify({"version": APP_VERSION})

@app.route("/members")
def members():
    return jsonify({
        "version": APP_VERSION,
        "members": [
            {"id": 1, "name": "Rahul", "plan": "Monthly"},
            {"id": 2, "name": "Anita", "plan": "Quarterly"}
        ]
    })

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
