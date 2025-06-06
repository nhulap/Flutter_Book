import 'package:book/Model/book.dart';
import 'package:book/main.dart';
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


  Map<String, dynamic> toJson() {
    return {
      'book': book.toJson(),
      'soLuong': sl,
      'selected': selected,
    };
  }

  Map<String, dynamic> toJsonWithCode(int code) {
    return {
      'order_id': code,
      'book_id': book.id,
      'soLuongitem': sl,
      'giaBan': book.gia,
      'trangThai': 'đã đặt',
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      book: Book.fromJson(json["Book"]),
      sl: json["soLuong"] ?? 1,
      selected: true, // không có cột selected trong Supabase nên mặc định true
    );
  }

//
}

class GioHangSnapshot {
  static Future<List<CartItem>> getALL(String userId) async {
    final response = await supabase
        .from("Cart")
        .select("soLuong, Book(*)")
        .eq("user_id", userId);

    return response.map((e) => CartItem.fromJson(e)).toList();
  }

  static Future<void> insert(CartItem gh, String userId) async {
    await supabase.from("Cart").insert({
      "book_id": gh.book.id,
      "user_id": userId,
      "soLuong": gh.sl,
    });
  }

  static Future<void> update(CartItem gh, String userId) async {
    await supabase.from("Cart").upsert({
      "book_id": gh.book.id,
      "user_id": userId,
      "soLuong": gh.sl,
    });
  }

  static Future<void> delete(int bookId, String userId) async {
    await supabase
        .from("Cart")
        .delete()
        .eq("book_id", bookId)
        .eq("user_id", userId);
  }

  // Hàm tạo đơn hàng từ giỏ hàng
  // static Future<void> createOrderFromCart(
  //     String userId,
  //     String address,
  //     String note,
  //     String name,
  //     String phone,
  //     ) async {
  //   final supabase = Supabase.instance.client;
  //
  //   // Lấy danh sách CartItem hiện tại của user
  //   final List<CartItem> cartItems = await getALL(userId);
  //
  //   if (cartItems.isEmpty) {
  //     print('Giỏ hàng rỗng, không thể tạo đơn');
  //     return;
  //   }
  //
  //   // Tạo mã đơn hàng
  //   int code = DateTime.now().millisecondsSinceEpoch;
  //
  //   // Tính tổng tiền
  //   double sum = 0;
  //   for (var item in cartItems) {
  //     sum += item.book.gia * item.sl;
  //   }
  //
  //   // Dữ liệu đơn hàng
  //   final dataOrder = {
  //     'id': code,
  //     'user_id': userId,
  //     'ngayTao': DateTime.now().toIso8601String().split('T')[0],
  //     'tinhTien': sum,
  //     'diaChi': address.trim(),
  //     'ghiChu': note.trim(),
  //     'nguoiNhan': name.trim(),
  //     'phone': phone.trim(),
  //   };
  //
  //   try {
  //     // Thêm vào bảng Orders
  //     await supabase.from('Orders').insert(dataOrder);
  //     print('Đã thêm đơn hàng');
  //
  //     // Thêm từng sản phẩm vào Order_items
  //     for (var item in cartItems) {
  //       final orderItemData = {
  //         'order_id': code,
  //         'book_id': item.book.id,
  //         'soLuongitem': item.sl,
  //         'giaBan': item.book.gia,
  //         'trangThai': 'đã đặt',
  //       };
  //       await supabase.from('Order_items').insert(orderItemData);
  //     }
  //     print('Đã thêm các sản phẩm vào đơn hàng');
  //
  //     // Nếu muốn, xóa hết giỏ hàng sau khi đặt thành công
  //     await supabase.from('Cart').delete().eq('user_id', userId);
  //     print('Đã xóa giỏ hàng sau khi đặt');
  //
  //   } catch (e) {
  //     print('Lỗi khi tạo đơn hàng: $e');
  //   }
  // }
}
