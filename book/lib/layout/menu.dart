import 'package:book/SignInSignUp/signin.dart';
import 'package:book/common/Common.dart';
import 'package:book/layout/cart_test.dart';
import 'package:book/layout/detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

import '../Async/asyncwidget.dart';
import '../Controller/book_controller.dart';
import '../Model/book.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final Book_Controller bookController = Get.put(Book_Controller());
  late Future<List<Book>> _futureBooks;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _futureBooks = bookController.fetchBooks();
  }

  void _search(String query) {
    setState(() {
      _searchQuery = query;
      _futureBooks = query.isEmpty
          ? bookController.fetchBooks()
          : bookController.searchBooks(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Danh sách các loại sách"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Tìm kiếm sách...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: _search,
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Book>>(
              future: _futureBooks,
              builder: (context, snapshot) {
                return AsyncWidget(
                  snapshot: snapshot,
                  builder: (context, snapshot) {
                    final books = snapshot.data ?? [];
                    if (books.isEmpty) {
                      return const Center(child: Text("Không tìm thấy sách."));
                    }
                    return GridView.builder(
                      padding: const EdgeInsets.all(8),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.6,
                      ),
                      itemCount: books.length,
                      itemBuilder: (context, index) {
                        final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
                        final book = books[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Detail(book: book,),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: Image.network(
                                    book.anh,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.broken_image),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    book.tenSach,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    book.tacGia,
                                    style: const TextStyle(fontSize: 14),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    currencyFormat.format(book.gia),
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
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
          AuthResponse? res = Common.response;
          if (res == null) {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => LoginPage(),)
            );
            return;
          }

          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PageGioHang(),)
          );
        },
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }
}
