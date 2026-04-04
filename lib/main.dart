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

  // Skip Firebase on Linux - not supported
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

// ===== MOCK DATA (Linux only) =====
final mockArticles = [
  {'title': 'Global Summit Reaches Climate Agreement', 'content': 'World leaders gathered in Geneva to sign a landmark deal.', 'category': 'World'},
  {'title': 'Tech Giants Face New Regulations', 'content': 'The EU has announced sweeping new rules for large platforms.', 'category': 'Technology'},
  {'title': 'Elections Underway in Three Nations', 'content': 'Voters headed to the polls today in a historic vote.', 'category': 'Politics'},
  {'title': 'Markets Rally After Fed Announcement', 'content': 'Stock markets surged following the latest interest rate decision.', 'category': 'Business'},
  {'title': 'Championship Finals Set For Weekend', 'content': 'Two sides will compete for the title in a sold out stadium.', 'category': 'Sport'},
  {'title': 'New Study Links Sleep To Productivity', 'content': 'Researchers have found a strong correlation between rest and output.', 'category': 'Health'},
  {'title': 'Arctic Ice Levels Hit Record Low', 'content': 'Scientists warn of accelerating melt rates in the polar region.', 'category': 'World'},
  {'title': 'Central Bank Raises Interest Rates', 'content': 'Policymakers move to curb inflation with a quarter point rise.', 'category': 'Business'},
  {'title': 'Space Agency Announces Mars Mission', 'content': 'A crewed mission to Mars is planned for the next decade.', 'category': 'Technology'},
  {'title': 'Transfer Window Opens With Big Moves', 'content': 'Several top clubs have already secured high profile signings.', 'category': 'Sport'},
  {'title': 'UN Calls Emergency Session On Conflict', 'content': 'Security council members met to discuss the escalating crisis.', 'category': 'World'},
  {'title': 'AI Regulation Bill Passes First Reading', 'content': 'Lawmakers move closer to passing landmark artificial intelligence laws.', 'category': 'Technology'},
  {'title': 'Opposition Party Wins By-Election', 'content': 'A surprise result has shifted the balance of power in parliament.', 'category': 'Politics'},
  {'title': 'Oil Prices Surge Amid Supply Concerns', 'content': 'Crude prices climbed sharply on fears of a production shortfall.', 'category': 'Business'},
  {'title': 'National Team Names World Cup Squad', 'content': 'The manager has included several surprise selections in the lineup.', 'category': 'Sport'},
  {'title': 'Hospitals Report Rise In Winter Admissions', 'content': 'Health services are under pressure as seasonal illness peaks early.', 'category': 'Health'},
  {'title': 'Floods Displace Thousands In Southeast Asia', 'content': 'Relief efforts are underway after severe monsoon rains hit the region.', 'category': 'World'},
  {'title': 'Major Bank Announces Thousands Of Job Cuts', 'content': 'The lender cited automation and cost pressures behind the decision.', 'category': 'Business'},
  {'title': 'Rover Discovers Unusual Rock Formation On Mars', 'content': 'Scientists are studying samples that could hint at ancient conditions.', 'category': 'Technology'},
  {'title': 'Athlete Breaks Ten Year World Record', 'content': 'A stunning performance at the championship has rewritten the history books.', 'category': 'Sport'},
  {'title': 'Prime Minister Calls Snap Election', 'content': 'The announcement came after a vote of no confidence in parliament.', 'category': 'Politics'},
  {'title': 'Inflation Falls For Third Consecutive Month', 'content': 'The latest figures offer some relief for households facing high costs.', 'category': 'Business'},
  {'title': 'Wildfire Spreads Across Southern Europe', 'content': 'Firefighters are battling blazes across several countries amid a heatwave.', 'category': 'World'},
  {'title': 'Streaming Giants Lose Subscribers For First Time', 'content': 'The industry faces a turning point as viewer habits continue to shift.', 'category': 'Technology'},
  {'title': 'New Mental Health Strategy Launched', 'content': 'The government has outlined a ten year plan to improve services.', 'category': 'Health'},
];

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
    final tileArticles = mockArticles.sublist(4, 8);
    final bottomArticles = mockArticles.sublist(8);
    return _NewsLayout(
      heroArticle: heroArticle,
      topArticles: topArticles,
      tileArticles: tileArticles,
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
          return {
            'title': data['title'] ?? '',
            'content': data['content'] ?? '',
            'category': data['category'] ?? '',
            'imageUrl': data['imageUrl'] ?? '',
          };
        }).toList();

        final heroArticle = articles[0];
        final topArticles = articles.length > 1 ? articles.sublist(1, articles.length.clamp(1, 4)) : [];
        final tileArticles = articles.length > 4 ? articles.sublist(4, articles.length.clamp(4, 8)) : [];
        final bottomArticles = articles.length > 8 ? articles.sublist(8) : [];

        return _NewsLayout(
          heroArticle: heroArticle,
          topArticles: topArticles,
          tileArticles: tileArticles,
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
  final List tileArticles;
  final List bottomArticles;

  const _NewsLayout({
    required this.heroArticle,
    required this.topArticles,
    required this.tileArticles,
    required this.bottomArticles,
  });

  @override
  Widget build(BuildContext context) {
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
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ArticleDetailScreen(
                  title: heroArticle['title'] ?? '',
                  content: heroArticle['content'] ?? '',
                  category: heroArticle['category'] ?? '',
                ),
              ),
            ),
            child: Container(
              margin: EdgeInsets.all(16),
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
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
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      heroArticle['title'] ?? '',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // --- Top articles list ---
          ...topArticles.map((article) => GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ArticleDetailScreen(
                  title: article['title'] ?? '',
                  content: article['content'] ?? '',
                  category: article['category'] ?? '',
                ),
              ),
            ),
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
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
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
                Divider(height: 1, color: Colors.grey[200]),
              ],
            ),
          )),

          // --- Topic tiles ---
          Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
            child: Text(
              'TOPICS',
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
              children: ['Africa', 'Indo-Pacific', 'South America', 'Middle East'].map((topic) =>
                Material(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        topic,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ),
              ).toList(),
            ),
          ),

          // --- Featured articles ---
          if (tileArticles.isNotEmpty) ...[
            Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text(
                'FEATURED',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                  color: Colors.blue,
                ),
              ),
            ),
            ...tileArticles.map((article) => GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ArticleDetailScreen(
                    title: article['title'] ?? '',
                    content: article['content'] ?? '',
                    category: article['category'] ?? '',
                  ),
                ),
              ),
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
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
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
                  Divider(height: 1, color: Colors.grey[200]),
                ],
              ),
            )),
          ],

          // --- More News ---
          if (bottomArticles.isNotEmpty) ...[
            Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text(
                'MORE NEWS',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                  color: Colors.blue,
                ),
              ),
            ),
            ...bottomArticles.map((article) => GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ArticleDetailScreen(
                    title: article['title'] ?? '',
                    content: article['content'] ?? '',
                    category: article['category'] ?? '',
                  ),
                ),
              ),
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
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
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
                  Divider(height: 1, color: Colors.grey[200]),
                ],
              ),
            )),
          ],

          SizedBox(height: 24),
        ],
      ),
    );
  }
}