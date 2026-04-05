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
    // If heroImageUrl exists, prepend it as first image block
    final allBlocks = heroImageUrl.isNotEmpty
        ? [{'type': 'image', 'value': heroImageUrl}, ...blocks]
        : blocks;

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

            // --- Blocks ---
            ...allBlocks.map((block) {
              if (block['type'] == 'image') {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      block['value'] ?? '',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(
                        height: 200,
                        color: Colors.grey[200],
                      ),
                    ),
                  ),
                );
              } else {
                return Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Text(
                    block['value'] ?? '',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 17,
                      height: 1.75,
                      color: Color(0xFF2C2C2C),
                    ),
                  ),
                );
              }
            }),

          ],
        ),
      ),
    );
  }
}