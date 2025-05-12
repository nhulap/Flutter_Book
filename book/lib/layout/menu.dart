import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../ChiTietSach/ChiTietSach.dart';
import '../Model/book.dart';

// Hàm lấy danh sách sách từ Supabase
Future<List<Book>> fetchBooks() async {
  final response = await Supabase.instance.client
      .from('Book')
      .select()
      .order('id', ascending: true);

  return (response as List)
      .map((bookJson) => Book.fromJson(bookJson))
      .toList();
}

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  late Future<List<Book>> _booksFuture;
  List<Book> _allBooks = [];
  List<Book> _filteredBooks = [];
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _booksFuture = fetchBooks().then((books) {
      _allBooks = books;
      _filteredBooks = books;
      return books;
    });
  }

  void _filterBooks(String query) {
    setState(() {
      _searchText = query;
      _filteredBooks = _allBooks
          .where((book) =>
          book.tenSach.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Danh sách các loại sách"),
      ),
      body: Column(
        children: [
          // Thanh tìm kiếm
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Tìm kiếm sách...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: _filterBooks,
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Book>>(
              future: _booksFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Lỗi: ${snapshot.error}"));
                } else if (_filteredBooks.isEmpty) {
                  return Center(child: Text("Không tìm thấy sách phù hợp."));
                }

                return ListView.builder(
                  itemCount: _filteredBooks.length,
                  itemBuilder: (context, index) {
                    final book = _filteredBooks[index];
                    return ListTile(
                      leading: Image.network(
                        book.anh,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.broken_image),
                      ),
                      title: Text(book.tenSach),
                      subtitle: Text("Tác giả: ${book.tacGia}\nGiá: ${book.gia}đ"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PageChiTietSach(book: book,),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action cho nút giỏ hàng
        },
        child: Icon(Icons.shopping_cart),
      ),
    );
  }
}
