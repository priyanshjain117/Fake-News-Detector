from flask import Flask, request, jsonify
from newspaper import Article

app = Flask(__name__)

@app.route('/extract', methods=['POST'])
def extract():
    try:
        data = request.get_json()
        url = data.get('url')
        if not url:
            return jsonify({'error': 'No URL provided'}), 400
        
        article = Article(url)
        article.download()
        article.parse()

        return jsonify({
            'title': article.title,
            'content': article.text
        })

    except Exception as e:
        return jsonify({'error': str(e)}), 500


if __name__ == '__main__':
    app.run(debug=True)
