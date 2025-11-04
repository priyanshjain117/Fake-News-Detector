import 'package:flutter/material.dart';

class FakeNewsAppBar extends StatelessWidget {
  final VoidCallback onInfoPressed;

  const FakeNewsAppBar({super.key, required this.onInfoPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.newspaper_outlined,
              color: Color.fromARGB(255, 18, 20, 30),
              size: 25,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              "Fake News Detector",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 25,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),
          IconButton(
            onPressed: onInfoPressed,
            icon: const Icon(Icons.info_outline, color: Colors.white),
          ),
        ],
      ),
    );
  }
}