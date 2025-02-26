import 'package:flutter/material.dart';
import 'services/post_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter API Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BookListScreen(),
    );
  }
}

class BookListScreen extends StatefulWidget {
  @override
  _BookListScreenState createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  List<Map<String, String>> books = [];
  int? hoveredIndex; // Track which item is hovered

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  void fetchBooks() async {
    List<Map<String, String>> fetchedBooks = await PostService.fetchBooks();
    setState(() {
      books = fetchedBooks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book List')),
      body: books.isEmpty
          ? const Center(child: CircularProgressIndicator()) // Show loader while fetching
          : ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                return MouseRegion(
                  onEnter: (_) => setState(() => hoveredIndex = index),
                  onExit: (_) => setState(() => hoveredIndex = null),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: hoveredIndex == index
                          ? const Color.fromARGB(79, 47, 60, 52) // Light green when hovered
                          : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey), // Corrected border implementation
                      boxShadow: hoveredIndex == index
                          ? [
                              const BoxShadow(
                                color: Color.fromARGB(98, 71, 87, 71),
                                blurRadius: 8,
                                spreadRadius: 2,
                              )
                            ]
                          : [],
                    ),
                    child: ListTile(
                      leading: books[index]['thumbnail'] != null && books[index]['thumbnail']!.isNotEmpty
                          ? Image.network(
                              books[index]['thumbnail']!,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.broken_image, size: 50, color: Colors.grey);
                              },
                            )
                          : const Icon(Icons.book, size: 50, color: Colors.grey),
                      title: Text(books[index]['title'] ?? 'No Title'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Author: ${books[index]['author']}'),
                          Text('Publisher: ${books[index]['publisher']}'),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
