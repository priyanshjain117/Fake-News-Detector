import streamlit as st
import pickle
import re
import os
from datetime import datetime

# -------------------------------------------------
# 🔹 Page Configuration
# -------------------------------------------------
st.set_page_config(
    page_title="Fake News Detector",
    page_icon="🛡️",
    layout="wide",
    initial_sidebar_state="collapsed"
)

# -------------------------------------------------
# 🔹 Custom CSS
# -------------------------------------------------
st.markdown("""
    <style>
    .main {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    }
    .stApp {
        background: linear-gradient(to bottom right, #EBF4FF, #E8F5E9);
    }
    .big-font {
        font-size: 50px !important;
        font-weight: bold;
        text-align: center;
        color: #1E3A8A;
    }
    .result-card {
        padding: 20px;
        border-radius: 10px;
        margin: 10px 0;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    }
    .reliable {
        background-color: #D1FAE5;
        border-left: 5px solid #10B981;
    }
    .questionable {
        background-color: #FEF3C7;
        border-left: 5px solid #F59E0B;
    }
    .unreliable {
        background-color: #FEE2E2;
        border-left: 5px solid #EF4444;
    }
    .indicator-box {
        padding: 15px;
        border-radius: 8px;
        background-color: white;
        margin: 10px 0;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
    }
    .metric-card {
        background: white;
        padding: 20px;
        border-radius: 10px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        text-align: center;
    }
    </style>
""", unsafe_allow_html=True)

# -------------------------------------------------
# 🔹 Load Model and Vectorizer
# -------------------------------------------------
@st.cache_resource
def load_models():
    """Load model and vectorizer with error handling"""
    try:
        # Try different possible locations
        model_path = 'model.pkl'
        vectorizer_path = 'vectorizer.pkl'
        
        if not os.path.exists(model_path):
            st.error("❌ model.pkl not found!")
            return None, None
        
        if not os.path.exists(vectorizer_path):
            if os.path.exists('vectoriser.pkl'):
                vectorizer_path = 'vectoriser.pkl'
            else:
                st.error("❌ vectorizer.pkl not found!")
                return None, None
        
        with open(model_path, 'rb') as f:
            model = pickle.load(f)
        
        with open(vectorizer_path, 'rb') as f:
            vectorizer = pickle.load(f)
        
        # Verify vectorizer is fitted
        if not hasattr(vectorizer, 'vocabulary_'):
            st.error("❌ Vectorizer is not fitted!")
            return None, None
        
        st.success("✅ Models loaded successfully!")
        return model, vectorizer
        
    except Exception as e:
        st.error(f"❌ Error loading models: {str(e)}")
        return None, None

model, vectorizer = load_models()

# -------------------------------------------------
# 🔹 Text Cleaning Function
# -------------------------------------------------
def clean_text(text):
    """Clean text for model prediction"""
    text = text.lower()
    text = re.sub(r'http\S+|www\S+', '', text)
    text = re.sub(r'<.*?>', '', text)
    text = re.sub(r'[^a-z\s]', '', text)
    text = re.sub(r'\s+', ' ', text).strip()
    return text

# -------------------------------------------------
# 🔹 Text Analysis Function
# -------------------------------------------------
def analyze_text_indicators(text):
    """Analyze text for fake news indicators"""
    clickbait_patterns = r'shocking|unbelievable|you won\'t believe|doctors hate|one trick|breaking|urgent|must see'
    has_clickbait = bool(re.search(clickbait_patterns, text, re.IGNORECASE))
    
    exclamations = len(re.findall(r'!', text))
    has_exclamations = exclamations > 3
    
    has_capitals = bool(re.search(r'\b[A-Z]{4,}\b', text))
    
    source_patterns = r'according to|study shows|research|source:|reported by|says|claims'
    has_sources = bool(re.search(source_patterns, text, re.IGNORECASE))
    
    return {
        'has_clickbait': has_clickbait,
        'has_exclamations': has_exclamations,
        'has_capitals': has_capitals,
        'has_sources': has_sources
    }

