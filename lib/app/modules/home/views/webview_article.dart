import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:berita_daffa/utils/app_colors.dart';

class WebViewArticle extends StatefulWidget {
  @override
  _WebViewArticleState createState() => _WebViewArticleState();
}
class _WebViewArticleState extends State<WebViewArticle> {
  // 1. Ambil arguments (URL dan Title)
  final Map<String, String> args = Get.arguments as Map<String, String>;
  
  // 2. Controller untuk kontrol WebView
  late final WebViewController _controller;
  
  // 3. Progress loading (0.0 - 1.0)
  double _progress = 0.0;
  @override
  void initState() {
    super.initState();
    
    // 4. Inisialisasi WebView
    _controller = WebViewController()
      // Enable JavaScript (penting untuk kebanyakan website)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      
      // 5. Set callback untuk lifecycle WebView
      ..setNavigationDelegate(
        NavigationDelegate(
          // Saat halaman mulai load
          onPageStarted: (url) {
            setState(() {
              _progress = 0.0;
            });
          },
          
          // Saat halaman selesai load
          onPageFinished: (url) {
            setState(() {
              _progress = 1.0;
            });
          },
          
          // Update progress (0-100)
          onProgress: (progress) {
            setState(() {
              _progress = progress / 100;
            });
          },
          
          // Error handling
          onWebResourceError: (error) {
            Get.snackbar(
              'Error',
              'Failed to load article',
              snackPosition: SnackPosition.BOTTOM,
            );
          },
        ),
      )
      
      // 6. Load URL artikel
      ..loadRequest(Uri.parse(args['url']!));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 7. Tampilkan title artikel di AppBar
        title: Text(
          args['title'] ?? 'Article',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          // 8. Tombol refresh
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _controller.reload();  // Reload halaman
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      
      body: Column(
        children: [
          // 9. Progress indicator
          if (_progress < 1.0)
            LinearProgressIndicator(
              value: _progress,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          
          // 10. WebView widget
          Expanded(
            child: WebViewWidget(controller: _controller),
          ),
        ],
      ),
    );
  }
}
