import 'package:flutter/material.dart';

class RecommendationWidget extends StatelessWidget {
  final String category;
  const RecommendationWidget({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    String recommendation;
    IconData icon;
    Color bgColor;

    if (category == "Real News") {
      recommendation =
          "This content appears credible. Still verify important claims independently.";
      icon = Icons.check_circle_outline_rounded;
      bgColor = const Color(0xFF10B981);
    } else if (category == "Fake News") {
      recommendation =
          "High risk of misinformation. Verify with trusted sources before sharing.";
      icon = Icons.warning_rounded;
      bgColor = const Color(0xFFEF4444);
    } else {
      recommendation =
          "Questionable content. Cross-reference with multiple reliable sources.";
      icon = Icons.help_outline_rounded;
      bgColor = const Color(0xFFF59E0B);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: bgColor.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bgColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: bgColor, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Recommendation",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: bgColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  recommendation,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}