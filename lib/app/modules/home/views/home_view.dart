import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:berita_daffa/controllers/news_controllers.dart';
import 'package:berita_daffa/widgets/category_chip.dart';
import 'package:berita_daffa/widgets/loading_shimmer.dart';
import 'package:berita_daffa/widgets/news_card.dart';
import 'package:berita_daffa/utils/app_colors.dart';
import 'package:berita_daffa/app/routes/app_pages.dart';

class HomeView extends GetView<NewsController> {
  final RxInt _currentIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: AppColors.background,

        /// ===== BOTTOM NAVIGATION =====
        bottomNavigationBar: SafeArea(
          child: BottomNavigationBar(
            currentIndex: _currentIndex.value,
            onTap: (index) => _currentIndex.value = index,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.newspaper),
                label: 'News',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.explore),
                label: 'Explore',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bookmark),
                label: 'Bookmark',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),

        body: _buildPage(context),
      ),
    );
  }

  /// ===== PAGE SWITCH =====
  Widget _buildPage(BuildContext context) {
    switch (_currentIndex.value) {
      case 1:
        return const Center(child: Text('Explore Page'));
      case 2:
        return const Center(child: Text('Bookmark Page'));
      case 3:
        return const Center(child: Text('Profile Page'));
      default:
        return _buildHome(context);
    }
  }

  /// ===== HOME PAGE =====
  Widget _buildHome(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.refreshNews,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          /// ===== APP BAR =====
          SliverAppBar(
            expandedHeight: 90,
            floating: true,
            pinned: true,
            centerTitle: true,
            backgroundColor: AppColors.primary,
            title: const Text(
              'Fake News',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () => _showSearchDialog(context),
              ),
            ],
          ),

          /// ===== CATEGORY =====
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverCategoryDelegate(
              child: Container(
                color: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.categories.length,
                  itemBuilder: (context, index) {
                    final category = controller.categories[index];
                    return Obx(
                      () => CategoryChip(
                        label: category.capitalize ?? category,
                        isSelected:
                            controller.selectedCategory == category,
                        onTap: () =>
                            controller.selectCategory(category),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          /// ===== TOP HEADLINE =====
          Obx(() {
            if (controller.isLoading) {
              return const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: LoadingShimmer(),
                ),
              );
            }

            if (controller.articles.isEmpty) {
              return const SliverToBoxAdapter(child: SizedBox());
            }

            final headline = controller.articles.first;

            return SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🔥 Top Headline',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    NewsCard(
                      article: headline,
                      onTap: () => Get.toNamed(
                        Routes.DETAIL,
                        arguments: headline,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

          /// ===== LATEST NEWS TITLE =====
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 10, 16, 4),
              child: Text(
                'Latest News',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),

          /// ===== NEWS LIST =====
          Obx(() {
            if (controller.isLoading) {
              return const SliverFillRemaining(
                child: LoadingShimmer(),
              );
            }

            if (controller.error.isNotEmpty) {
              return SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.wifi_off, size: 60, color: Colors.grey),
                      SizedBox(height: 12),
                      Text('Failed to load news'),
                    ],
                  ),
                ),
              );
            }

            if (controller.articles.isEmpty) {
              return const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: Text('No news available')),
              );
            }

            return SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final article = controller.articles[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 1),
                        duration:
                            const Duration(milliseconds: 400),
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset:
                                  Offset(0, 20 * (1 - value)),
                              child: child,
                            ),
                          );
                        },
                        child: NewsCard(
                          article: article,
                          onTap: () => Get.toNamed(
                            Routes.DETAIL,
                            arguments: article,
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: controller.articles.length,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  /// ===== SEARCH =====
  void _showSearchDialog(BuildContext context) {
    final TextEditingController searchController =
        TextEditingController();

    Get.bottomSheet(
      isScrollControlled: true,
      Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Material(
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(30)),
          child: TextField(
            controller: searchController,
            decoration: const InputDecoration(
              hintText: 'Search news...',
              contentPadding: EdgeInsets.all(16),
              border: InputBorder.none,
            ),
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                controller.searchNews(value);
                Get.back();
              }
            },
          ),
        ),
      ),
    );
  }
}

/// ===== STICKY CATEGORY =====
class _SliverCategoryDelegate
    extends SliverPersistentHeaderDelegate {
  final Widget child;
  _SliverCategoryDelegate({required this.child});

  @override
  double get minExtent => 60;
  @override
  double get maxExtent => 60;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(_) => false;
}
