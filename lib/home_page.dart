import 'package:flutter/material.dart';
import 'add_book_page.dart';
import 'favorites.dart';
import 'api_service.dart'; // You must create this

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedTab = 0;
  int currentPage = 0;

  List<Map<String, String>> favorites = [];
  List<Map<String, dynamic>> serverMangaList = [];

  String selectedYear = '2025';
  String selectedGenre = 'Action';
  String selectedStatus = 'Ongoing';

  final List<String> yearOptions = ['2025', '2020', '2015', '2010', '2005'];
  final List<String> genreOptions = ['Action', 'Romance', 'Comedy', 'Horror', 'Drama'];
  final List<String> statusOptions = ['Ongoing', 'Completed', 'Hiatus'];

  final List<Map<String, String>> personalManga = [
    {
      'title': 'Naruto',
      'author': 'Masashi Kishimoto',
      'image': 'https://m.media-amazon.com/images/I/81Zj-BWityL._AC_SL1500_.jpg',
      'genre': 'Action',
      'status': 'Completed',
      'year': '1999',
    },
    {
      'title': 'Jujutsu Kaisen',
      'author': 'Gege Akutami',
      'image': 'https://i.pinimg.com/736x/ac/43/52/ac4352f877cd4265d69538bd7532b7b3.jpg',
      'genre': 'Action',
      'status': 'Ongoing',
      'year': '2018',
    },
    {
      'title': 'Tokyo Revengers',
      'author': 'Ken Wakui',
      'image': 'https://cdn.europosters.eu/image/1300/207481.jpg',
      'genre': 'Action/Drama',
      'status': 'Completed',
      'year': '2017',
    },
    {
      'title': 'Chainsaw Man',
      'author': 'Tatsuki Fujimoto',
      'image': 'https://i.etsystatic.com/18887914/r/il/5b59fe/5214395642/il_1588xN.5214395642_7d6v.jpg',
      'genre': 'Action/Horror',
      'status': 'Ongoing',
      'year': '2018',
    },
  ];

  @override
  void initState() {
    super.initState();
    loadManga();
  }

  void loadManga() async {
    try {
      final manga = await ApiService.fetchMangaList();
      setState(() {
        serverMangaList = manga;
      });
    } catch (e) {
      print('Error fetching manga: $e');
    }
  }

  List<List<Map<String, String>>> get featuredPages {
    List<Map<String, String>> data;
    if (selectedTab == 1) {
      data = [
        {'title': 'Blue Lock', 'image': 'https://via.placeholder.com/150x220'},
        {'title': 'Haikyuu!!', 'image': 'https://via.placeholder.com/150x220'},
        {'title': 'Solo Leveling', 'image': 'https://via.placeholder.com/150x220'},
        {'title': 'Wind Breaker', 'image': 'https://via.placeholder.com/150x220'},
        {'title': 'My Hero Academia', 'image': 'https://via.placeholder.com/150x220'},
        {'title': 'Mashle', 'image': 'https://via.placeholder.com/150x220'},
      ];
    } else if (selectedTab == 2) {
      data = [
        {'title': 'Hunter x Hunter', 'image': 'https://via.placeholder.com/150x220'},
        {'title': 'Bleach', 'image': 'https://via.placeholder.com/150x220'},
        {'title': 'Death Note', 'image': 'https://via.placeholder.com/150x220'},
        {'title': 'Demon Slayer', 'image': 'https://via.placeholder.com/150x220'},
        {'title': 'Black Clover', 'image': 'https://via.placeholder.com/150x220'},
        {'title': 'Fairy Tail', 'image': 'https://via.placeholder.com/150x220'},
      ];
    } else {
      data = [
        {'title': 'One Piece', 'image': 'https://i.pinimg.com/736x/be/ef/6f/beef6fdc70c5c549a5ad42a09b6fc36d.png'},
        {'title': 'Attack on Titan', 'image': 'https://i.pinimg.com/736x/e4/d3/85/e4d38524090e4b1f9d2fb31e894c6c97.png'},
        {'title': 'Chainsaw Man', 'image': 'https://i.pinimg.com/736x/9f/39/d3/9f39d30665b01edfa92243e707668a74.png'},
        {'title': 'Boruto', 'image': 'https://i.pinimg.com/736x/a1/06/f5/a106f515050c22b4adde64bb4d6a27db.png'},
        {'title': 'Zom 100', 'image': 'https://i.pinimg.com/736x/ab/d6/27/abd627d40d6978721a70ee168e84c395.png'},
        {'title': 'Spy x Family', 'image': 'https://galaxycon.com/cdn/shop/files/ScanJan29_2024_7615ef72-07a3-41e9-aa72-af048a0c6570_600x.jpg?v=1742000768'},
      ];
    }

    return [
      data.sublist(0, 3),
      data.sublist(3, 6),
    ];
  }

  void toggleFavorite(Map<String, String> manga) {
    setState(() {
      bool exists = favorites.any((fav) => fav['title'] == manga['title']);
      if (exists) {
        favorites.removeWhere((fav) => fav['title'] == manga['title']);
      } else {
        favorites.add(manga);
      }
    });
  }

  bool isFavorite(String title) {
    return favorites.any((fav) => fav['title'] == title);
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String tempYear = selectedYear;
        String tempGenre = selectedGenre;
        String tempStatus = selectedStatus;

        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text("Edit Filters", style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: tempYear,
                decoration: InputDecoration(labelText: 'Year', labelStyle: TextStyle(color: Colors.white)),
                dropdownColor: Colors.grey[800],
                items: yearOptions.map((year) => DropdownMenuItem(
                  value: year,
                  child: Text(year, style: TextStyle(color: Colors.white)),
                )).toList(),
                onChanged: (value) => tempYear = value!,
              ),
              DropdownButtonFormField<String>(
                value: tempGenre,
                decoration: InputDecoration(labelText: 'Genre', labelStyle: TextStyle(color: Colors.white)),
                dropdownColor: Colors.grey[800],
                items: genreOptions.map((genre) => DropdownMenuItem(
                  value: genre,
                  child: Text(genre, style: TextStyle(color: Colors.white)),
                )).toList(),
                onChanged: (value) => tempGenre = value!,
              ),
              DropdownButtonFormField<String>(
                value: tempStatus,
                decoration: InputDecoration(labelText: 'Status', labelStyle: TextStyle(color: Colors.white)),
                dropdownColor: Colors.grey[800],
                items: statusOptions.map((status) => DropdownMenuItem(
                  value: status,
                  child: Text(status, style: TextStyle(color: Colors.white)),
                )).toList(),
                onChanged: (value) => tempStatus = value!,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text("Cancel", style: TextStyle(color: Colors.grey)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
              child: Text("Save", style: TextStyle(color: Colors.black)),
              onPressed: () {
                setState(() {
                  selectedYear = tempYear;
                  selectedGenre = tempGenre;
                  selectedStatus = tempStatus;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final carousel = featuredPages[currentPage];

    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.yellow,
        child: Icon(Icons.add, color: Colors.black),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddBookPage()),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[900],
        selectedItemColor: Colors.yellow,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FavoritesPage(favorites: favorites)),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              Text('Welcome, Beni', style: TextStyle(fontSize: 18, color: Colors.white)),
              SizedBox(height: 6),
              Text('Your Manga Library', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.yellow)),
              SizedBox(height: 16),
              _buildSearchBar(),
              SizedBox(height: 24),
              Row(
                children: [
                  _buildTab('Recently Added', 0),
                  SizedBox(width: 20),
                  _buildTab('Ongoing', 1),
                  SizedBox(width: 20),
                  _buildTab('Completed', 2),
                ],
              ),
              SizedBox(height: 20),
              _buildFeaturedCarousel(carousel),
              SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Your Manga List', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  IconButton(icon: Icon(Icons.menu, color: Colors.yellow), onPressed: _showFilterDialog),
                ],
              ),
              SizedBox(height: 16),
              GridView.count(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 3 / 4,
                children: (serverMangaList.isNotEmpty ? serverMangaList : personalManga).map((manga) {
                  final bool isFav = isFavorite(manga['title']!);
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 140,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                                image: DecorationImage(
                                  image: NetworkImage(manga['image']!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(manga['title']!, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white), overflow: TextOverflow.ellipsis),
                                  Text(manga['author']!, style: TextStyle(fontSize: 12, color: Colors.grey), overflow: TextOverflow.ellipsis),
                                  SizedBox(height: 4),
                                  Text(manga['genre'] ?? '', style: TextStyle(fontSize: 11, color: Colors.grey)),
                                  Text(manga['status'] ?? '', style: TextStyle(fontSize: 11, color: Colors.grey)),
                                  Text(manga['year'] ?? '', style: TextStyle(fontSize: 11, color: Colors.grey)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: IconButton(
                            icon: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: isFav ? Colors.red : Colors.grey,
                              size: 20,
                            ),
                            onPressed: () => toggleFavorite(manga.cast<String, String>()),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search manga...',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
          ),
          Icon(Icons.search, color: Colors.yellow),
        ],
      ),
    );
  }

  Widget _buildFeaturedCarousel(List<Map<String, String>> carousel) {
    return SizedBox(
      height: 230,
      child: Stack(
        children: [
          ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: carousel.length,
            separatorBuilder: (_, __) => SizedBox(width: 16),
            itemBuilder: (context, index) {
              final manga = carousel[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 130,
                    height: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: NetworkImage(manga['image']!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 6),
                  SizedBox(
                    width: 130,
                    child: Text(
                      manga['title']!,
                      style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              );
            },
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.yellow),
              onPressed: () {
                setState(() {
                  currentPage = (currentPage - 1).clamp(0, featuredPages.length - 1);
                });
              },
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: Icon(Icons.arrow_forward_ios, color: Colors.yellow),
              onPressed: () {
                setState(() {
                  currentPage = (currentPage + 1).clamp(0, featuredPages.length - 1);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    bool isSelected = selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = index;
          currentPage = 0;
        });
      },
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.yellow : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (isSelected)
            Container(
              margin: EdgeInsets.only(top: 4),
              width: 20,
              height: 2,
              color: Colors.yellow,
            ),
        ],
      ),
    );
  }
}
