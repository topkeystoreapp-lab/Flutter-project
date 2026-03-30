import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recipe Home',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF6F6F6),
        fontFamily: 'Roboto',
      ),
      home: const RecipeHomeScreen(),
    );
  }
}

class RecipeHomeScreen extends StatefulWidget {
  const RecipeHomeScreen({super.key});

  @override
  State<RecipeHomeScreen> createState() => _RecipeHomeScreenState();
}

class _RecipeHomeScreenState extends State<RecipeHomeScreen> {
  late Future<HomeBannerModel> _bannerFuture;
  int _selectedIndex = 0;

  final List<Map<String, String>> categories = const [
    {
      'title': 'Breakfast',
      'image':
      'https://images.unsplash.com/photo-1493770348161-369560ae357d?q=80&w=800&auto=format&fit=crop',
    },.git/MERGE_MSG [unix] (12:18 30/03/2026)                                                                                                                  6,1 All
    "~/AndroidStudioProjects/hello_world_flutter/.git/MERGE_MSG" [unix] 6L, 303B
    {
      'title': 'Dessert',
      'image':
      'https://images.unsplash.com/photo-1563729784474-d77dbb933a9e?q=80&w=800&auto=format&fit=crop',
    },
    {
      'title': 'Lunch',
      'image':
      'https://images.unsplash.com/photo-1547592180-85f173990554?q=80&w=800&auto=format&fit=crop',
    },
    {
      'title': 'Dinner',
      'image':
      'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=800&auto=format&fit=crop',
    },
  ];

  final List<Map<String, String>> chefs = const [
    {
      'name': 'Esther T.',
      'image':
      'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=400&auto=format&fit=crop',
    },
    {
      'name': 'Jenny M.',
      'image':
      'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=400&auto=format&fit=crop',
    },
    {
      'name': 'Jacob U.',
      'image':
      'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?q=80&w=400&auto=format&fit=crop',
    },
    {
      'name': 'Bessi K.',
      'image':
      'https://images.unsplash.com/photo-1504593811423-6dd665756598?q=80&w=400&auto=format&fit=crop',
    },
  ];

  @override
  void initState() {
    super.initState();
    _bannerFuture = fetchHomeBanner();
  }

  static HomeBannerModel parseHomeBanner(String responseBody) {
    final jsonMap = json.decode(responseBody) as Map<String, dynamic>;

    if (jsonMap['success'] == true && jsonMap['data'] != null) {
      return HomeBannerModel.fromJson(
        jsonMap['data'] as Map<String, dynamic>,
      );
    }

    throw Exception('Invalid home banner response');
  }

