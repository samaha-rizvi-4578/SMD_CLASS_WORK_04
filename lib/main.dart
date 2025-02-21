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
      appBar: AppBar(title: Text('Book List')),
      body: books.isEmpty
          ? Center(child: CircularProgressIndicator()) // Show loader while fetching
          : ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(books[index]['title'] ?? 'No Title'),
                  subtitle: Text('Author: ${books[index]['author']}'),
                );
              },
            ),
    );
  }
}
