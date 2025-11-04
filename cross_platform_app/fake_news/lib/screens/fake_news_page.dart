import 'package:flutter/material.dart';
import 'package:fake_news/services/fake_news_service.dart';

import 'package:fake_news/widgets/app_bar.dart';
import 'package:fake_news/widgets/header.dart';
import 'package:fake_news/widgets/input_card.dart';
import 'package:fake_news/widgets/result_section.dart';
import 'package:fake_news/widgets/info_dialog.dart';

class FakeNewsPage extends StatefulWidget {
  final FakeNewsService service;
  const FakeNewsPage({super.key, required this.service});

  @override
  State<FakeNewsPage> createState() => _FakeNewsPageState();
}

class _FakeNewsPageState extends State<FakeNewsPage>
    with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  String? _category;
  double? _confidence;
  bool _loading = false;
  late AnimationController _pulseController;
  late AnimationController _slideController;
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _slideController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _predict() async {
    FocusScope.of(context).unfocus();
    final text = _controller.text.trim();
    if (text.isEmpty) {
      _showSnackBar('Please enter some text to analyze', Colors.orange);
      return;
    }

    setState(() {
      _loading = true;
      _category = null;
      _confidence = null;
    });

    try {
      final prob = await widget.service.predict(text);
      final conf = prob.confidence;

      String category;
      if (conf > 60) {
        category = "Real News";
      } else if (conf < 40) {
        category = "Fake News";
      } else {
        category = "Questionable News";
      }

      await Future.delayed(const Duration(milliseconds: 600));

      setState(() {
        _category = category;
        _confidence = conf;
        _loading = false;
      });

      _slideController.forward(from: 0);
    } catch (e) {
      setState(() => _loading = false);
      _showSnackBar('Error analyzing text. Please try again.', Colors.red);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Color _getCategoryColor() {
    if (_category == "Real News") return const Color(0xFF10B981);
    if (_category == "Fake News") return const Color(0xFFEF4444);
    return const Color(0xFFF59E0B);
  }

  IconData _getCategoryIcon() {
    if (_category == "Real News") return Icons.verified_rounded;
    if (_category == "Fake News") return Icons.dangerous_rounded;
    return Icons.help_rounded;
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => const InfoDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final padding = isTablet ? 32.0 : 16.0;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/newspaper_wallpaper.jpg"),
            fit: BoxFit.cover,
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF667EEA),
              const Color(0xFF764BA2),
              const Color(0xFFF093FB),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Use the new AppBar widget
              FakeNewsAppBar(onInfoPressed: _showInfoDialog),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.all(padding),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: isTablet ? 700 : double.infinity,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Use the new Header widget
                          const FakeNewsHeader(),
                          const SizedBox(height: 24),
                          
                          // Use the new Input Card widget
                          FakeNewsInputCard(
                            controller: _controller,
                            loading: _loading,
                            onAnalyze: _predict,
                          ),
                          const SizedBox(height: 24),

                          // Use the new Result Section widget
                          ResultSection(
                            loading: _loading,
                            category: _category,
                            confidence: _confidence,
                            slideAnimation: _slideAnimation,
                            pulseAnimation: _pulseAnimation,
                            categoryColor: _getCategoryColor(),
                            categoryIcon: _getCategoryIcon(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}