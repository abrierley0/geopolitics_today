import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ArticleDetailScreen extends StatelessWidget {
  final String title;
  final String category;
  final String heroImageUrl;
  final List<Map<String, dynamic>> blocks;

  const ArticleDetailScreen({
    super.key,
    required this.title,
    required this.category,
    required this.heroImageUrl,
    required this.blocks,
  });

  @override
  Widget build(BuildContext context) {
    // Only show text blocks, skip image blocks for now
    final textBlocks = blocks.where((b) => b['type'] == 'text').toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Category
            if (category.isNotEmpty)
              Text(
                category.toUpperCase(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                  color: Colors.blue,
                ),
              ),

            SizedBox(height: 10),

            // Title
            Text(
              title,
              style: GoogleFonts.playfairDisplay(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                height: 1.3,
                color: Colors.black,
              ),
            ),

            SizedBox(height: 16),
            Divider(color: Colors.grey[200]),
            SizedBox(height: 16),

            // --- Text blocks only ---
            ...textBlocks.map((block) => Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text(
                block['value'] ?? '',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 17,
                  height: 1.75,
                  color: Color(0xFF2C2C2C),
                ),
              ),
            )),

          ],
        ),
      ),
    );
  }
}