import 'package:book/Model/book.dart';

class CartItem {
  final Book book; // Lưu toàn bộ đối tượng Book thay vì chỉ lưu id
  late final int soLuong;
  late final bool selected;

  CartItem({
    required this.book,
    required this.soLuong,
    this.selected = true,
  });

  // Chuyển CartItem thành Map để lưu vào cơ sở dữ liệu
  Map<String, dynamic> toJson(int code) {
    return {
      'order_id': code,
      'book_id': book.id, // Lưu lại bookId
      'quantity': soLuong,
      'price': book.gia, // Lưu giá sách
      'state': 'đã đặt',
    };
  }

  // Phương thức khôi phục CartItem từ Map
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      book: Book.fromJson(json['book']), // Giải mã đối tượng Book từ Map
      soLuong: json['quantity'],
      selected: json['state'] == 'đã đặt',
    );
  }
}
