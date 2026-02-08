import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:berita_daffa/models/news_article.dart';
import 'package:berita_daffa/utils/app_colors.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';
import 'package:berita_daffa/app/routes/app_pages.dart';

class NewsDetailView extends StatefulWidget {
  const NewsDetailView({super.key});

  @override
  State<NewsDetailView> createState() => _NewsDetailViewState();
}

class _NewsDetailViewState extends State<NewsDetailView> {
  late NewsArticle article;

  bool isDarkMode = false;
  double textScale = 1.0;

  @override
  void initState() {
    super.initState();
    article = Get.arguments as NewsArticle;
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = isDarkMode ? const Color(0xFF121212) : Colors.white;
    final surfaceColor =
        isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final appBarColor =
        isDarkMode ? const Color(0xFF1F1F1F) : AppColors.primary;

    final textPrimary =
        isDarkMode ? Colors.white : AppColors.textPrimary;
    final textSecondary =
        isDarkMode ? Colors.grey[400]! : AppColors.textSecondary;
    final dividerColor =
        isDarkMode ? Colors.grey[800]! : AppColors.divider;

    return Scaffold(
      backgroundColor: bgColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ================= HEADER IMAGE =================
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: appBarColor,
            iconTheme: IconThemeData(color: textPrimary),
            flexibleSpace: FlexibleSpaceBar(
              background: article.urlToImage != null
                  ? CachedNetworkImage(
                      imageUrl: article.urlToImage!,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        color: dividerColor,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        color: dividerColor,
                        child: Icon(
                          Icons.image_not_supported,
                          size: 48,
                          color: textSecondary,
                        ),
                      ),
                    )
                  : Container(
                      color: dividerColor,
                      child: Icon(
                        Icons.newspaper,
                        size: 48,
                        color: textSecondary,
                      ),
                    ),
            ),

            // ================= ACTIONS =================
            actions: [
              _textSizeButton('A−', 0.9, textPrimary),
              _textSizeButton('A', 1.0, textPrimary),
              _textSizeButton('A+', 1.2, textPrimary),

              IconButton(
                icon: Icon(
                  isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
                  color: textPrimary,
                ),
                onPressed: () =>
                    setState(() => isDarkMode = !isDarkMode),
              ),

              IconButton(
                icon: Icon(Icons.open_in_new, color: textPrimary),
                tooltip: 'Open in browser',
                onPressed: _openInBrowser,
              ),

              IconButton(
                icon: Icon(Icons.share, color: textPrimary),
                onPressed: _shareArticle,
              ),
            ],
          ),

          // ================= CONTENT =================
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                elevation: 4,
                color: surfaceColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ===== SOURCE & TIME =====
                      Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        children: [
                          if (article.source?.name != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                article.source!.name!,
                                style: TextStyle(
                                  fontSize: 12 * textScale,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          if (article.publishedAt != null)
                            Text(
                              timeago.format(
                                DateTime.parse(article.publishedAt!),
                              ),
                              style: TextStyle(
                                fontSize: 12 * textScale,
                                color: textSecondary,
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // ===== TITLE =====
                      if (article.title != null)
                        Text(
                          article.title!,
                          style: TextStyle(
                            fontSize: 24 * textScale,
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                            color: textPrimary,
                          ),
                        ),

                      const SizedBox(height: 20),

                      // ===== DESCRIPTION =====
                      if (article.description != null)
                        Text(
                          article.description!,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 16 * textScale,
                            height: 1.7,
                            color: textSecondary,
                          ),
                        ),

                      const SizedBox(height: 24),

                      // ===== CONTENT =====
                      if (article.content != null)
                        Text(
                          article.content!,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 16 * textScale,
                            height: 1.8,
                            color: textPrimary,
                          ),
                        ),

                      const SizedBox(height: 32),

                      // ===== READ FULL (WEBVIEW) =====
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _openInWebView,
                          icon: const Icon(Icons.menu_book),
                          label: const Text('Read Full Article'),
                          style: ElevatedButton.styleFrom(
                            padding:
                                const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= UI =================
  Widget _textSizeButton(
      String label, double scale, Color color) {
    return IconButton(
      icon: Text(
        label,
        style: TextStyle(fontWeight: FontWeight.bold, color: color),
      ),
      onPressed: () => setState(() => textScale = scale),
    );
  }

  // ================= ACTIONS =================
  void _shareArticle() {
    if (article.url != null) {
      Share.share(
        '${article.title ?? 'Check this news'}\n\n${article.url}',
      );
    }
  }

  void _openInBrowser() async {
    if (article.url == null) return;
    final uri = Uri.parse(article.url!);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  void _openInWebView() {
    if (article.url == null) return;

    Get.toNamed(
      Routes.WEB_ARTICLE,
      arguments: {
        'url': article.url!,
        'title': article.title ?? 'Article',
      },
    );
  }
}
