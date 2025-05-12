import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../Model/book.dart';

Future<List<Book>> fetchBooksCungLoai(int loaiID, int bookID) async {
  final response = await Supabase.instance.client
      .from('Book')
      .select()
      .eq('loaiID', loaiID)
      .neq('id', bookID); // Không lấy chính quyển sách đang xem

  return (response as List)
      .map((bookJson) => Book.fromJson(bookJson))
      .toList();
}

class PageChiTietSach extends StatefulWidget {
  final Book book;

  const PageChiTietSach({super.key, required this.book});

  @override
  State<PageChiTietSach> createState() => _PageChiTietSachState();
}

class _PageChiTietSachState extends State<PageChiTietSach> {
  late Future<List<Book>> futureBooksCungLoai;

  @override
  void initState() {
    super.initState();
    futureBooksCungLoai = fetchBooksCungLoai(widget.book.loaiID, widget.book.id);
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
              /// (1) Thông tin chi tiết như cũ...
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
                        Text("Ngày phát hành:${book.ngayXB}" ),
                        SizedBox(height: 4),
                        Text("Nhà xuất bản: ${book.nhaXB}", style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16),
              Text("Mô tả:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text(book.moTa, style: TextStyle(fontSize: 14)),

              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
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

              /// (2) FutureBuilder để hiển thị danh sách sách cùng loại
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
                              builder: (context) => PageChiTietSach(book: b),
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
    );
  }
}
