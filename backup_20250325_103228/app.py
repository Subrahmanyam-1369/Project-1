from flask import Flask
app = Flask(__name__)

@app.route('/')
def home():
    return "Hello, Deployment System is Working!"

if __name__ == '__main__':
    app.run(port=3000)
