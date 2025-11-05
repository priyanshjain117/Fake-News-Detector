import 'package:fake_news/widgets/url_input_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FakeNewsInputCard extends StatelessWidget {
  final TextEditingController controller;
  final bool loading;
  final VoidCallback onAnalyze;

  FakeNewsInputCard({
    super.key,
    required this.controller,
    required this.loading,
    required this.onAnalyze,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF667EEA).withOpacity(0.1),
                    const Color(0xFF764BA2).withOpacity(0.1),
                  ],
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF667EEA).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.edit_note_rounded,
                      color: Color.fromARGB(255, 18, 20, 30),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Enter News Content",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    tooltip: "Fetch from URL",
                    icon: const Icon(Icons.link_rounded,
                        color: Color(0xFF4B69D6)),
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      bool isLoggedIn=FirebaseAuth.instance.currentUser != null;
                      if (isLoggedIn) {
                        await showDialog(
                          context: context,
                          builder: (context) {
                            return UrlInputDialog(
                              mainTextController: controller,
                            );
                          },
                        );
                      } else {
                        Navigator.of(context).pushNamed('/login');
                      }
                    },
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  TextField(
                    controller: controller,
                    maxLines: 8,
                    style: const TextStyle(fontSize: 15, height: 1.5),
                    decoration: InputDecoration(
                      hintText:
                          "Paste the news article, or any text you want to verify...",
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF9FAFB),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 118, 112, 112),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(119, 26, 32, 59),
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                  const SizedBox(height: 20),

                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: loading ? null : onAnalyze,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(214, 75, 99, 218),
                        foregroundColor: Colors.white,
                        elevation: 8,
                        shadowColor: const Color(0xFF667EEA).withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        disabledBackgroundColor: Colors.grey[300],
                      ),
                      child: loading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.search_rounded, size: 24),
                                SizedBox(width: 8),
                                Text(
                                  "Analyze Content",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
