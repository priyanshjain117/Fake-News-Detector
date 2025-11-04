class AnalysisResult {
  final String overallStatus; // 'reliable', 'questionable', 'fake'
  final String modelPrediction; // 'REAL' or 'FAKE'
  final double confidence; // 0.0 to 1.0 (used to calculate confidence_real)
  final int score; // 0 to 100 for Credibility Score
  final Map<String, String> indicators;
  final List<String> recommendations;

  AnalysisResult({
    required this.overallStatus,
    required this.modelPrediction,
    required this.confidence,
    required this.score,
    required this.indicators,
    required this.recommendations,
  });

  static AnalysisResult generateDummyResult(double confidence) {
    final status = confidence >= 0.7
        ? 'reliable'
        : confidence >= 0.4
            ? 'questionable'
            : 'fake';
    final prediction = confidence >= 0.5 ? 'REAL' : 'FAKE';
    final score = (confidence * 100).toInt();

    final indicators = <String, String>{
      'emotional': confidence >= 0.6 ? 'Low' : 'High',
      'sources': confidence >= 0.8 ? 'Present' : 'Missing',
      'bias': confidence >= 0.7
          ? 'Low'
          : confidence >= 0.4
              ? 'Moderate'
              : 'High',
      'factCheck': confidence >= 0.7
          ? 'Verified'
          : confidence >= 0.4
              ? 'Unverified'
              : 'Disputed',
    };

    final recommendations = status == 'reliable'
        ? [
            'This content appears highly credible. Always cross-reference multiple sources.',
          ]
        : [
            'Look for original sources and author information.',
            'Cross-reference the main claims with established, reputable news organizations.',
            'Be wary of overly emotional or sensational language.',
          ];

    return AnalysisResult(
      overallStatus: status,
      modelPrediction: prediction,
      confidence: confidence * 100, // Stored as 0-100%
      score: score,
      indicators: indicators,
      recommendations: recommendations,
    );
  }
}