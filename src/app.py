from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello_world():
    return "<p>Hello, World!</p>"

def main():
    app.run(host="0.0.0.0")

if __name__ == '__main__':
    main()
