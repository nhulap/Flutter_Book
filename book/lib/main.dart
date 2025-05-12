import 'package:book/PageHome/pagehome.dart';
import 'package:book/layout/list_book.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://xnpxwakxnrcglsckrybj.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhucHh3YWt4bnJjZ2xzY2tyeWJqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDYxNDk3ODYsImV4cCI6MjA2MTcyNTc4Nn0.MklDJnuSB-ioYc4kS5EtnyrCFvppT4UV2Q6F4W7Z8Zo',
  );
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: kIsWeb ? const ListBook() : const PageHome(),
      //Web ==> Admin
      //App ==>Shop
    );
  }
}

final supabase = Supabase.instance.client;
