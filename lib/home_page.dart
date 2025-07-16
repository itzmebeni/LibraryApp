import 'package:flutter/material.dart';
import 'add_book_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.yellow,
        colorScheme: ColorScheme.dark(primary: Colors.yellow),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedTab = 0; // 0 = Recently Added, 1 = Ongoing, 2 = Completed

  List<Map<String, String>> get featuredManga {
    if (selectedTab == 1) {
      return [
        {'title': 'Blue Lock', 'image': 'https://via.placeholder.com/150x220'},
        {'title': 'Haikyuu!!', 'image': 'https://via.placeholder.com/150x220'},
      ];
    } else if (selectedTab == 2) {
      return [
        {'title': 'Hunter x Hunter', 'image': 'https://via.placeholder.com/150x220'},
        {'title': 'Bleach', 'image': 'https://via.placeholder.com/150x220'},
      ];
    }
    return [
      {'title': 'One Piece', 'image': 'https://via.placeholder.com/150x220'},
      {'title': 'Attack on Titan', 'image': 'https://via.placeholder.com/150x220'},
    ];
  }

  final List<Map<String, String>> personalManga = [
    {'title': 'Naruto', 'author': 'Masashi Kishimoto'},
    {'title': 'Jujutsu Kaisen', 'author': 'Gege Akutami'},
  ];

  @override
  Widget build(BuildContext context) {
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
          // You can handle navigation here if needed
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              Text('Welcome, Beni', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.white)),
              const SizedBox(height: 6),
              Text('Your Manga Library', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.yellow)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildTab('Recently Added', 0),
                  const SizedBox(width: 20),
                  _buildTab('Ongoing', 1),
                  const SizedBox(width: 20),
                  _buildTab('Completed', 2),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 220,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: featuredManga.length,
                  separatorBuilder: (_, __) => SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final manga = featuredManga[index];
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
                        const SizedBox(height: 6),
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
              ),
              const SizedBox(height: 28),
              Text('Your Manga List', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 16),
              Column(
                children: personalManga.map((manga) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 90,
                          decoration: BoxDecoration(
                            color: Colors.yellow.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.menu_book, size: 30, color: Colors.black),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(manga['title']!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                              const SizedBox(height: 4),
                              Text(manga['author']!, style: TextStyle(color: Colors.grey)),
                            ],
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

  Widget _buildTab(String title, int index) {
    bool isSelected = selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = index;
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
              margin: const EdgeInsets.only(top: 4),
              width: 20,
              height: 2,
              color: Colors.yellow,
            ),
        ],
      ),
    );
  }
}
