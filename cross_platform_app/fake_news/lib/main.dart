import 'package:fake_news/screens/fake_news_page.dart';
import 'package:flutter/material.dart';
import 'services/fake_news_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final fakeNewsService = FakeNewsService();
  await fakeNewsService.init();
  runApp(MyApp(service: fakeNewsService));
}

class MyApp extends StatelessWidget {
  final FakeNewsService service;

  const MyApp({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fake News Detector',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Inter',
        useMaterial3: true,
      ),
      home: FakeNewsPage(service: service),
    );
  }
}
