import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../Model/book.dart';

class Book_Controller extends GetxController{
  final SupabaseClient _client = Supabase.instance.client;
  Future<List<Book>>? futureBooks;
  //ham lay danh sach tu supabase
  Future<List<Book>> fetchBooks() async {
    final response = await _client
        .from('Book')
        .select()
        .order('id', ascending: true);

    return (response as List)
        .map((bookJson) => Book.fromJson(bookJson))
        .toList();
  }

  Future<List<Book>> searchBooks(String query) async {
    final result =
    await _client.from('Book').select('*').ilike('tenSach', '%$query%');
    if ((result as List).isEmpty) {
      return [];
    }
    final data = result as List;
    return data.map((e) => Book.fromJson(e)).toList();
  }

  void updateSearch(String query) {
    futureBooks = query.isEmpty ? fetchBooks() : searchBooks(query);
    update();
  }

  // Hàm lấy 6 sản phẩm còn ít nhất trong kho cho sản phẩm ưa thích best seller
  Future<List<Book>> bestSellerBooks() async {
    final response = await _client
        .from('Book')
        .select()
        .gte('soLuong', 1)
        .order('soLuong', ascending: true)
        .limit(6);

    return (response as List)
        .map((bookJson) => Book.fromJson(bookJson))
        .toList();
  }

  Future<List<Book>> fetchBooksCungLoai(int loaiID, int bookID) async {
    final response = await Supabase.instance.client
        .from('Book')
        .select()
        .eq('loaiID', loaiID)
        .neq('id', bookID);

    return (response as List)
        .map((bookJson) => Book.fromJson(bookJson))
        .toList();
  }


}