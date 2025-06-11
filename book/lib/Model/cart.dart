import 'package:book/Model/book.dart';
import 'package:book/main.dart';

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

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      book: Book.fromJson(json["Book"]),
      sl: json["soLuong"] ?? 1,
      selected: true, 
    );
  }
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


}
