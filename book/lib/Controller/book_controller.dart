

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../Model/book.dart';

class Book_Controller extends GetxController{
  final SupabaseClient _client = Supabase.instance.client;

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

}