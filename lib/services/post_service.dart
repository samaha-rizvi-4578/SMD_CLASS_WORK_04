import 'dart:convert';
import 'package:http/http.dart' as http;

class PostService {
  static Future<List<Map<String, String>>> fetchBooks() async {
    var url = Uri.https(
      'www.googleapis.com',
      '/books/v1/volumes',
      {'q': 'operating systems'},
    );

    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        var items = jsonResponse['items'] as List<dynamic>?;

        if (items == null) return [];

        // Convert values to String explicitly
        return items.map((book) {
          var volumeInfo = book['volumeInfo'] as Map<String, dynamic>;

          return {
            'title': (volumeInfo['title'] ?? 'No Title').toString(),
            'author': (volumeInfo['authors'] != null)
                ? (volumeInfo['authors'] as List).join(', ')
                : 'Unknown Author',
            'publisher': (volumeInfo['publisher'] ?? 'No Publisher').toString(),
            'thumbnail': (volumeInfo.containsKey('imageLinks') &&
                    volumeInfo['imageLinks'] != null &&
                    volumeInfo['imageLinks']['thumbnail'] != null)
                ? volumeInfo['imageLinks']['thumbnail'].toString()
                : '',
          };
        }).toList();
      } else {
        print('Request failed with status: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    }
  }
}
