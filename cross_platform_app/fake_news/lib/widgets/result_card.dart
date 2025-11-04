import 'package:flutter/material.dart';
import 'package:fake_news/widgets/recommendation_widget.dart';

class ResultCard extends StatelessWidget {
  final Animation<Offset> slideAnimation;
  final Animation<double> pulseAnimation;
  final String category;
  final double confidence;
  final Color categoryColor;
  final IconData categoryIcon;

  const ResultCard({
    super.key,
    required this.slideAnimation,
    required this.pulseAnimation,
    required this.category,
    required this.confidence,
    required this.categoryColor,
    required this.categoryIcon,
  });

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: slideAnimation,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: categoryColor.withOpacity(0.3),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      categoryColor.withOpacity(0.1),
                      categoryColor.withOpacity(0.05),
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: categoryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.analytics_rounded,
                        color: categoryColor,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        "Analysis Complete",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    ScaleTransition(
                      scale: pulseAnimation,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: categoryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: categoryColor.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              categoryIcon,
                              size: 64,
                              color: categoryColor,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              category,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: categoryColor,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: categoryColor.withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                "Confidence: ${confidence.toStringAsFixed(1)}%",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: categoryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Credibility Score",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                              Text(
                                "${confidence.toStringAsFixed(0)}%",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: categoryColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Stack(
                              children: [
                                Container(
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius:
                                        BorderRadius.circular(10),
                                  ),
                                ),
                                TweenAnimationBuilder<double>(
                                  duration:
                                      const Duration(milliseconds: 1200),
                                  curve: Curves.easeOutCubic,
                                  tween: Tween<double>(
                                    begin: 0,
                                    end: (confidence) / 100,
                                  ),
                                  builder: (context, value, child) {
                                    return FractionallySizedBox(
                                      widthFactor: value,
                                      child: Container(
                                        height: 12,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              categoryColor,
                                              categoryColor
                                                  .withOpacity(0.7),
                                            ],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color: categoryColor
                                                  .withOpacity(0.4),
                                              blurRadius: 8,
                                              offset:
                                                  const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              _buildScoreLabel("0%", Colors.grey),
                              _buildScoreLabel("50%", Colors.grey),
                              _buildScoreLabel("100%", Colors.grey),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    RecommendationWidget(category: category),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreLabel(String text, Color color) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        color: color,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}