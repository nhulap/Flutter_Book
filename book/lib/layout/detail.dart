
import 'package:book/Controller/book_controller.dart';
import 'package:book/Controller/cart_controller.dart';
import 'package:book/Model/cart.dart';
import 'package:book/SignInSignUp/signin.dart';
import 'package:book/common/Common.dart';
import 'package:book/layout/cart_test.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/interceptors/get_modifiers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../Model/book.dart';


String formatNgay(DateTime date) {
  try {
    String day = date.day.toString().padLeft(2, '0');
    String month = date.month.toString().padLeft(2, '0');
    String year = date.year.toString();
    return '$day/$month/$year';
  } catch (e) {
    return 'Không rõ';
  }
}

class Detail extends StatefulWidget {
  final Book book;

  const Detail({super.key, required this.book});

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  late Future<List<Book>> futureBooksCungLoai;
  final Book_Controller bookController = Get.put(Book_Controller());
  final CartController cartController = Get.put(CartController());

  @override
  void initState() {
    super.initState();
    futureBooksCungLoai = bookController.fetchBooksCungLoai(widget.book.loaiID, widget.book.id);
  }

  @override
  Widget build(BuildContext context) {
    final book = widget.book;
    return Scaffold(
      appBar: AppBar(
        title: Text("Chi tiết sách"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    book.anh,
                    width: 140,
                    height: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.broken_image, size: 100),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(book.tenSach, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text("Tác giả: ${book.tacGia}", style: TextStyle(fontSize: 16)),
                        SizedBox(height: 4),
                        Text("Giá: ${book.gia}đ", style: TextStyle(fontSize: 16, color: Colors.red)),
                        SizedBox(height: 4),
                        Text(
                          "Ngày phát hành: ${formatNgay(book.ngayXB)}",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 4),
                        Text("Nhà xuất bản: ${book.nhaXB}", style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16),
              Text("Mô tả:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text(
                book.moTa,
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                // onPressed: () {
                //   final cartController = Get.find<CartController>();
                //   cartController.addToCart(book, 1);
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     SnackBar(content: Text("Đã thêm vào giỏ hàng")),
                //   );
                // },
                onPressed: () async {
                  // final cartController = Get.find<CartController>();
                  // await cartController.addToCart(book, 1);
                  AuthResponse? res = Common.response;
                  if (res == null) {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoginPage(),)
                    );
                    return;
                  }
                  // cartController.auth(res);
                  await cartController.addToCart(book, res);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Đã thêm vào giỏ hàng")),
                  );
                },

                child: Text("Thêm vào giỏ hàng", style: TextStyle(color: Colors.black)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 24),
              Text("Các sách cùng loại bạn có thể thích:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 8),

              // FutureBuilder để hiển thị danh sách sách cùng loại
              FutureBuilder<List<Book>>(
                future: futureBooksCungLoai,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text("Lỗi: ${snapshot.error}");
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text("Không có sách cùng loại.");
                  }
                  final books = snapshot.data!;
                  return Column(
                    children: books.map((b) {
                      return ListTile(
                        leading: Image.network(
                          b.anh,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.broken_image),
                        ),
                        title: Text(b.tenSach),
                        subtitle: Text("Tác giả: ${b.tacGia}"),
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Detail(book: b),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
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

          Get.to(PageGioHang());
        },
        backgroundColor: Colors.pinkAccent,
        child: const Icon(Icons.shopping_cart),
      ),
    );

  }
}
