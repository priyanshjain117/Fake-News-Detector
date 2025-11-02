import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression
import pickle
import re

# -------------------------------------------------
# 1. Create Mock Training Data (Replace with your actual data)
# -------------------------------------------------
data = {
    'text': [
        "Major breakthrough in renewable energy reported by scientists.", # Real (1)
        "You won't believe what these doctors discovered, shocking!",    # Fake (0)
        "The President signs a new bill into law today.",               # Real (1)
        "URGENT: Global warming is a hoax, experts claim.",             # Fake (0)
        "A detailed analysis of the stock market performance this week.", # Real (1)
        "MUST SEE PHOTOS of celebrity scandal, EXPOSED!",               # Fake (0)
    ],
    'label': [1, 0, 1, 0, 1, 0]
}
df = pd.DataFrame(data)
X = df['text']
y = df['label']

# -------------------------------------------------
# 2. Preprocessing Function (Must match your Flask app)
# -------------------------------------------------
def clean_text(text):
    text = text.lower()
    text = re.sub(r'http\S+|www\S+', '', text)     # remove URLs
    text = re.sub(r'<.*?>', '', text)              # remove HTML tags
    text = re.sub(r'[^a-z\s]', '', text)           # remove punctuation and digits
    text = re.sub(r'\s+', ' ', text).strip()       # remove extra spaces
    return text

X_cleaned = X.apply(clean_text)

# -------------------------------------------------
# 3. FIT the Vectorizer and Transform Data
# -------------------------------------------------
# This is the CRITICAL STEP: .fit() calculates the IDF values
vectorizer = TfidfVectorizer()
X_vectorized = vectorizer.fit_transform(X_cleaned)

print("TfidfVectorizer fitted successfully.")
print(f"Vocabulary size: {len(vectorizer.vocabulary_)}")

# -------------------------------------------------
# 4. Train the Model
# -------------------------------------------------
model = LogisticRegression(random_state=42)
model.fit(X_vectorized, y)

print("Model trained successfully.")

# -------------------------------------------------
# 5. SAVE the FITTED Vectorizer and Model
# -------------------------------------------------
# You MUST save the fitted 'vectorizer' object, not an unfitted one.
# These files must be placed alongside your Flask app in deployment.
try:
    with open('vectorizer_ver2.pkl', 'wb') as f:
        pickle.dump(vectorizer, f)
    print("Fitted vectorizer saved to 'vectorizer_ver2.pkl'")

    with open('model.pkl', 'wb') as f:
        pickle.dump(model, f)
    print("Trained model saved to 'model.pkl'")

except Exception as e:
    print(f"Error saving files: {e}")

# -------------------------------------------------
# 6. Verification (Testing the loading process)
# -------------------------------------------------
print("\n--- Verification Test ---")
loaded_vectorizer = pickle.load(open('vectorizer_ver2.pkl', 'rb'))
loaded_model = pickle.load(open('model.pkl', 'rb'))

test_text = "This story is true and verifiable."
test_cleaned = clean_text(test_text)

# The loaded vectorizer can now successfully TRANSFORM new data
test_vectorized = loaded_vectorizer.transform([test_cleaned]) 

print(f"Test text transformed successfully. Shape: {test_vectorized.shape}")

prediction = loaded_model.predict(test_vectorized)[0]
proba = loaded_model.predict_proba(test_vectorized)[0]

print(f"Prediction (0=Fake, 1=Real): {prediction}")
print(f"Confidence (Fake/Real): {proba}")
