import 'package:book/Async/asyncwidget.dart';
import 'package:book/Controller/book_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../Model/book.dart';



class Pagehome extends StatelessWidget {
  const Pagehome({super.key});

  @override
  Widget build(BuildContext context) {
    final Book_Controller book= Get.put(Book_Controller());
    return Scaffold(
      appBar: AppBar(
        title: Text("Danh sách các loại sách"),
      ),
      body: FutureBuilder<List<Book>>(
        future: book.fetchBooks(),
        builder: (context, snapshot) {
          return AsyncWidget(
              snapshot: snapshot,
              builder: (context, snapshot) {
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
