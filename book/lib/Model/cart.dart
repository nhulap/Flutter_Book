import 'package:book/Model/book.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CartItem {
  final Book book;
  int sl;
  bool selected;

  CartItem({
    required this.book,
    this.sl = 1,
    this.selected = true,
  });

  Map<String, dynamic> toJson(int code) {
    return {
      'order_id': code,
      'book_id': book.id,
      'soLuongitem': sl,
      'giaBan': book.gia,
      'trangThai': 'đã đặt',
    };
  }

// Nếu cần dùng lại thì sửa lại đoạn này đúng với dữ liệu từ bảng Order_items
/*
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      book: Book(id: json['book_id'], ten: "", gia: json['giaBan']),
      sl: json['soLuongitem'],
      selected: json['trangThai'] == 'đã đặt',
    );
  }
  */
}

class  CartSnapShot {
  static Map<String, dynamic> addOrder(
      double sum, String s, int code, int user, String note) {
    return {
      'id': code,
      'user_id': user,
      'ngayTao': DateTime.now().toIso8601String().split('T')[0],
      'tinhTien': sum,
      'diaChi': s,
      'ghiChu': note,  // Ghi chú đơn hàng
    };
  }

  static Future<void> insert(
      List<CartItem> list, int userId, List<String> address, String note) async {
    final supabase = Supabase.instance.client;
    String addr = "";
    int code = DateTime.now().millisecondsSinceEpoch;

    // Gộp địa chỉ
    for (int i = 3; i < address.length; i++) {
      addr += "${address[i]} ";
    }

    // Tính tổng tiền
    double sum = 0;
    for (CartItem i in list) {
      sum += i.book.gia * i.sl;
    }

    // Thêm vào bảng Orders
    await supabase
        .from("Orders")
        .insert(CartSnapShot.addOrder(sum, addr.trim(), code, userId, note))
        .then((value) => print("Đã thêm order"))
        .catchError((error) => print("Lỗi thêm order: $error"));

    // Thêm từng sản phẩm vào Order_items
    for (CartItem i in list) {
      await supabase
          .from("Order_items")
          .insert(i.toJson(code))
          .then((value) => print("Đã thêm order_item"))
          .catchError((error) => print("Lỗi thêm order_item: $error"));
    }
  }
}

