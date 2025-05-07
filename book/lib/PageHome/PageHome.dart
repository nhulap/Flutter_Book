import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../Model/Book.dart';

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

class Pagehome extends StatelessWidget {
  const Pagehome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Danh sách các loại sách"),
      ),
      body: FutureBuilder<List<Book>>(
        future: fetchBooks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Lỗi: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Không có sách nào."));
          }

          final books = snapshot.data!;
          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
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
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed:
          () {

          },
        child: Icon(Icons.shopping_cart),
      ),
    );
  }
}
