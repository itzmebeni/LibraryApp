import 'package:flutter/material.dart';

class FavoritesPage extends StatefulWidget {
  final List<Map<String, String>> favorites;

  const FavoritesPage({super.key, required this.favorites});

  static const Color darkShadowBlack = Color(0xFF121212);
  static const Color lightYellow = Color(0xFFFFF176);

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late List<Map<String, String>> _favorites;

  @override
  void initState() {
    super.initState();
    _favorites = List.from(widget.favorites);
  }

  void _confirmRemove(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: FavoritesPage.darkShadowBlack,
        title: Text(
          'Remove this manga?',
          style: TextStyle(color: FavoritesPage.lightYellow),
        ),
        content: Text(
          'Are you sure you want to remove this manga from your favorites?',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              setState(() {
                _favorites.removeAt(index);
              });
            },
            child: Text('Remove', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FavoritesPage.darkShadowBlack,
      appBar: AppBar(
        backgroundColor: FavoritesPage.darkShadowBlack,
        title: Text('Favorites', style: TextStyle(color: FavoritesPage.lightYellow)),
        iconTheme: IconThemeData(color: FavoritesPage.lightYellow),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: _favorites.isEmpty
            ? Center(
          child: Text(
            'No favorites yet.',
            style: TextStyle(color: Colors.grey),
          ),
        )
            : GridView.builder(
          itemCount: _favorites.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.75, // Slightly taller to fit title under square
          ),
          itemBuilder: (context, index) {
            final item = _favorites[index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  Column(
                    children: [
                      AspectRatio(
                        aspectRatio: 1, // Square image
                        child: ClipRRect(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                          child: Image.network(
                            item['image'] ?? '',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.broken_image,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              item['title'] ?? '',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => _confirmRemove(index),
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.favorite, color: Colors.redAccent, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