# -------------------------------------------------
# 🔹 Prediction Function
# -------------------------------------------------
def predict_news(text):
    """Predict if news is fake or real"""
    if model is None or vectorizer is None:
        return None
    
    try:
        # Clean text
        cleaned_text = clean_text(text)
        
        # Transform text
        vect_text = vectorizer.transform([cleaned_text])
        
        # Predict
        proba = model.predict_proba(vect_text)[0]
        prediction = model.predict(vect_text)[0]
        
        prob_fake = float(proba[0] * 100)
        prob_real = float(proba[1] * 100)
        
        # Analyze indicators
        indicators_data = analyze_text_indicators(text)
        
        # Calculate credibility score
        credibility_score = int(prob_real)
        
        if indicators_data['has_clickbait']:
            credibility_score = max(0, credibility_score - 15)
        if indicators_data['has_exclamations']:
            credibility_score = max(0, credibility_score - 10)
        if indicators_data['has_capitals']:
            credibility_score = max(0, credibility_score - 5)
        if indicators_data['has_sources']:
            credibility_score = min(100, credibility_score + 10)
        
        # Determine status
        if credibility_score >= 70:
            status = 'reliable'
        elif credibility_score >= 40:
            status = 'questionable'
        else:
            status = 'unreliable'
        
        # Build indicators
        indicators = {
            'emotional': 'High' if (indicators_data['has_clickbait'] or indicators_data['has_exclamations']) else 'Low',
            'sources': 'Present' if indicators_data['has_sources'] else 'Missing',
            'bias': 'High' if credibility_score < 50 else 'Moderate' if credibility_score < 70 else 'Low',
            'factCheck': 'Verified' if credibility_score > 70 else 'Unverified' if credibility_score > 40 else 'Disputed'
        }
        
        # Build recommendations
        if status == 'unreliable':
            recommendations = [
                '⚠️ Verify this information with trusted news sources',
                '🔍 Look for original sources and citations',
                '📰 Check if other reputable outlets are reporting this story',
                '🚫 Be extremely cautious before sharing this content'
            ]
        elif status == 'questionable':
            recommendations = [
                '🔄 Cross-reference with multiple reliable sources',
                '👨‍🔬 Look for expert opinions on this topic',
                '⏸️ Be cautious about sharing until verified',
                '📅 Check the publication date and author credentials'
            ]
        else:
            recommendations = [
                '✅ This content appears credible based on initial analysis',
                '🔎 Still recommended to verify important claims independently',
                '📆 Check publication date for currency of information',
                '⚖️ Consider the source reputation and bias'
            ]
        
        return {
            'score': credibility_score,
            'status': status,
            'indicators': indicators,
            'recommendations': recommendations,
            'model_prediction': 'REAL' if prediction == 1 else 'FAKE',
            'confidence_real': round(prob_real, 2),
            'confidence_fake': round(prob_fake, 2)
        }
        
    except Exception as e:
        st.error(f"Error in prediction: {str(e)}")
        return None

