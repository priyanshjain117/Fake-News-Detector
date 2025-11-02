# 📰 Fake News Detector App

An intelligent **Fake News Detection System** that uses **Machine Learning** (Logistic Regression + TF-IDF) to classify news headlines or articles as **Real**, **Fake**, or **Questionable**.  
Built with **Flutter** for the front-end and **TensorFlow Lite (TFLite)** for on-device inference — ensuring privacy, speed, and offline capability.

---

## 🚀 Features

- 🔍 **Real-time Fake News Detection** — Enter a news headline or paragraph and get instant classification.
- 🤖 **On-device Machine Learning** — Uses a pre-trained Logistic Regression model converted to TFLite format.
- 🧠 **TF-IDF Vectorization** — Converts text input into numerical vectors for model prediction.
- 📱 **Flutter UI** — Clean, responsive, and mobile-friendly design.
- ⚡ **Offline Prediction** — No internet needed after model deployment.
- 🧾 **Three Output Categories**
  - ✅ Real
  - ❌ Fake
  - ❓ Questionable (Uncertain cases)

---

## 🧩 Tech Stack

| Layer | Technology Used | Description |
|-------|------------------|-------------|
| **ML Model** | Logistic Regression | Trained to classify fake vs real news |
| **Text Processing** | TF-IDF Vectorizer | Converts text into feature vectors |
| **Framework** | TensorFlow Lite | For running ML model on-device |
| **Frontend** | Flutter | Cross-platform mobile UI |
| **Language** | Dart, Python | Dart (App), Python (Model Training) |

---

## ⚙️ Architecture

```

┌─────────────────────────────┐
│         Flutter App         │
│   ┌─────────────────────┐   │
│   │ User enters text    │   │
│   └─────────────────────┘   │
│              │               │
│              ▼               │
│   ┌─────────────────────┐   │
│   │ TF-IDF + TFLite     │ ← Pre-trained ML model
│   │ Logistic Regression  │
│   └─────────────────────┘   │
│              │               │
│              ▼               │
│     Prediction Result        │
│  (Real / Fake / Questionable)│
└─────────────────────────────┘

````

---

## 🧠 Model Training (Python)

1. **Dataset**: News dataset with labeled `real` and `fake` samples.
2. **Steps**:
   ```python
   from sklearn.feature_extraction.text import TfidfVectorizer
   from sklearn.linear_model import LogisticRegression
   import joblib

   # Load and preprocess dataset
   vectorizer = TfidfVectorizer(max_features=5000)
   X = vectorizer.fit_transform(news_data['text'])
   y = news_data['label']

   # Train model
   model = LogisticRegression()
   model.fit(X, y)

   # Save model and vocab
   joblib.dump(model, 'model.pkl')
   joblib.dump(vectorizer.vocabulary_, 'vocab.pkl')
````

3. **Convert to TensorFlow Lite**:

   * Export the model to ONNX or use a conversion pipeline to get `.tflite`
   * Place `model.tflite` and `vocab.json` in your Flutter app’s `/assets/` folder.

---

## 📲 Flutter App Integration

1. Add TFLite Flutter plugin:

   ```yaml
   dependencies:
     tflite_flutter: ^0.10.4
   ```

2. Load model and vocab:

   ```dart
   final interpreter = await Interpreter.fromAsset('model.tflite');
   final vocab = await loadVocab('assets/vocab.json');
   ```

3. Preprocess text using TF-IDF logic (same tokenization).

4. Run inference using the interpreter.

5. Display result with color-coded UI.

---

## 🖼️ Screenshots

| Home Screen                          | Result - Real                        | Result - Fake                        |
| ------------------------------------ | ------------------------------------ | ------------------------------------ |
| ![Home](assets/screenshots/home.png) | ![Real](assets/screenshots/real.png) | ![Fake](assets/screenshots/fake.png) |

---

## 🧪 Example Input & Output

| Input                                          | Predicted Label |
| ---------------------------------------------- | --------------- |
| "NASA confirms water on the moon!"             | ✅ Real          |
| "Celebrity endorses miracle cure for COVID-19" | ❌ Fake          |
| "Experts debate impact of new economic policy" | ❓ Questionable  |

---

## 🛠️ Setup Instructions

### 1️⃣ Clone the Repository

```bash
git clone https://github.com/yourusername/fake_news_detector.git
cd fake_news_detector
```

### 2️⃣ Install Dependencies

```bash
flutter pub get
```

### 3️⃣ Add Assets

Place your trained `model.tflite` and `vocab.json` inside:

```
assets/
 ├── model.tflite
 └── vocab.json
```

### 4️⃣ Update pubspec.yaml

```yaml
flutter:
  assets:
    - assets/model.tflite
    - assets/vocab.json
```

### 5️⃣ Run App

```bash
flutter run
```

---

## 📚 Future Enhancements

* 🌐 Web & Desktop Support (using TensorFlow.js or TFLite web)
* 🗣️ Voice Input for detecting fake news from speech
* 📊 Confidence Score Visualization
* 🔎 Integration with live news APIs

---

## 👨‍💻 Authors

**Priyanshu** — Machine Learning & Flutter Developer
📧 Contact: [[your.email@example.com](mailto:your.email@example.com)]
💻 GitHub: [github.com/yourusername](https://github.com/yourusername)

---

## 🏁 License

This project is licensed under the **MIT License** — feel free to use, modify, and distribute it.

---

> ⚡ *"Fight misinformation with machine intelligence."*

```

---
