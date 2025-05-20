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

  Map<String, dynamic> toJson(int code) {
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
      book: Book.fromJson(json["book"]),
      sl: int.parse(json["sl"]),
      selected: json["selected"].toLowerCase() == 'true',
    );
  }
//
}

class  CartSnapShot {
  static Map<String, dynamic> addOrder(
      double sum, String s, int code, int user, String note,String name,
      String phone,) {
    return {
      'id': code,
      'user_id': user,
      'ngayTao': DateTime.now().toIso8601String().split('T')[0],
      'tinhTien': sum,
      'diaChi': s,
      'ghiChu': note,  // Ghi chú đơn hàng
      'nguoiNhan': name,   // Thêm tên
      'phone': phone,   // Thêm số điện thoại
    };
  }
  static Future<void> insert(
      List<CartItem> list, int userId, String address, String note,String name,
      String phone,) async {
    final supabase = Supabase.instance.client;
    int code = DateTime.now().millisecondsSinceEpoch;

    String addr = address.trim();

    // Tính tổng tiền
    double sum = 0;
    for (CartItem i in list) {
      sum += i.book.gia * i.sl;
    }
    final dataOrder = CartSnapShot.addOrder(sum, addr, code, userId, note, name, phone);
    print('Dữ liệu order gửi lên: $dataOrder');

    // Thêm vào bảng Orders
    await supabase
        .from("Orders")
        .insert(CartSnapShot.addOrder(sum, addr, code, userId, note, name, phone))
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

class GioHangSnapshot{
  static Future<List<CartItem>> getALL(int uuid) async{
    var response = await supabase.from("GioHang").select("soLuong, Book(*)").eq("id_user", uuid);
    return response.map((e) => CartItem.fromJson(e),).toList();
  }

    static Future<void> insert(CartItem gh, int uuid) async{
    await supabase.from("GioHang").insert({
      "id_book" :gh.book.id,
      "id_user": uuid,
      "soLuong": gh.sl
    });
  }

  static Future<void> update(CartItem gh, int uuid) async{
    await supabase.from("GioHang").upsert({
      "id_book" :gh.book.id,
      "id_user": uuid,
      "soLuong": gh.sl
    });
  }

  static Future<void> delete(int idFruit, int uuid) async{
    await supabase.from("GioHang").delete()
        .eq("id_book", idFruit)
        .eq("id_user", uuid);
  }
}


