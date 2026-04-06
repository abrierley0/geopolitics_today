import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'article_detail_screen.dart';

class RegionScreen extends StatelessWidget {
  final String region;

  const RegionScreen({super.key, required this.region});

  String formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  void _openArticle(BuildContext context, dynamic article) {
    final rawBlocks = article['blocks'];
    List<Map<String, dynamic>> blocks = [];

    if (rawBlocks != null && rawBlocks is List) {
      blocks = rawBlocks.map((b) {
        if (b is Map) return Map<String, dynamic>.from(b);
        return <String, dynamic>{};
      }).where((b) => b.isNotEmpty).toList();
    }

    if (blocks.isEmpty && article['content'] != null && article['content'].isNotEmpty) {
      blocks = [{'type': 'text', 'value': article['content']}];
    }

    final DateTime? publishedAt = article['publishedAt'] is DateTime
        ? article['publishedAt']
        : null;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ArticleDetailScreen(
          title: article['title'] ?? '',
          category: article['category'] ?? '',
          heroImageUrl: article['heroImageUrl'] ?? '',
          imageCaption: article['imageCaption'] ?? '',
          blocks: blocks,
          publishedAt: publishedAt,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
        title: Text(
          region,
          style: GoogleFonts.playfairDisplay(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('articles')
            .where('category', isEqualTo: region)
            .orderBy('publishedAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error loading articles'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return Center(
              child: Text(
                'No articles for $region yet.',
                style: TextStyle(color: Colors.grey[500]),
              ),
            );
          }

          final articles = docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final timestamp = data['publishedAt'] as Timestamp?;
            return {
              'title': data['title'] ?? '',
              'content': data['content'] ?? '',
              'category': data['category'] ?? '',
              'heroImageUrl': data['heroImageUrl'] ?? '',
              'imageCaption': data['imageCaption'] ?? '',
              'blocks': data['blocks'] ?? [],
              'publishedAt': timestamp?.toDate(),
            };
          }).toList();

          return ListView.builder(
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              final DateTime? date = article['publishedAt'] is DateTime
                  ? article['publishedAt']
                  : null;
              return GestureDetector(
                onTap: () => _openArticle(context, article),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
                      child: Text(
                        article['title'] ?? '',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 4),
                      child: Text(
                        article['content'] ?? '',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (date != null)
                      Padding(
                        padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
                        child: Text(
                          formatDate(date),
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[400],
                          ),
                        ),
                      ),
                    Divider(height: 1, color: Colors.grey[200]),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}