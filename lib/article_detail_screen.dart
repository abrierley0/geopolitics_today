import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ArticleDetailScreen extends StatelessWidget {
  final String title;
  final String category;
  final String heroImageUrl;
  final List<Map<String, dynamic>> blocks;
  final DateTime? publishedAt;

  const ArticleDetailScreen({
    super.key,
    required this.title,
    required this.category,
    required this.heroImageUrl,
    required this.blocks,
    this.publishedAt,
  });

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
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

            SizedBox(height: 10),

            // Date
            if (publishedAt != null)
              Text(
                _formatDate(publishedAt!),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                  letterSpacing: 0.3,
                ),
              ),

            SizedBox(height: 16),
            Divider(color: Colors.grey[200]),
            SizedBox(height: 16),

            // --- Square image below title ---
            if (heroImageUrl.isNotEmpty)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 280,
                    height: 280,
                    child: Image.network(
                      heroImageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(color: Colors.grey[200]),
                    ),
                  ),
                ),
              ),

            SizedBox(height: heroImageUrl.isNotEmpty ? 20 : 0),

            // --- Text blocks ---
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