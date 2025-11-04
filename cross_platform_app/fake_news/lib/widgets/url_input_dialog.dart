import 'dart:convert';
import 'package:fake_news/secret/backend_web.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UrlInputDialog extends StatefulWidget {
  final TextEditingController mainTextController;

  const UrlInputDialog({
    super.key,
    required this.mainTextController,
  });

  @override
  State<UrlInputDialog> createState() => _UrlInputDialogState();
}

class _UrlInputDialogState extends State<UrlInputDialog> {
  final TextEditingController _urlController = TextEditingController();
  bool _isLoading = false;
  String? _errorText;

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _fetchAndLoadContent() async {
    String url = _urlController.text.trim();
    
    // 1. Validate URL
    if (Uri.tryParse(url)?.hasAbsolutePath != true) {
      setState(() {
        _errorText = "Please enter a valid URL";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    try {
      final response = await http.post(
        Uri.parse(EXTRACT_API),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"url": url}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.containsKey("content")) {
          widget.mainTextController.text = data["content"];
        
          if (mounted) {
            Navigator.pop(context); 
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Content loaded successfully ✅"),
                backgroundColor: Colors.green,
              ),
            );
          }
        } else {
          throw Exception("No content found in response");
        }
      } else {
        throw Exception("Failed to fetch article content (Status: ${response.statusCode})");
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: const Row(
        children: [
          Icon(Icons.link),
          SizedBox(width: 8),
          Text("Enter News URL"),
        ],
      ),
      content: TextField(
        controller: _urlController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: "https://example.com/news-article",
          border: const OutlineInputBorder(),
          errorText: _errorText, 
        ),
        keyboardType: TextInputType.url,
        onSubmitted: (_) => _fetchAndLoadContent(), 
      ),
      actions: [
        TextButton(
          child: const Text("Cancel"),
          onPressed: _isLoading ? null : () => Navigator.pop(context),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _fetchAndLoadContent,
          child: _isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Colors.white, 
                  ),
                )
              : const Text("Fetch"),
        ),
      ],
    );
  }
}