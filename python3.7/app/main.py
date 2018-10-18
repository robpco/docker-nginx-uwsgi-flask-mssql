from flask import Flask
app = Flask(__name__)


@app.route("/")
def hello():
    return "Hello World from Python 3.7 Flask App in Docker container with \
     	     MS SQL Driver, uWSGI and Nginx"


if __name__ == "__main__":
    app.run(host='0.0.0.0', debug=True, port=80)
