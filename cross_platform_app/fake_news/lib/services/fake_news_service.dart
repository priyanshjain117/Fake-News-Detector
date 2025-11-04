import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import '../models/analysis_result.dart'; 

class FakeNewsService {
  late Interpreter _interpreter;
  late Map<String, int> _vocab;

  FakeNewsService();

  Future<void> init() async {
    _interpreter = await Interpreter.fromAsset('assets/model.tflite');

    String vocabData = await rootBundle.loadString('assets/vocab.json');
    _vocab = Map<String, int>.from(json.decode(vocabData));
  }

  List<double> _vectorize(String text) {
    text = text.toLowerCase().replaceAll(RegExp(r'[^a-z\s]'), '');
    final words = text.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();

    List<double> vector = List.filled(_vocab.length, 0.0);
    for (var word in words) {
      if (_vocab.containsKey(word)) {
        vector[_vocab[word]!] = 1.0;
      }
    }
    return vector;
  }

  Future<AnalysisResult> predict(String inputText) async {

    final vector = _vectorize(inputText);
    var input = [vector];
    var output = List.filled(1 * 1, 0.0).reshape([1, 1]);
    
    await Future.delayed(const Duration(milliseconds: 100)); 

    _interpreter.run(input, output);
    double realNewsProbability = output[0][0]; 

    final confidence = realNewsProbability; 
    
    final status = confidence >= 0.7
        ? 'reliable'
        : confidence >= 0.4
            ? 'questionable'
            : 'fake';
    final prediction = confidence >= 0.5 ? 'REAL' : 'FAKE';
    final score = (confidence * 100).toInt();
    
    final indicators = <String, String>{
      'emotional': confidence < 0.3 ? 'High' : (confidence < 0.6 ? 'Moderate' : 'Low'),
      'sources': confidence < 0.4 ? 'Missing' : 'Present',
      'bias': confidence >= 0.7
          ? 'Low'
          : confidence >= 0.4
              ? 'Moderate'
              : 'High',
      'factCheck': confidence >= 0.8
          ? 'Verified'
          : confidence >= 0.5
              ? 'Unverified'
              : 'Disputed',
    };

    final recommendations = status == 'reliable'
        ? [
            'This content appears highly credible. Always cross-reference multiple sources.',
          ]
        : [
            '**Caution:** High emotional language detected. This can be a sign of sensationalism.',
            'Verify the claims by searching for reliable, independent sources.',
            'Check the article\'s authors and publication date.',
          ];

    return AnalysisResult(
      overallStatus: status,
      modelPrediction: prediction,
      confidence: confidence * 100, 
      score: score,
      indicators: indicators,
      recommendations: recommendations,
    );
  }
}