  Future<HomeBannerModel> fetchHomeBanner() async {
    try {
      final response = await http
          .get(
        Uri.parse(
          'https://azstore.app/wp-json/control-app/v1/settings/home-banner',
        ),
        headers: const {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        return parseHomeBanner(response.body);
      }

      throw Exception('HTTP ${response.statusCode}');
    } on TimeoutException {
      throw Exception('Banner request timed out');
    } catch (e) {
      throw Exception('Failed to load home banner: $e');
    }
  }

  Future<void> _refreshBanner() async {
    setState(() {
      _bannerFuture = fetchHomeBanner();
    });
    await _bannerFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshBanner,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 110),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopBanner(),
                const SizedBox(height: 18),
                _buildSectionHeader('Categories', 'See All'),
                const SizedBox(height: 12),
                SizedBox(
                  height: 74,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final item = categories[index];
                      return _CategoryAvatarCard(
                        title: item['title']!,
                        imageUrl: item['image']!,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 22),
                _buildSectionHeader(
                  'Home Banner',
                  'Refresh',
                  onActionTap: _refreshBanner,
                ),
                const SizedBox(height: 12),
                FutureBuilder<HomeBannerModel>(
                  future: _bannerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const _BannerLoadingCard();
                    }

                    if (snapshot.hasError) {
                      return _BannerErrorCard(
                        message: snapshot.error.toString(),
                        onRetry: () {
                          setState(() {
                            _bannerFuture = fetchHomeBanner();
                          });
                        },
                      );
                    }

                    if (!snapshot.hasData) {
                      return _BannerErrorCard(
                        message: 'No banner data found',
                        onRetry: () {
                          setState(() {
                            _bannerFuture = fetchHomeBanner();
                          });
                        },
                      );
                    }

                    return HomeBannerCard(
                      banner: snapshot.data!,
                      onRefresh: _refreshBanner,
                    );
                  },
                ),
                const SizedBox(height: 22),
                _buildSectionHeader('Top Chefs', 'See all'),
                const SizedBox(height: 12),
                SizedBox(
                  height: 86,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: chefs.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 18),
                    itemBuilder: (context, index) {
                      final chef = chefs[index];
                      return _ChefAvatar(
                        name: chef['name']!,
                        imageUrl: chef['image']!,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildTopBanner() {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF56A33),
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1AF56A33),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=300&auto=format&fit=crop',
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, Jenny!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Check Amazing Recipes..',
                      style: TextStyle(
                        color: Color(0xFFFFD6C6),
                        fontSize: 11.5,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.notifications_none_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.search, color: Color(0xFFB0B0B0), size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Search Any Recipe..',
                        style: TextStyle(
                          color: Color(0xFFB0B0B0),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.tune_rounded,
                  color: Color(0xFFF56A33),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
      String title,
      String action, {
        VoidCallback? onActionTap,
      }) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2D2D2D),
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: onActionTap,
          child: Text(
            action,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFFE59D81),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavBar() {
    final items = const [
      {'icon': Icons.home_rounded, 'label': 'Home'},
      {'icon': Icons.explore_outlined, 'label': 'Discover'},
      {'icon': Icons.favorite_rounded, 'label': 'Favourite'},
      {'icon': Icons.chat_bubble_outline_rounded, 'label': 'Chat'},
      {'icon': Icons.person_outline_rounded, 'label': 'Profile'},
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 16,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final isSelected = _selectedIndex == index;
          final item = items[index];
          return GestureDetector(
            onTap: () => setState(() => _selectedIndex = index),
            child: SizedBox(
              width: 62,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFFFE3D8)
                          : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      item['icon'] as IconData,
                      size: 20,
                      color: isSelected
                          ? const Color(0xFFF56A33)
                          : const Color(0xFFA5A5A5),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['label']! as String,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10.5,
                      color: isSelected
                          ? const Color(0xFFF56A33)
                          : const Color(0xFFA5A5A5),
                      fontWeight:
                      isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _CategoryAvatarCard extends StatelessWidget {
  final String title;
  final String imageUrl;

  const _CategoryAvatarCard({
    required this.title,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 78,
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeBannerModel {
  final String heading;
  final String subheading;
  final String bgImage;
  final String textAlign;
  final String headingColor;
  final String subheadingColor;
  final String btn1Visible;
  final String btn1Text;
  final String btn1Url;
  final String btn1Color;
  final String btn2Visible;
  final String btn2Text;
  final String btn2Url;
  final String btn2Color;

  const HomeBannerModel({
    required this.heading,
    required this.subheading,
    required this.bgImage,
    required this.textAlign,
    required this.headingColor,
    required this.subheadingColor,
    required this.btn1Visible,
    required this.btn1Text,
    required this.btn1Url,
    required this.btn1Color,
    required this.btn2Visible,
    required this.btn2Text,
    required this.btn2Url,
    required this.btn2Color,
  });

  factory HomeBannerModel.fromJson(Map<String, dynamic> json) {
    return HomeBannerModel(
      heading: (json['heading'] ?? '').toString(),
      subheading: (json['subheading'] ?? '').toString(),
      bgImage: (json['bg_image'] ?? '').toString(),
      textAlign: (json['text_align'] ?? 'left').toString(),
      headingColor: (json['heading_color'] ?? '#FFFFFF').toString(),
      subheadingColor: (json['subheading_color'] ?? '#FFFFFF').toString(),
      btn1Visible: (json['btn1_visible'] ?? '0').toString(),
      btn1Text: (json['btn1_text'] ?? '').toString(),
      btn1Url: (json['btn1_url'] ?? '').toString(),
      btn1Color: (json['btn1_color'] ?? '#007c00').toString(),
      btn2Visible: (json['btn2_visible'] ?? '0').toString(),
      btn2Text: (json['btn2_text'] ?? '').toString(),
      btn2Url: (json['btn2_url'] ?? '').toString(),
      btn2Color: (json['btn2_color'] ?? '#d80000').toString(),
    );
  }

  bool get showBtn1 => btn1Visible == '1';
  bool get showBtn2 => btn2Visible == '1';
}

class HomeBannerCard extends StatelessWidget {
  final HomeBannerModel banner;
  final Future<void> Function() onRefresh;

  const HomeBannerCard({
    super.key,
    required this.banner,
    required this.onRefresh,
  });

  Color _hexToColor(String value, {Color fallback = Colors.white}) {
    try {
      var hex = value.trim().replaceAll('#', '');
      if (hex.length == 3) {
        hex = hex.split('').map((e) => '$e$e').join();
      }
      if (hex.length == 6) {
        hex = 'FF$hex';
      }
      return Color(int.parse(hex, radix: 16));
    } catch (_) {
      return fallback;
    }
  }

  Alignment _contentAlignment() {
    switch (banner.textAlign.toLowerCase()) {
      case 'center':
        return Alignment.center;
      case 'right':
        return Alignment.centerRight;
      default:
        return Alignment.centerLeft;
    }
  }

  CrossAxisAlignment _crossAxisAlignment() {
    switch (banner.textAlign.toLowerCase()) {
      case 'center':
        return CrossAxisAlignment.center;
      case 'right':
        return CrossAxisAlignment.end;
      default:
        return CrossAxisAlignment.start;
    }
  }

  TextAlign _textAlign() {
    switch (banner.textAlign.toLowerCase()) {
      case 'center':
        return TextAlign.center;
      case 'right':
        return TextAlign.right;
      default:
        return TextAlign.left;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            banner.bgImage.isNotEmpty
                ? Image.network(
              banner.bgImage,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(color: const Color(0xFFF56A33));
              },
            )
                : Container(color: const Color(0xFFF56A33)),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.15),
                    Colors.black.withValues(alpha: 0.45),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: Material(
                color: Colors.white.withValues(alpha: 0.92),
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => onRefresh(),
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      Icons.refresh_rounded,
                      size: 18,
                      color: Color(0xFFF56A33),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: _contentAlignment(),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: _crossAxisAlignment(),
                  children: [
                    Text(
                      banner.heading,
                      textAlign: _textAlign(),
                      style: TextStyle(
                        color: _hexToColor(banner.headingColor),
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        height: 1.15,
                      ),
                    ),
                    if (banner.subheading.isNotEmpty) const SizedBox(height: 8),
                    if (banner.subheading.isNotEmpty)
                      Text(
                        banner.subheading,
                        textAlign: _textAlign(),
                        style: TextStyle(
                          color: _hexToColor(banner.subheadingColor),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                      ),
                    if (banner.showBtn1 || banner.showBtn2)
                      const SizedBox(height: 16),
                    Wrap(
                      alignment: banner.textAlign.toLowerCase() == 'center'
                          ? WrapAlignment.center
                          : banner.textAlign.toLowerCase() == 'right'
                          ? WrapAlignment.end
                          : WrapAlignment.start,
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        if (banner.showBtn1 && banner.btn1Text.isNotEmpty)
                          _BannerActionButton(
                            label: banner.btn1Text,
                            color: _hexToColor(
                              banner.btn1Color,
                              fallback: const Color(0xFF007C00),
                            ),
                          ),
                        if (banner.showBtn2 && banner.btn2Text.isNotEmpty)
                          _BannerActionButton(
                            label: banner.btn2Text,
                            color: _hexToColor(
                              banner.btn2Color,
                              fallback: const Color(0xFFD80000),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BannerActionButton extends StatelessWidget {
  final String label;
  final Color color;

  const _BannerActionButton({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _BannerLoadingCard extends StatelessWidget {
  const _BannerLoadingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xFFEFEFEF),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: Color(0xFFF56A33)),
      ),
    );
  }
}

class _BannerErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _BannerErrorCard({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white,
        border: Border.all(color: const Color(0xFFFFD7C9)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: Color(0xFFF56A33),
            size: 34,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF666666),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 14),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF56A33),
              foregroundColor: Colors.white,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _ChefAvatar extends StatelessWidget {
  final String name;
  final String imageUrl;

  const _ChefAvatar({
    required this.name,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 68,
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x11000000),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF454545),
            ),
          ),
        ],
      ),
    );
  }
}