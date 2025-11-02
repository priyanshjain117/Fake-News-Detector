```markdown
# 📰 Fake News Detector App

An intelligent **Fake News Detection System** that leverages **Machine Learning** (Logistic Regression + TF-IDF) to classify news headlines or articles as **Real**, **Fake**, or **Questionable**. Built with **Flutter** for the frontend and **TensorFlow Lite** for secure, offline on-device inference.

---

## 🚀 Features

- 🔍 **Real-time Fake News Detection** — Enter any headline or article and get instant results.
- 🤖 **On-device ML** — Runs a pre-trained Logistic Regression model with TFLite, ensuring privacy and quick inference.
- 🧠 **TF-IDF Vectorization** — Transforms text input into numerical vectors for precise classification.
- 📱 **Flutter UI** — Clean, responsive, modern mobile design.
- ⚡ **Offline Prediction** — Works without internet after the first setup.
- 🧾 **Three Output Categories**:
  - ✅ Real
  - ❌ Fake
  - ❓ Questionable (for uncertainty)

---

## 🧩 Tech Stack

| Layer         | Technology Used     | Description                                  |
| ------------- | ------------------ | --------------------------------------------- |
| **ML Model**  | Logistic Regression| Classifies news as fake/real                  |
| **Text Processing** | TF-IDF Vectorizer | Converts input to feature vectors          |
| **Framework** | TensorFlow Lite    | On-device ML inference                        |
| **Frontend**  | Flutter            | Cross-platform mobile UI framework            |
| **Language**  | Dart, Python       | Dart (UI), Python (Model training)            |

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
│   │ Logistic Regression │
│   └─────────────────────┘   │
│              │               │
│              ▼               │
│     Prediction Result        │
│  (Real / Fake / Questionable)│
└─────────────────────────────┘
```

---

## 🧠 Model Training (Python)

1. **Dataset:** News samples labeled as real or fake.  
2. **Steps:**
   ```
   from sklearn.feature_extraction.text import TfidfVectorizer
   from sklearn.linear_model import LogisticRegression
   import joblib

   vectorizer = TfidfVectorizer(max_features=5000)
   X = vectorizer.fit_transform(news_data['text'])
   y = news_data['label']

   model = LogisticRegression()
   model.fit(X, y)

   joblib.dump(model, 'model.pkl')
   joblib.dump(vectorizer.vocabulary_, 'vocab.pkl')
   ```
3. **Convert to TensorFlow Lite:**
   - Export via ONNX or direct pipeline to `.tflite`  
   - Place `model.tflite` and `vocab.json` in your Flutter app’s `/assets/` folder

---

## 📲 Flutter App Integration

1. **Add TFLite plugin:**
   ```
   dependencies:
     tflite_flutter: ^0.10.4
   ```
2. **Load model and vocab:**
   ```
   final interpreter = await Interpreter.fromAsset('model.tflite');
   final vocab = await loadVocab('assets/vocab.json');
   ```
3. **Preprocess text** with TF-IDF logic.  
4. **Run inference** via the TFLite interpreter.  
5. **Display results** in a color-coded, responsive UI.

---

## 🖼️ Screenshots

| Home Screen                        | Result - Real                      | Result - Fake                      |
| ----------------------------------  | ---------------------------------- | ---------------------------------- |
| ![Home](assets/screenshots/home.png)| ![Real](assets/screenshots/real.png)| ![Fake](assets/screenshots/fake.png)|

---

## 🧪 Example Input & Output

| Input                                           | Predicted Label   |
| ------------------------------------------------| ----------------- |
| "NASA confirms water on the moon!"              | ✅ Real           |
| "Celebrity endorses miracle cure for COVID-19"  | ❌ Fake           |
| "Experts debate impact of new economic policy"  | ❓ Questionable   |

---

## 🛠️ Setup Instructions

### 1️⃣ Clone the Repository
```
git clone https://github.com/yourusername/fake_news_detector.git
cd fake_news_detector
```
### 2️⃣ Install Dependencies
```
flutter pub get
```
### 3️⃣ Add Assets

Place trained model and vocab inside:
```
assets/
 ├── model.tflite
 └── vocab.json
```
### 4️⃣ Update pubspec.yaml
```
flutter:
  assets:
    - assets/model.tflite
    - assets/vocab.json
```
### 5️⃣ Run the App
```
flutter run
```

---

## 📚 Future Enhancements

- 🌐 Web & Desktop support (TensorFlow.js / TFLite web)  
- 🗣️ Voice input for audio-based detection  
- 📊 Visualization of prediction confidence score  
- 🔎 Live news API integration  

---

## 👨‍💻 Author

**Priyanshu** — Machine Learning & Flutter Developer  
📧 [your.email@example.com](mailto:your.email@example.com)  
💻 [github.com/yourusername](https://github.com/yourusername)  

---

## 🏁 License

Licensed under the **MIT License** — free to use, modify, and distribute.

---

> ⚡ *"Fight misinformation with machine intelligence."*
```

