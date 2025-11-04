import 'package:flutter/material.dart';

class FakeNewsHeader extends StatelessWidget {
  const FakeNewsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          child: const Column(
            children: [
              Text(
                "🔍 Analyze News Articles",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Detect misinformation using AI-powered analysis",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white70,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}