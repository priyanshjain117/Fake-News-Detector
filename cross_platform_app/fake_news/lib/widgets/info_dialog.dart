import 'package:flutter/material.dart';

class InfoDialog extends StatelessWidget {
  const InfoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF667EEA).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.info_rounded,
              color: Color(0xFF667EEA),
            ),
          ),
          const SizedBox(width: 12),
          const Text("About This App"),
        ],
      ),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "This app uses AI-powered machine learning to analyze news content and detect potential misinformation.",
            style: TextStyle(height: 1.5),
          ),
          SizedBox(height: 12),
          Text(
            "How it works:",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text("• Analyzes text patterns and language"),
          Text("• Checks for emotional manipulation"),
          Text("• Evaluates source credibility"),
          Text("• Provides confidence scores"),
          SizedBox(height: 12),
          Text(
            "⚠️ Always verify important news with multiple trusted sources.",
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.orange,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Got it"),
        ),
      ],
    );
  }
}