# -------------------------------------------------
# 🔹 Main App
# -------------------------------------------------
def main():
    # Header
    st.markdown('<p class="big-font">🛡️ Fake News Detector</p>', unsafe_allow_html=True)
    st.markdown("<h3 style='text-align: center; color: #6B7280;'>Analyze news articles and detect potential misinformation</h3>", unsafe_allow_html=True)
    
    st.markdown("---")
    
    # Check if models are loaded
    if model is None or vectorizer is None:
        st.error("⚠️ Models not loaded. Please check the model files.")
        st.stop()
    
    # Sidebar
    with st.sidebar:
        st.header("ℹ️ About")
        st.info("""
        This tool uses machine learning to analyze news articles and detect potential fake news.
        
        **How it works:**
        1. Enter news article text
        2. AI analyzes the content
        3. Get credibility score and recommendations
        
        **Note:** Always verify important news with multiple trusted sources.
        """)
        
        st.header("📊 Statistics")
        if 'total_checks' not in st.session_state:
            st.session_state.total_checks = 0
        st.metric("Total Checks", st.session_state.total_checks)
    
    # Main input area
    col1, col2, col3 = st.columns([1, 3, 1])
    
    with col2:
        st.markdown("### 📝 Enter News Article")
        news_text = st.text_area(
            "Paste the news article or headline here:",
            height=200,
            placeholder="Enter the news article text, headline, or content you want to verify...",
            help="Paste the full article or at least a substantial excerpt for better accuracy"
        )
        
        col_btn1, col_btn2, col_btn3 = st.columns([1, 1, 1])
        with col_btn2:
            analyze_button = st.button("🔍 Analyze Content", use_container_width=True, type="primary")
        
        if analyze_button:
            if not news_text.strip():
                st.warning("⚠️ Please enter some text to analyze.")
            else:
                st.session_state.total_checks += 1
                
                with st.spinner("🔄 Analyzing content..."):
                    result = predict_news(news_text)
                
                if result:
                    # Display results
                    st.markdown("---")
                    st.markdown("## 📊 Analysis Results")
                    
                    # Status card
                    status_class = result['status']
                    status_emoji = "✅" if status_class == 'reliable' else "⚠️" if status_class == 'questionable' else "❌"
                    
                    st.markdown(f"""
                        <div class="result-card {status_class}">
                            <h2 style="text-align: center;">{status_emoji} Status: {result['status'].upper()}</h2>
                        </div>
                    """, unsafe_allow_html=True)
                    
                    # Main metrics
                    metric_col1, metric_col2, metric_col3 = st.columns(3)
                    
                    with metric_col1:
                        st.markdown(f"""
                            <div class="metric-card">
                                <h3>Credibility Score</h3>
                                <h1 style="color: {'#10B981' if result['score'] >= 70 else '#F59E0B' if result['score'] >= 40 else '#EF4444'};">
                                    {result['score']}/100
                                </h1>
                            </div>
                        """, unsafe_allow_html=True)
                    
                    with metric_col2:
                        pred_color = "#10B981" if result['model_prediction'] == 'REAL' else "#EF4444"
                        st.markdown(f"""
                            <div class="metric-card">
                                <h3>Model Prediction</h3>
                                <h1 style="color: {pred_color};">
                                    {result['model_prediction']}
                                </h1>
                            </div>
                        """, unsafe_allow_html=True)
                    
                    with metric_col3:
                        confidence = result['confidence_real'] if result['model_prediction'] == 'REAL' else result['confidence_fake']
                        st.markdown(f"""
                            <div class="metric-card">
                                <h3>Confidence</h3>
                                <h1 style="color: #6366F1;">
                                    {confidence:.1f}%
                                </h1>
                            </div>
                        """, unsafe_allow_html=True)
                    
                    st.markdown("---")
                    
                    # Indicators
                    st.markdown("### 🔍 Content Indicators")
                    
                    ind_col1, ind_col2 = st.columns(2)
                    
                    with ind_col1:
                        st.markdown(f"""
                            <div class="indicator-box">
                                <h4>😱 Emotional Language</h4>
                                <p style="font-size: 24px; font-weight: bold; color: {'#EF4444' if result['indicators']['emotional'] == 'High' else '#10B981'};">
                                    {result['indicators']['emotional']}
                                </p>
                            </div>
                        """, unsafe_allow_html=True)
                        
                        st.markdown(f"""
                            <div class="indicator-box">
                                <h4>⚖️ Bias Detection</h4>
                                <p style="font-size: 24px; font-weight: bold; color: {'#10B981' if result['indicators']['bias'] == 'Low' else '#F59E0B' if result['indicators']['bias'] == 'Moderate' else '#EF4444'};">
                                    {result['indicators']['bias']}
                                </p>
                            </div>
                        """, unsafe_allow_html=True)
                    
                    with ind_col2:
                        st.markdown(f"""
                            <div class="indicator-box">
                                <h4>📚 Source Citations</h4>
                                <p style="font-size: 24px; font-weight: bold; color: {'#10B981' if result['indicators']['sources'] == 'Present' else '#EF4444'};">
                                    {result['indicators']['sources']}
                                </p>
                            </div>
                        """, unsafe_allow_html=True)
                        
                        st.markdown(f"""
                            <div class="indicator-box">
                                <h4>✔️ Fact Check Status</h4>
                                <p style="font-size: 24px; font-weight: bold; color: {'#10B981' if result['indicators']['factCheck'] == 'Verified' else '#F59E0B' if result['indicators']['factCheck'] == 'Unverified' else '#EF4444'};">
                                    {result['indicators']['factCheck']}
                                </p>
                            </div>
                        """, unsafe_allow_html=True)
                    
                    # Recommendations
                    st.markdown("---")
                    st.markdown("### 💡 Recommendations")
                    
                    for rec in result['recommendations']:
                        st.markdown(f"- {rec}")
                    
                    # Download report
                    st.markdown("---")
                    report_data = f"""
FAKE NEWS DETECTION REPORT
Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}

STATUS: {result['status'].upper()}
CREDIBILITY SCORE: {result['score']}/100
MODEL PREDICTION: {result['model_prediction']}
CONFIDENCE: {confidence:.1f}%

INDICATORS:
- Emotional Language: {result['indicators']['emotional']}
- Source Citations: {result['indicators']['sources']}
- Bias Detection: {result['indicators']['bias']}
- Fact Check Status: {result['indicators']['factCheck']}

RECOMMENDATIONS:
{chr(10).join(['- ' + rec for rec in result['recommendations']])}

ANALYZED TEXT:
{news_text[:500]}...
"""
                    st.download_button(
                        label="📥 Download Report",
                        data=report_data,
                        file_name=f"fake_news_report_{datetime.now().strftime('%Y%m%d_%H%M%S')}.txt",
                        mime="text/plain"
                    )

    # Footer
    st.markdown("---")
    st.markdown("""
        <div style='text-align: center; color: #6B7280; padding: 20px;'>
            <p>⚠️ This is a demonstration tool. Always verify important news with multiple trusted sources.</p>
            <p style='font-size: 12px;'>Powered by Machine Learning | Built with Streamlit</p>
        </div>
    """, unsafe_allow_html=True)

if __name__ == '__main__':
    main()