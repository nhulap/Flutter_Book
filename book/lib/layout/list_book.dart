import 'package:book/Async/asyncwidget.dart';
import 'package:book/Controller/book_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../Model/book.dart';

class ListBook extends StatelessWidget {
  const ListBook({super.key});

  @override
  Widget build(BuildContext context) {
    final bookController = Get.put(Book_Controller());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Trang chỉnh sửa sản phẩm của admin"),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<List<Book>>(
        future: bookController.fetchBooks(),
        builder: (context, snapshot) {
          return AsyncWidget(
            snapshot: snapshot,
            loading: () => const Center(child: CircularProgressIndicator()),
            error: () => const Center(child: Text("Không thể tải dữ liệu")),
            builder: (context, snapshot) {
              final books = snapshot.data!;
              return ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: books.length,
                separatorBuilder: (_, __) => const Divider(),

                itemBuilder: (context, index) {
                  final book = books[index];
                  return Slidable(
                    key: ValueKey(book.id),
                    endActionPane: ActionPane(
                      extentRatio: 0.55,
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            // Chuyển sang trang sửa sách
                          },
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          label: 'Sửa',
                        ),
                        SlidableAction(
                          onPressed: (context) async {
                            bool xacNhan = await showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text("Xác nhận"),
                                content: Text("Bạn có chắc muốn xóa sách '${book.tenSach}' không?"),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text("Hủy"),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    child: const Text("OK"),
                                  ),
                                ],
                              ),
                            );

                            // if (xacNhan) {
                            //   await bookController.deleteBook(book.id);
                            //   ScaffoldMessenger.of(context).showSnackBar(
                            //     SnackBar(content: Text("Đã xóa sách: ${book.tenSach}")),
                            //   );
                            //   bookController.refreshBooks();
                            // }
                          },
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Xóa',
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.network(
                          book.anh,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image),
                        ),
                      ),
                      title: Text(book.tenSach,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      subtitle: Text(
                        "Tác giả: ${book.tacGia}\nGiá: ${book.gia}đ",
                        style: const TextStyle(height: 1.5),
                      ),
                      trailing: const Icon(Icons.arrow_back_ios, size: 16), // 👈 phần bạn yêu cầu
                      onTap: () {
                        // TODO: mở chi tiết sách nếu muốn
                      },
                    ),
                  )
                  ;
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Chuyển sang trang thêm sách
          // Ví dụ: Navigator.push(...PageAddBook());
        },
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
      ),
    );
  }
}
