import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';
import 'article_detail_screen.dart';

// ===== MAIN =====
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb && defaultTargetPlatform != TargetPlatform.linux) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }

  runApp(MyApp());
}

// ===== APP ROOT =====
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GeoPoliticsToday',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.playfairDisplayTextTheme(),
      ),
      home: NewsScreen(),
    );
  }
}

// ===== HELPERS =====
String formatDate(DateTime date) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  return '${months[date.month - 1]} ${date.day}, ${date.year}';
}

// ===== MOCK DATA (Linux only) =====
final mockArticles = [
  {'title': 'Global Summit Reaches Climate Agreement', 'content': 'World leaders gathered in Geneva to sign a landmark deal.', 'category': 'World', 'heroImageUrl': '', 'publishedAt': DateTime(2026, 4, 1)},
  {'title': 'Tech Giants Face New Regulations', 'content': 'The EU has announced sweeping new rules for large platforms.', 'category': 'Technology', 'heroImageUrl': '', 'publishedAt': DateTime(2026, 3, 30)},
  {'title': 'Elections Underway in Three Nations', 'content': 'Voters headed to the polls today in a historic vote.', 'category': 'Politics', 'heroImageUrl': '', 'publishedAt': DateTime(2026, 3, 29)},
  {'title': 'Markets Rally After Fed Announcement', 'content': 'Stock markets surged following the latest interest rate decision.', 'category': 'Business', 'heroImageUrl': '', 'publishedAt': DateTime(2026, 3, 28)},
  {'title': 'Championship Finals Set For Weekend', 'content': 'Two sides will compete for the title in a sold out stadium.', 'category': 'Sport', 'heroImageUrl': '', 'publishedAt': DateTime(2026, 3, 27)},
  {'title': 'New Study Links Sleep To Productivity', 'content': 'Researchers have found a strong correlation between rest and output.', 'category': 'Health', 'heroImageUrl': '', 'publishedAt': DateTime(2026, 3, 26)},
  {'title': 'Arctic Ice Levels Hit Record Low', 'content': 'Scientists warn of accelerating melt rates in the polar region.', 'category': 'World', 'heroImageUrl': '', 'publishedAt': DateTime(2026, 3, 25)},
  {'title': 'Central Bank Raises Interest Rates', 'content': 'Policymakers move to curb inflation with a quarter point rise.', 'category': 'Business', 'heroImageUrl': '', 'publishedAt': DateTime(2026, 3, 24)},
  {'title': 'Space Agency Announces Mars Mission', 'content': 'A crewed mission to Mars is planned for the next decade.', 'category': 'Technology', 'heroImageUrl': '', 'publishedAt': DateTime(2026, 3, 23)},
  {'title': 'Transfer Window Opens With Big Moves', 'content': 'Several top clubs have already secured high profile signings.', 'category': 'Sport', 'heroImageUrl': '', 'publishedAt': DateTime(2026, 3, 22)},
  {'title': 'UN Calls Emergency Session On Conflict', 'content': 'Security council members met to discuss the escalating crisis.', 'category': 'World', 'heroImageUrl': '', 'publishedAt': DateTime(2026, 3, 21)},
  {'title': 'AI Regulation Bill Passes First Reading', 'content': 'Lawmakers move closer to passing landmark artificial intelligence laws.', 'category': 'Technology', 'heroImageUrl': '', 'publishedAt': DateTime(2026, 3, 20)},
  {'title': 'Opposition Party Wins By-Election', 'content': 'A surprise result has shifted the balance of power in parliament.', 'category': 'Politics', 'heroImageUrl': '', 'publishedAt': DateTime(2026, 3, 19)},
  {'title': 'Oil Prices Surge Amid Supply Concerns', 'content': 'Crude prices climbed sharply on fears of a production shortfall.', 'category': 'Business', 'heroImageUrl': '', 'publishedAt': DateTime(2026, 3, 18)},
  {'title': 'National Team Names World Cup Squad', 'content': 'The manager has included several surprise selections in the lineup.', 'category': 'Sport', 'heroImageUrl': '', 'publishedAt': DateTime(2026, 3, 17)},
  {'title': 'Hospitals Report Rise In Winter Admissions', 'content': 'Health services are under pressure as seasonal illness peaks early.', 'category': 'Health', 'heroImageUrl': '', 'publishedAt': DateTime(2026, 3, 16)},
  {'title': 'Floods Displace Thousands In Southeast Asia', 'content': 'Relief efforts are underway after severe monsoon rains hit the region.', 'category': 'World', 'heroImageUrl': '', 'publishedAt': DateTime(2026, 3, 15)},
  {'title': 'Major Bank Announces Thousands Of Job Cuts', 'content': 'The lender cited automation and cost pressures behind the decision.', 'category': 'Business', 'heroImageUrl': '', 'publishedAt': DateTime(2026, 3, 14)},
  {'title': 'Rover Discovers Unusual Rock Formation On Mars', 'content': 'Scientists are studying samples that could hint at ancient conditions.', 'category': 'Technology', 'heroImageUrl': '', 'publishedAt': DateTime(2026, 3, 13)},
  {'title': 'Athlete Breaks Ten Year World Record', 'content': 'A stunning performance at the championship has rewritten the history books.', 'category': 'Sport', 'heroImageUrl': '', 'publishedAt': DateTime(2026, 3, 12)},
  {'title': 'Prime Minister Calls Snap Election', 'content': 'The announcement came after a vote of no confidence in parliament.', 'category': 'Politics', 'heroImageUrl': '', 'publishedAt': DateTime(2026, 3, 11)},
  {'title': 'Inflation Falls For Third Consecutive Month', 'content': 'The latest figures offer some relief for households facing high costs.', 'category': 'Business', 'heroImageUrl': '', 'publishedAt': DateTime(2026, 3, 10)},
  {'title': 'Wildfire Spreads Across Southern Europe', 'content': 'Firefighters are battling blazes across several countries amid a heatwave.', 'category': 'World', 'heroImageUrl': '', 'publishedAt': DateTime(2026, 3, 9)},
  {'title': 'Streaming Giants Lose Subscribers For First Time', 'content': 'The industry faces a turning point as viewer habits continue to shift.', 'category': 'Technology', 'heroImageUrl': '', 'publishedAt': DateTime(2026, 3, 8)},
  {'title': 'New Mental Health Strategy Launched', 'content': 'The government has outlined a ten year plan to improve services.', 'category': 'Health', 'heroImageUrl': '', 'publishedAt': DateTime(2026, 3, 7)},
];

