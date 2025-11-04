import 'package:flutter/material.dart';
import 'package:fake_news/widgets/result_card.dart';

class ResultSection extends StatelessWidget {
  final bool loading;
  final String? category;
  final double? confidence;
  final Animation<Offset> slideAnimation;
  final Animation<double> pulseAnimation;
  final Color categoryColor;
  final IconData categoryIcon;

  const ResultSection({
    super.key,
    required this.loading,
    this.category,
    this.confidence,
    required this.slideAnimation,
    required this.pulseAnimation,
    required this.categoryColor,
    required this.categoryIcon,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      switchInCurve: Curves.easeOutBack,
      switchOutCurve: Curves.easeInBack,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.2),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: loading
          ? const LoadingWidget()
          : category != null
              ? ResultCard(
                  key: ValueKey(category),
                  slideAnimation: slideAnimation,
                  pulseAnimation: pulseAnimation,
                  category: category!,
                  confidence: confidence!,
                  categoryColor: categoryColor,
                  categoryIcon: categoryIcon,
                )
              : const EmptyStateWidget(),
    );
  }
}

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('empty'),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.article_outlined,
            size: 64,
            color: Colors.white.withOpacity(0.7),
          ),
          const SizedBox(height: 16),
          Text(
            "Ready to Analyze",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Enter news content above to get started",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('loading'),
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  strokeWidth: 6,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    const Color(0xFF667EEA),
                  ),
                ),
              ),
              const Icon(
                Icons.analytics_rounded,
                size: 40,
                color: Color(0xFF667EEA),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            "Analyzing Content...",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Using AI to detect misinformation",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}