// ===== PATTERN PAINTERS =====
class DiagonalStripePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 1.5;
    for (double i = -size.height; i < size.width + size.height; i += 16) {
      canvas.drawLine(Offset(i, 0), Offset(i + size.height, size.height), paint);
    }
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.grey[400]!;
    for (double x = 8; x < size.width; x += 16) {
      for (double y = 8; y < size.height; y += 16) {
        canvas.drawCircle(Offset(x, y), 1.5, paint);
      }
    }
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// ===== HOME SCREEN =====
class NewsScreen extends StatelessWidget {
  final bool isLinux = !kIsWeb && defaultTargetPlatform == TargetPlatform.linux;

  @override
  Widget build(BuildContext context) {
    return isLinux ? _MockNewsScreen() : _LiveNewsScreen();
  }
}

// ===== MOCK SCREEN (Linux only) =====
class _MockNewsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final heroArticle = mockArticles[0];
    final topArticles = mockArticles.sublist(1, 4);
    final bottomArticles = mockArticles.sublist(4);
    return _NewsLayout(
      heroArticle: heroArticle,
      topArticles: topArticles,
      bottomArticles: bottomArticles,
    );
  }
}

// ===== LIVE FIREBASE SCREEN =====
class _LiveNewsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('articles')
          .orderBy('publishedAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('Error loading news')));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final docs = snapshot.data!.docs;
        if (docs.isEmpty) {
          return Scaffold(body: Center(child: Text('No articles found')));
        }

        final articles = docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final timestamp = data['publishedAt'] as Timestamp?;
          return {
            'title': data['title'] ?? '',
            'content': data['content'] ?? '',
            'category': data['category'] ?? '',
            'heroImageUrl': data['heroImageUrl'] ?? '',
            'blocks': data['blocks'] ?? [],
            'publishedAt': timestamp?.toDate(),
          };
        }).toList();

        final heroArticle = articles[0];
        final topArticles = articles.length > 1 ? articles.sublist(1, articles.length.clamp(1, 4)) : [];
        final bottomArticles = articles.length > 4 ? articles.sublist(4) : [];

        return _NewsLayout(
          heroArticle: heroArticle,
          topArticles: topArticles,
          bottomArticles: bottomArticles,
        );
      },
    );
  }
}

// ===== SHARED LAYOUT =====
class _NewsLayout extends StatelessWidget {
  final Map<String, dynamic> heroArticle;
  final List topArticles;
  final List bottomArticles;

  const _NewsLayout({
    required this.heroArticle,
    required this.topArticles,
    required this.bottomArticles,
  });

  void _openArticle(BuildContext context, dynamic article) {
    final rawBlocks = article['blocks'];
    List<Map<String, dynamic>> blocks = [];

    if (rawBlocks != null && rawBlocks is List) {
      blocks = rawBlocks.map((b) {
        if (b is Map) {
          return Map<String, dynamic>.from(b);
        }
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
          blocks: blocks,
          publishedAt: publishedAt,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool hasHeroImage = heroArticle['heroImageUrl'] != null &&
        heroArticle['heroImageUrl'].toString().isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        toolbarHeight: 80,
        title: Text(
          'GeoPolitics Today',
          style: GoogleFonts.playfairDisplay(
            fontSize: 42,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [

          // --- Hero article ---
          GestureDetector(
            onTap: () => _openArticle(context, heroArticle),
            child: Container(
              margin: EdgeInsets.all(16),
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                image: hasHeroImage
                    ? DecorationImage(
                        image: NetworkImage(heroArticle['heroImageUrl']),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.3),
                          BlendMode.darken,
                        ),
                      )
                    : null,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    if (!hasHeroImage)
                      Positioned.fill(
                        child: CustomPaint(painter: DiagonalStripePainter()),
                      ),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'FEATURED',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                              color: hasHeroImage ? Colors.white : Colors.blue,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            heroArticle['title'] ?? '',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              color: hasHeroImage ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // --- Top articles list ---
          ...topArticles.map((article) {
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
          }),

          // --- Region tiles ---
          Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
            child: Text(
              'REGIONS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
                color: Colors.blue,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.2,
              children: ['Africa', 'Indo-Pacific', 'South America', 'Middle East'].map((region) {
                return Material(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: CustomPaint(painter: DotGridPainter()),
                            ),
                            Center(
                              child: Text(
                                region,
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // --- More articles ---
          if (bottomArticles.isNotEmpty)
            ...bottomArticles.map((article) {
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
            }),

          SizedBox(height: 24),
        ],
      ),
    );
  }
}